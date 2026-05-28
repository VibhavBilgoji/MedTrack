import 'dart:convert';
import 'package:flutter/services.dart';
import '../../features/medicines/domain/entities/medicine_entity.dart';

class MedicineInfo {
  final String name;
  final String composition;
  final String company;
  final double price;
  final String category;
  final String type;
  final String packSize;

  const MedicineInfo({
    required this.name,
    required this.composition,
    required this.company,
    required this.price,
    required this.category,
    this.type = 'allopathy',
    this.packSize = '',
  });

  factory MedicineInfo.fromJson(Map<String, dynamic> json) {
    final name = json['n'] as String? ?? '';
    return MedicineInfo(
      name: name,
      composition: json['c'] as String? ?? '',
      company: json['m'] as String? ?? '',
      price: (json['p'] as num?)?.toDouble() ?? 0.0,
      category: _inferCategory(name),
      type: json['t'] as String? ?? 'allopathy',
      packSize: json['s'] as String? ?? '',
    );
  }

  static String _inferCategory(String name) {
    final n = name.toLowerCase();
    if (n.contains('syrup') || n.contains('suspension') || n.contains('liquid')) return 'Syrup / Liquid';
    if (n.contains('inj') || n.contains('vial') || n.contains('ampoule')) return 'Injection / Vial';
    if (n.contains('cream') || n.contains('ointment') || n.contains('gel')) return 'Ointment / Cream';
    if (n.contains('drop')) return 'Drops (Eye/Ear/Nasal)';
    if (n.contains('inhaler') || n.contains('spray')) return 'Inhaler / Spray';
    if (n.contains('tab') || n.contains('cap') || n.contains('softgel')) return 'Tablet / Capsule';
    return 'Other';
  }
}

class MedicineDatabase {
  static List<MedicineInfo> _allMedicines = [];
  static bool _isLoading = false;

  /// Initial mock data for fallback or development
  static const List<MedicineInfo> mockMedicines = [
    MedicineInfo(name: 'Crocin Advance', composition: 'Paracetamol 500mg', company: 'GSK', price: 25.0, category: 'Tablet / Capsule'),
    MedicineInfo(name: 'Dolo 650', composition: 'Paracetamol 650mg', company: 'Micro Labs', price: 30.0, category: 'Tablet / Capsule'),
  ];

  static List<MedicineInfo> get loadedMedicines => _allMedicines.isNotEmpty ? _allMedicines : mockMedicines;

  static Future<void> init() async {
    if (_isLoading || _allMedicines.isNotEmpty) return;
    _isLoading = true;
    try {
      final jsonStr = await rootBundle.loadString('assets/data/medicines_compact.json');
      final List<dynamic> data = jsonDecode(jsonStr);
      _allMedicines = data.map((item) => MedicineInfo.fromJson(item)).toList();
    } catch (e) {
      print('Error loading medicine database: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Efficiently search for medicines (Brand name or Composition)
  static List<MedicineInfo> search(String query) {
    if (query.length < 2) return [];
    final q = query.toLowerCase();
    return loadedMedicines.where((m) =>
      m.name.toLowerCase().contains(q) ||
      m.composition.toLowerCase().contains(q)
    ).take(20).toList(); // Limit results for performance
  }

  /// Finds medicines with the same composition but cheaper than the provided price
  static List<MedicineInfo> findCheaperAlternatives(String composition, double currentPrice, String excludeName) {
    if (composition.isEmpty) return [];
    
    final comp = composition.toLowerCase().trim();
    // Use a more fuzzy composition matching if needed, but strict for now
    return loadedMedicines.where((med) {
      final medComp = med.composition.toLowerCase().trim();
      return medComp == comp &&
             med.price < currentPrice &&
             med.name.toLowerCase() != excludeName.toLowerCase();
    }).toList()
      ..sort((a, b) => a.price.compareTo(b.price));
  }
}
