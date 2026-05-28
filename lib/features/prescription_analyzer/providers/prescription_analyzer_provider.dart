import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/prescription_analysis.dart';

part 'prescription_analyzer_provider.freezed.dart';

// TODO: Keep this secure! Consider moving to environment variables later.
const String _geminiApiKey = 'YOUR_GEMINI_API_KEY_HERE';

@freezed
class PrescriptionAnalyzerState with _$PrescriptionAnalyzerState {
  const factory PrescriptionAnalyzerState.idle() = _Idle;
  const factory PrescriptionAnalyzerState.analyzing() = _Analyzing;
  const factory PrescriptionAnalyzerState.success(
    PrescriptionAnalysisResult result,
  ) = _Success;
  const factory PrescriptionAnalyzerState.error(String message) = _Error;
}

class PrescriptionAnalyzerNotifier
    extends StateNotifier<PrescriptionAnalyzerState> {
  PrescriptionAnalyzerNotifier() : super(const PrescriptionAnalyzerState.idle());

  Future<void> analyzeImage(File imageFile, List<String> existingMedNames) async {
    if (_geminiApiKey == 'YOUR_GEMINI_API_KEY_HERE' || _geminiApiKey.isEmpty) {
      state = const PrescriptionAnalyzerState.error(
          'Missing Gemini API Key. Please add it to prescription_analyzer_provider.dart');
      return;
    }

    state = const PrescriptionAnalyzerState.analyzing();

    try {
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: _geminiApiKey,
        generationConfig: GenerationConfig(
          temperature: 0.1,
          maxOutputTokens: 2048,
          responseMimeType: 'application/json',
        ),
      );

      final bytes = await imageFile.readAsBytes();

      const systemPrompt = '''
You are a clinical pharmacist assistant. Analyze the prescription image and extract ALL medicines.

Return ONLY valid JSON (no markdown, no explanation) in this exact schema:
{
  "medicines": [
    {
      "name": "string (generic name preferred)",
      "brandName": "string or null",
      "dosageAmount": "string e.g. '500mg', '10ml'",
      "timesPerDay": 1,
      "durationDays": 5, 
      "category": "tablet|capsule|syrup|injection|drops|cream|inhaler|other",
      "confidence": 0.95
    }
  ],
  "interactions": [
    {
      "medicineA": "string",
      "medicineB": "string",
      "severity": "mild|moderate|severe",
      "description": "string (max 120 chars)"
    }
  ],
  "warnings": ["string"],
  "doctorName": "string or null",
  "date": "2024-05-20"
}

Cross-check extracted medicines against the user's EXISTING medicines list (provided below) for interactions.
If you cannot read the prescription clearly, set confidence < 0.5 for affected fields.
''';

      final prompt = [
        Content.text('$systemPrompt\n\nExisting medicines in cabinet: ${existingMedNames.join(', ')}'),
        Content.data('image/jpeg', bytes),
      ];

      final response = await model.generateContent(prompt);
      final rawText = response.text ?? '{}';

      final parsed = jsonDecode(rawText) as Map<String, dynamic>;
      final result = PrescriptionAnalysisResult.fromJson(parsed);

      state = PrescriptionAnalyzerState.success(result);
    } catch (e) {
      state = PrescriptionAnalyzerState.error(e.toString());
    }
  }

  void reset() => state = const PrescriptionAnalyzerState.idle();
}

final prescriptionAnalyzerProvider = StateNotifierProvider<
    PrescriptionAnalyzerNotifier, PrescriptionAnalyzerState>(
  (ref) => PrescriptionAnalyzerNotifier(),
);
