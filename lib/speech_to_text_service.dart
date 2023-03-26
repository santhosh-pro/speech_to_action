import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final _speech = SpeechToText();

  Future<bool> toggleRecording({
    required Function(String text) onResult,
    required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      // ignore: avoid_print
      onError: (e) => print('Error: $e'),
      debugLogging: true,
    );

    if (isAvailable) {
      _speech.listen(onResult: (value) => onResult(value.recognizedWords));
    }

    return isAvailable;
  }
}
