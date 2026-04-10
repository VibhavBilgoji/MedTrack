import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/providers/providers.dart';
import '../../../../core/utils/expiry_risk_engine.dart';
import '../../domain/entities/medicine_entity.dart';
import '../controllers/medicine_controller.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  final MedicineEntity? existing; // non-null = edit mode
  const AddMedicineScreen({super.key, this.existing});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _batchCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _shelfLifeCtrl;
  String _category = MedicineCategories.all.first;
  DateTime? _expiryDate;
  DateTime? _mfgDate;
  bool _notifEnabled = true;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _batchCtrl = TextEditingController(text: e?.batchNumber ?? '');
    _notesCtrl = TextEditingController(text: e?.notes ?? '');
    _shelfLifeCtrl = TextEditingController(text: e?.shelfLifeMonths?.toString() ?? '');
    _category = e?.category ?? MedicineCategories.all.first;
    _expiryDate = e?.expiryDate;
    _mfgDate = e?.manufacturingDate;
    _notifEnabled = e?.notificationEnabled ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _batchCtrl.dispose();
    _notesCtrl.dispose();
    _shelfLifeCtrl.dispose();
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
    );

    final ctrl = ref.read(medicineFormControllerProvider.notifier);
    final ok = _isEdit ? await ctrl.updateMedicine(medicine) : await ctrl.addMedicine(medicine);

    if (ok && mounted) {
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
                  onPressed: () => context.push(AppRoutes.scanner),
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
              TextFormField(
                key: const Key('medicine_name'),
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'e.g. Paracetamol 500mg', prefixIcon: Icon(Icons.medication_outlined)),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
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
