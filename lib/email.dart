import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:speech_to_action/url_launcher_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SendEmail extends StatefulWidget {
  const SendEmail({super.key});

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  String text = 'Press the mic button and start speaking';
  bool isListening = false;
  final _speech = SpeechToText();

  Future toggleRecording() async {
    // return speechToTextService.toggleRecording(onResult: (text) {
    //   setState(() => this.text = text);
    // }, onListening: (bool value) {
    //   isListening = value;

    //   if (!isListening) {
    //     Future.delayed(const Duration(seconds: 1), () {
    //       UrlLauncherService.scanText("write email $text");
    //     });
    //   }
    // });

    if (_speech.isListening) {
      _speech.stop();
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => {
        setState(() => {
              isListening = _speech.isListening,
            }),
      },
      // ignore: avoid_print
      onError: (e) => print('Error: $e'),
      debugLogging: true,
    );

    if (isAvailable) {
      _speech.listen(
          onResult: (value) => {
                setState(() => {
                      text = value.recognizedWords,
                    }),
                if (_speech.isNotListening)
                  {
                    Future.delayed(const Duration(seconds: 1), () {
                      UrlLauncherService.scanText("write email $text");
                    })
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Email"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Icon(
            Icons.email_outlined,
            color: Colors.deepOrange,
            size: 150,
          ),
          const SizedBox(height: 50),
          const Text('-----------------'),
          const SizedBox(height: 20),
          Text(
            isListening ? 'listening...' : text,
          ),
          const SizedBox(height: 20),
          const Text('-----------------'),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRecording,
        tooltip: 'Voice',
        child: const Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}
