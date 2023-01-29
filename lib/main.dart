import 'package:flutter/material.dart';
import 'package:speech_to_action/speech_to_text_service.dart';
import 'package:speech_to_action/url_launcher_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech To Action',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Speech To Action'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = 'Press the mic button and start speaking';
  bool isListening = false;

  Future toggleRecording() {
    return SpeechToTextService.toggleRecording(
      onResult: (text) => setState(() => this.text = text),
      onListening: (isListening) {
        setState(() => this.isListening = isListening);

        if (!isListening) {
          Future.delayed(const Duration(seconds: 1), () {
            UrlLauncherService.scanText(text);
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "\nAvaliable Commands :\n\n \t 'go to' <url_name> (open the url to web browser) \n \t 'write email' <content> (open email app and write content)",
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRecording,
        tooltip: 'Voice',
        child: const Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
