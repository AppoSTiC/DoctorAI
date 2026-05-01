import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/voice_service.dart';

class ChatController extends ChangeNotifier {
  final AiService _aiService = AiService();
  final VoiceService _voiceService = VoiceService();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isListening = false;
  bool get isListening => _isListening;

  String _currentSpokenText = '';

  Future<void> init() async {
    await _voiceService.init();
  }

  Future<void> toggleListening() async {
    if (_isListening) {
      await _stopListeningAndProcess();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    _isListening = true;
    _currentSpokenText = '';
    await _voiceService.stopSpeaking(); // stop any ongoing AI voice
    notifyListeners();

    await _voiceService.startListening((text) {
      _currentSpokenText = text;
    });
  }

  Future<void> _stopListeningAndProcess() async {
    await _voiceService.stopListening();
    _isListening = false;
    notifyListeners();

    if (_currentSpokenText.isNotEmpty) {
      await _processUserMessage(_currentSpokenText);
    }
  }

  Future<void> _processUserMessage(String text) async {
    // Add user message
    _messages.add(ChatMessage(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    // Get AI response
    final response = await _aiService.getAiResponse(text);

    // Add AI message
    _messages.add(ChatMessage(text: response, isUser: false));
    _isLoading = false;
    notifyListeners();

    // Speak AI response
    await _voiceService.speak(response);
  }
}
