import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/data/medicine_database.dart';

part 'medicine_ai_provider.freezed.dart';

// TODO: Move to environment variables
const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

@freezed
class MedicineAIState with _$MedicineAIState {
  const factory MedicineAIState.idle() = _Idle;
  const factory MedicineAIState.analyzingAlternatives() = _AnalyzingAlternatives;
  const factory MedicineAIState.alternativesSuccess(String advice) = _AlternativesSuccess;
  const factory MedicineAIState.analyzingGuide() = _AnalyzingGuide;
  const factory MedicineAIState.guideSuccess({
    required String uses,
    required String timing,
    required String warnings,
  }) = _GuideSuccess;
  const factory MedicineAIState.error(String message) = _Error;
}

class MedicineAINotifier extends StateNotifier<MedicineAIState> {
  MedicineAINotifier() : super(const MedicineAIState.idle());

  Future<void> analyzeAlternatives(MedicineInfo original, List<MedicineInfo> alternatives) async {
    if (alternatives.isEmpty) return;
    
    state = const MedicineAIState.analyzingAlternatives();
    
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _geminiApiKey,
      );

      final altList = alternatives.take(3).map((a) => "${a.name} by ${a.company} at ₹${a.price}").join(", ");
      
      final prompt = '''
      You are a smart medicine shopping assistant. 
      The user is looking at "${original.name}" (${original.composition}) which costs ₹${original.price}.
      There are cheaper alternatives available: $altList.
      
      Provide a very brief (2 sentences max) professional advice on why these alternatives are equivalent 
      (mentioning they have the same salt/composition) and highlighting the potential savings.
      Keep it encouraging and clinical.
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      state = MedicineAIState.alternativesSuccess(response.text ?? 'No advice available.');
    } catch (e) {
      state = MedicineAIState.error(e.toString());
    }
  }

  Future<void> getMedicineGuide(MedicineInfo medicine) async {
    state = const MedicineAIState.analyzingGuide();
    
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: _geminiApiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final prompt = '''
      You are a clinical pharmacist. Provide a patient-friendly guide for "${medicine.name}" (${medicine.composition}).
      
      Return ONLY valid JSON in this schema:
      {
        "uses": "Primary conditions this medicine treats (max 100 chars)",
        "timing": "Best time to take (e.g. Before food, After food, Night) and why",
        "warnings": "Critical safety warnings or common side effects (max 150 chars)"
      }
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      final data = jsonDecode(response.text ?? '{}');
      
      state = MedicineAIState.guideSuccess(
        uses: data['uses'] ?? 'N/A',
        timing: data['timing'] ?? 'N/A',
        warnings: data['warnings'] ?? 'N/A',
      );
    } catch (e) {
      state = MedicineAIState.error(e.toString());
    }
  }

  void reset() => state = const MedicineAIState.idle();
}

final medicineAIProvider = StateNotifierProvider<MedicineAINotifier, MedicineAIState>((ref) {
  return MedicineAINotifier();
});
