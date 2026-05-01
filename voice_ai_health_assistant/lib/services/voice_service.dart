import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _isInitialized = await _speechToText.initialize();
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    }
  }

  bool get isListening => _speechToText.isListening;

  Future<void> startListening(Function(String) onResult) async {
    if (!_isInitialized) await init();
    
    if (_isInitialized) {
      await _speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenFor: const Duration(seconds: 15),
        pauseFor: const Duration(seconds: 3),
      );
    }
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }
}
