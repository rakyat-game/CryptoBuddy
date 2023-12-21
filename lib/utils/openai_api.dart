import 'package:dart_openai/dart_openai.dart';

class OpenAIService {
  static final OpenAIService _instance = OpenAIService._internal();
  final String _apiKey = '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';

  factory OpenAIService() {
    return _instance;
  }
  OpenAIService._internal() {
    OpenAI.apiKey = _apiKey;
  }
  Future<String> getCoinDescription(String coin) async {
    final completion = await OpenAI.instance.completion.create(
      model: "text-davinci-003",
      prompt: "Describe the cryptocurrency $coin",
      maxTokens: 80,
    );
    return completion.choices[0].text.trim();
  }
}

// Future<void> main() async {
//   var description = await OpenAIService().getCoinDescription('Bitcoin');
//   print(description);
// }
