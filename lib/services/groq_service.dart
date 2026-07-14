import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String _apiKey = 'GROQ_API_KEY'; // paste gsk_... key here

  Future<Map<String, dynamic>> analyzeProduct({
    required String productName,
    required String productUrl,
  }) async {
    try {
      print('=== Groq: Starting analysis ===');

      final prompt = '''
You are a scam detection AI. Analyze this online product listing.

Product Name: $productName
Product URL: $productUrl

Analyze the URL domain, product name, and any suspicious patterns.

Return ONLY this JSON format, nothing else:
{
  "trustScore": 75,
  "recommendation": "safe",
  "explanation": "This product appears to be from a reputable seller.",
  "redFlags": [],
  "reviewScore": 80,
  "sellerScore": 70,
  "priceScore": 75
}

Rules:
- trustScore: number 0-100 (0=scam, 100=very safe)
- recommendation: only "safe", "caution", or "avoid"
- explanation: 2-3 sentences explaining the score
- redFlags: list of specific concerns, empty array if none
- reviewScore: 0-100 score for review authenticity
- sellerScore: 0-100 score for seller reliability
- priceScore: 0-100 score for price legitimacy

Return ONLY the JSON. No markdown. No backticks. No extra text.
''';

      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'temperature': 0.3,
          'max_tokens': 500,
        }),
      );

      print('=== Groq status: ${response.statusCode} ===');
      print('=== Groq body: ${response.body} ===');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;

        print('=== Groq response text: $text ===');

        String cleanText = text.trim();
        cleanText = cleanText.replaceAll('```json', '');
        cleanText = cleanText.replaceAll('```', '');
        cleanText = cleanText.trim();

        return _parseJson(cleanText);
      } else {
        throw Exception('Groq API error: ${response.statusCode} ${response.body}');
      }
    } catch (e, stackTrace) {
      print('=== Groq Error: $e ===');
      print('=== Stack: $stackTrace ===');
      return {
        'trustScore': 50.0,
        'recommendation': 'caution',
        'explanation': 'Unable to analyze this product. Please try again.',
        'redFlags': ['Analysis failed'],
        'reviewScore': 50.0,
        'sellerScore': 50.0,
        'priceScore': 50.0,
      };
    }
  }

  Map<String, dynamic> _parseJson(String text) {
    try {
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}');
      if (start == -1 || end == -1) throw Exception('No JSON found');

      final jsonStr = text.substring(start, end + 1);
      final decoded = jsonDecode(jsonStr);

      return {
        'trustScore': (decoded['trustScore'] ?? 50).toDouble(),
        'recommendation': decoded['recommendation'] ?? 'caution',
        'explanation': decoded['explanation'] ?? '',
        'redFlags': List<String>.from(decoded['redFlags'] ?? []),
        'reviewScore': (decoded['reviewScore'] ?? 50).toDouble(),
        'sellerScore': (decoded['sellerScore'] ?? 50).toDouble(),
        'priceScore': (decoded['priceScore'] ?? 50).toDouble(),
      };
    } catch (e) {
      print('=== JSON Parse Error: $e ===');
      return {
        'trustScore': 50.0,
        'recommendation': 'caution',
        'explanation': 'Could not parse analysis result.',
        'redFlags': [],
        'reviewScore': 50.0,
        'sellerScore': 50.0,
        'priceScore': 50.0,
      };
    }
  }
}