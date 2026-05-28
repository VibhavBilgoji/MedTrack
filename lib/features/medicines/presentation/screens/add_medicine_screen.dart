import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/services/notification_service.dart';
import '../../../../core/utils/date_parser.dart';
import '../../../../core/utils/expiry_risk_engine.dart';
import '../../domain/entities/medicine_entity.dart';
import '../controllers/medicine_controller.dart';
import '../../../prescription_analyzer/models/prescription_analysis.dart';
import '../../../../core/data/medicine_database.dart';
import '../widgets/cheaper_alternatives_sheet.dart';
import '../../providers/medicine_ai_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  final MedicineEntity? existing; // non-null = edit mode
  final ExtractedMedicine? extracted; // from AI scanner
  const AddMedicineScreen({super.key, this.existing, this.extracted});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _batchCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _shelfLifeCtrl;
  late final TextEditingController _dosageCtrl;
  String _category = MedicineCategories.all.first;
  DateTime? _expiryDate;
  DateTime? _mfgDate;
  bool _notifEnabled = true;
  // ── Dosage schedule ──
  int _timesPerDay = 1;
  List<TimeOfDay> _doseSlots = [const TimeOfDay(hour: 8, minute: 0)];
  bool _reminderEnabled = true;
  bool get _isEdit => widget.existing != null;

  MedicineInfo? _selectedMedicineInfo;
  List<MedicineInfo> _alternatives = [];

  void _onNameCtrlChanged() {
    final val = _nameCtrl.text;
    if (val.trim().isEmpty) {
      if (_selectedMedicineInfo != null) {
        setState(() {
          _selectedMedicineInfo = null;
          _alternatives = [];
        });
      }
      return;
    }
    final match = MedicineDatabase.loadedMedicines.where((m) => m.name.toLowerCase() == val.trim().toLowerCase()).firstOrNull;
    if (match != _selectedMedicineInfo) {
      setState(() {
        _selectedMedicineInfo = match;
        if (match != null) {
          _alternatives = MedicineDatabase.findCheaperAlternatives(match.composition, match.price, match.name);
          // Trigger AI Guide
          Future.microtask(() => ref.read(medicineAIProvider.notifier).getMedicineGuide(match));
        } else {
          _alternatives = [];
          ref.read(medicineAIProvider.notifier).reset();
        }
      });
    }
  }

  void _selectAlternative(MedicineInfo alt) {
    setState(() {
      _nameCtrl.text = alt.name;
      _category = MedicineCategories.all.contains(alt.category) ? alt.category : MedicineCategories.all.first;
      _selectedMedicineInfo = alt;
      _alternatives = MedicineDatabase.findCheaperAlternatives(alt.composition, alt.price, alt.name);
    });
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    final ext = widget.extracted;

    _nameCtrl = TextEditingController(text: e?.name ?? ext?.name ?? '');
    _nameCtrl.addListener(_onNameCtrlChanged);
    _onNameCtrlChanged();

    _batchCtrl = TextEditingController(text: e?.batchNumber ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _shelfLifeCtrl = TextEditingController(text: e?.shelfLifeMonths?.toString() ?? '');
    _dosageCtrl = TextEditingController(text: e?.dosageAmount ?? ext?.dosageAmount ?? '');
    
    _category = e?.category ?? (ext != null ? '${ext.category.name[0].toUpperCase()}${ext.category.name.substring(1)}' : MedicineCategories.all.first);
    // ensure valid category
    if (!MedicineCategories.all.contains(_category)) _category = MedicineCategories.all.first;

    _expiryDate = e?.expiryDate;
    _mfgDate = e?.manufacturingDate;
    _notifEnabled = e?.notificationEnabled ?? true;
    _timesPerDay = e?.timesPerDay ?? ext?.timesPerDay ?? 1;
    _reminderEnabled = e?.reminderEnabled ?? true;
    if (e?.scheduledTimes.isNotEmpty == true) {
      _doseSlots = e!.scheduledTimes.map((t) {
        final parts = t.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }).toList();
    } else if (ext != null) {
      _updateDoseSlots(ext.timesPerDay); 
    } else {
      _doseSlots = [const TimeOfDay(hour: 8, minute: 0)];
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _batchCtrl.dispose();
    _notesCtrl.dispose();
    _shelfLifeCtrl.dispose();
    _dosageCtrl.dispose();
    super.dispose();
  }

  // ── Called from scanner ─────────────────────────────────────────────────────
  void applyScannedDate(DateTime date, double confidence) {
    setState(() => _expiryDate = date);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Expiry date auto-filled (${(confidence * 100).round()}% confidence)'),
      backgroundColor: AppColors.safe,
    ));
  }

  void applyDualScan(DualScanResult result) {
    setState(() {
      if (result.hasExpiry) _expiryDate = result.expiryDate!.date;
      if (result.hasMfd) _mfgDate = result.mfdDate!.date;
    });
    final msg = result.hasBoth
        ? 'Both MFD & EXP dates filled automatically!'
        : result.hasExpiry
            ? 'Expiry date auto-filled'
            : 'Manufacturing date auto-filled';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.safe));
  }

  void _updateDoseSlots(int count) {
    setState(() {
      _timesPerDay = count;
      while (_doseSlots.length < count) {
        final defaultHours = [8, 13, 18, 21];
        _doseSlots.add(TimeOfDay(hour: defaultHours[_doseSlots.length % 4], minute: 0));
      }
      while (_doseSlots.length > count) _doseSlots.removeLast();
    });
  }

  Future<void> _pickDoseTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _doseSlots[index],
    );
    if (picked != null) setState(() => _doseSlots[index] = picked);
  }

  void _pickExpiryDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (picked != null) setState(() => _expiryDate = picked);
  }

  void _pickMfgDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _mfgDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _mfgDate = picked);
      final sl = int.tryParse(_shelfLifeCtrl.text);
      if (sl != null && sl > 0) {
        setState(() => _expiryDate = _mfgDate!.add(Duration(days: sl * 30)));
      }
    }
  }

  void _computeFromMfg() {
    if (_mfgDate == null) return;
    final sl = int.tryParse(_shelfLifeCtrl.text);
    if (sl != null && sl > 0) {
      setState(() => _expiryDate = _mfgDate!.add(Duration(days: sl * 30)));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_expiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please set the expiry date'), backgroundColor: AppColors.warning),
      );
      return;
    }

    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    final scheduledTimeStrings = _doseSlots
        .map((t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}')
        .toList();

    final medicine = MedicineEntity(
      id: widget.existing?.id ?? const Uuid().v4(),
      userId: user.id,
      name: _nameCtrl.text.trim(),
      category: _category,
      expiryDate: _expiryDate!,
      manufacturingDate: _mfgDate,
      shelfLifeMonths: int.tryParse(_shelfLifeCtrl.text),
      status: ExpiryRiskEngine.classify(_expiryDate!),
      ocrConfidence: 0.0,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
      notificationEnabled: _notifEnabled,
      batchNumber: _batchCtrl.text.trim().isEmpty ? null : _batchCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      dosageAmount: _dosageCtrl.text.trim().isEmpty ? null : _dosageCtrl.text.trim(),
      timesPerDay: _timesPerDay,
      scheduledTimes: scheduledTimeStrings,
      reminderEnabled: _reminderEnabled,
    );

    final ctrl = ref.read(medicineFormControllerProvider.notifier);
    final ok = _isEdit ? await ctrl.updateMedicine(medicine) : await ctrl.addMedicine(medicine);

    if (ok && mounted) {
      // Schedule notifications
      await NotificationService().scheduleMedicineReminders(medicine);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_isEdit ? 'Medicine updated!' : 'Medicine added!'),
        backgroundColor: AppColors.safe,
      ));
      context.pop();
    } else if (mounted) {
      final err = ref.read(medicineFormControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err ?? AppStrings.genericError),
        backgroundColor: AppColors.critical,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(medicineFormControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = _expiryDate != null ? ExpiryRiskEngine.classify(_expiryDate!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Medicine' : AppStrings.addMedicine),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.critical),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scan button
              if (!_isEdit) ...[
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await context.push<dynamic>(AppRoutes.scanner);
                    if (result != null && result is DualScanResult && mounted) {
                      applyDualScan(result);
                    }
                  },
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  label: const Text(AppStrings.scanToFill),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                const _Divider(label: 'or enter manually'),
                const SizedBox(height: 20),
              ],
              // Name
              const _SectionLabel('Medicine Name *'),
              LayoutBuilder(
                builder: (context, constraints) => RawAutocomplete<MedicineInfo>(
                  textEditingController: _nameCtrl,
                  focusNode: FocusNode(),
                  displayStringForOption: (m) => m.name,
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    return MedicineDatabase.search(textEditingValue.text);
                  },
                  onSelected: (MedicineInfo selection) {
                    _nameCtrl.text = selection.name;
                    setState(() {
                      _category = MedicineCategories.all.contains(selection.category) ? selection.category : MedicineCategories.all.first;
                      _selectedMedicineInfo = selection;
                      _alternatives = MedicineDatabase.findCheaperAlternatives(selection.composition, selection.price, selection.name);
                      // Trigger AI Guide
                      Future.microtask(() => ref.read(medicineAIProvider.notifier).getMedicineGuide(selection));
                    });
                  },
                  fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                    return TextFormField(
                      key: const Key('medicine_name'),
                      controller: controller,
                      focusNode: focusNode,
                      onEditingComplete: onEditingComplete,
                      decoration: const InputDecoration(hintText: 'e.g. Paracetamol 500mg', prefixIcon: Icon(Icons.medication_outlined)),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 250, maxWidth: constraints.maxWidth),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return ListTile(
                                leading: const Icon(Icons.medication_outlined, color: AppColors.primary),
                                title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(option.composition, style: const TextStyle(fontSize: 12)),
                                trailing: Text('₹${option.price}'),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_alternatives.isNotEmpty && _selectedMedicineInfo != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => CheaperAlternativesSheet.show(
                    context,
                    originalMedicine: _selectedMedicineInfo!,
                    alternatives: _alternatives,
                    onSelectAlternative: _selectAlternative,
                  ),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.safe.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                      border: Border.all(color: AppColors.safe.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.savings_outlined, color: AppColors.safe, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_alternatives.length} cheaper alternative${_alternatives.length > 1 ? 's' : ''} available',
                                style: const TextStyle(color: AppColors.safe, fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              const Text(
                                'Tap to explore cost-saving options',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.safe),
                      ],
                    ),
                  ),
                ),
              ],
              
              // ── AI Medicine Guide ──────────────────────────────────────────
              if (_selectedMedicineInfo != null) ...[
                const SizedBox(height: 16),
                _MedicineAIAnalysisCard(medicine: _selectedMedicineInfo!),
              ],
              
              const SizedBox(height: 16),
              // Category
              const _SectionLabel('Category *'),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_outlined)),
                items: MedicineCategories.all.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: 16),
              // Expiry Date
              const _SectionLabel('Expiry Date *'),
              _DatePickerField(
                key: const Key('expiry_date'),
                label: _expiryDate != null ? _expiryDate!.display : 'Select expiry date',
                statusColor: status?.color,
                icon: Icons.event_rounded,
                onTap: _pickExpiryDate,
              ),
              if (status != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: status.containerColor,
                        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                      ),
                      child: Text(status.label, style: TextStyle(color: status.color, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              // Manufacturing Date
              const _SectionLabel('Manufacturing Date (optional)'),
              _DatePickerField(
                label: _mfgDate != null ? _mfgDate!.display : 'Select manufacturing date',
                icon: Icons.factory_outlined,
                onTap: _pickMfgDate,
              ),
              const SizedBox(height: 8),
              // Shelf life
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _shelfLifeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Shelf Life (months)', prefixIcon: Icon(Icons.timer_outlined)),
                      onChanged: (_) => _computeFromMfg(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _batchCtrl,
                      decoration: const InputDecoration(labelText: 'Batch No. (optional)', prefixIcon: Icon(Icons.tag_rounded)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              // Notification toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: SwitchListTile(
                  title: const Text('Expiry reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Get notified before this medicine expires'),
                  value: _notifEnabled,
                  onChanged: (v) => setState(() => _notifEnabled = v),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 20),

              // ── Dosage & Schedule ──────────────────────────────────────────
              const _Divider(label: 'Dosage & Schedule'),
              const SizedBox(height: 20),

              // Dosage amount
              const _SectionLabel('Dosage Amount (optional)'),
              TextFormField(
                controller: _dosageCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. 1 tablet, 5 ml',
                  prefixIcon: Icon(Icons.medication_liquid_outlined),
                ),
              ),
              const SizedBox(height: 16),

              // Times per day
              const _SectionLabel('Times Per Day'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(4, (i) {
                    final n = i + 1;
                    final selected = _timesPerDay == n;
                    return GestureDetector(
                      onTap: () => _updateDoseSlots(n),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 60, height: 40,
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                        ),
                        child: Center(
                          child: Text(
                            '${n}x',
                            style: TextStyle(
                              color: selected ? Colors.white : AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Time slots
              const _SectionLabel('Reminder Times'),
              ...List.generate(_doseSlots.length, (i) {
                final slot = _doseSlots[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _pickDoseTime(i),
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.alarm_rounded, color: AppColors.primary),
                        suffixIcon: const Icon(Icons.edit_outlined, size: 18),
                        labelText: 'Dose ${i + 1}',
                      ),
                      child: Text(
                        slot.format(context),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),

              // Reminder toggle
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: SwitchListTile(
                  title: const Text('Dose reminders', style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: const Text('Get notified when it\'s time to take medicine'),
                  value: _reminderEnabled,
                  onChanged: (v) => setState(() => _reminderEnabled = v),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(height: 32),
              // Save button
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  key: const Key('save_medicine'),
                  onPressed: formState.isLoading ? null : _save,
                  child: formState.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEdit ? AppStrings.saveChanges : 'Add Medicine', style: const TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteMedicine),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              ctx.pop();
              final user = ref.read(authStateProvider).value;
              if (user == null) return;
              await ref.read(medicineFormControllerProvider.notifier)
                  .deleteMedicine(user.id, widget.existing!.id);
              if (mounted) context.go(AppRoutes.medicines);
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.critical)),
          ),
        ],
      ),
    );
  }
}

class _MedicineAIAnalysisCard extends ConsumerWidget {
  final MedicineInfo medicine;
  const _MedicineAIAnalysisCard({required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiState = ref.watch(medicineAIProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withOpacity(0.05) : AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: aiState.when(
        idle: () => const SizedBox.shrink(),
        analyzingAlternatives: () => const SizedBox.shrink(),
        alternativesSuccess: (_) => const SizedBox.shrink(),
        analyzingGuide: () => const Center(
          child: Column(
            children: [
              SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              SizedBox(height: 8),
              Text('AI is preparing your medicine guide...', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
        guideSuccess: (uses, timing, warnings) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text('AI Smart Guide', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
            const SizedBox(height: 12),
            _GuideItem(icon: Icons.info_outline, title: 'What it\'s for', content: uses),
            const Divider(height: 20, thickness: 0.5),
            _GuideItem(icon: Icons.access_time_rounded, title: 'When to take', content: timing),
            const Divider(height: 20, thickness: 0.5),
            _GuideItem(icon: Icons.warning_amber_rounded, title: 'Safety Advice', content: warnings, color: AppColors.warning),
          ],
        ),
        error: (msg) => Text('Guide unavailable: $msg', style: const TextStyle(color: AppColors.critical, fontSize: 12)),
      ),
    );
  }
}

class _GuideItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color? color;

  const _GuideItem({required this.icon, required this.title, required this.content, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color ?? AppColors.textSecondary, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
  );
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? statusColor;

  const _DatePickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: statusColor),
          suffixIcon: const Icon(Icons.calendar_today_rounded, size: 18),
        ),
        child: Text(label, style: TextStyle(color: statusColor ?? AppColors.textSecondary)),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider({required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider()),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(label, style: Theme.of(context).textTheme.bodySmall),
      ),
      const Expanded(child: Divider()),
    ],
  );
}
