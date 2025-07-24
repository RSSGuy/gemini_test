
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/config/app_config.dart';


class AIService {
  final String _cloudFunctionUrl = AppConfig.aiCloudFunctionUrl;

  Future<String> generateContent(String prompt) async {
    if (_cloudFunctionUrl == 'NOT_SET') {
      await Future.delayed(const Duration(seconds: 2));
      return 'This is a mock AI response. Please configure your AI_CLOUD_FUNCTION_URL environment variable.';
    }

    try {
      final response = await http.post(
        Uri.parse(_cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['result'];
      } else {
        throw AIServiceException('Failed to generate content: ${response.body}');
      }
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s, reason: 'AI Service Failure');
      throw AIServiceException('Failed to connect to the AI service. Please check your network connection.');
    }
  }
}