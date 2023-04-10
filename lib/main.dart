import 'package:flutter/material.dart';
import 'package:speech_to_action/alarm.dart';
import 'package:speech_to_action/email.dart';
import 'package:speech_to_action/speech_to_text_service.dart';
import 'package:speech_to_action/url_launcher_service.dart';
import 'package:speech_to_action/website.dart';
import 'package:speech_to_text/speech_to_text.dart';

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
        primarySwatch: Colors.deepOrange,
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
  final _speech = SpeechToText();

  Future toggleRecording() async {
    // return speechToTextService.toggleRecording(
    //   onResult: (text) => setState(() => this.text = text),
    //   onListening: (isListening) {
    //     setState(() => this.isListening = isListening);

    //     if (!isListening) {
    //       if (text == "send mail" || text == "send email")
    //         // ignore: curly_braces_in_flow_control_structures
    //         Future.delayed(const Duration(seconds: 1), () {
    //           //  UrlLauncherService.scanText(text);
    //           Navigator.of(context).pushReplacement(
    //             MaterialPageRoute(
    //               builder: (context) => const SendEmail(),
    //             ),
    //           );
    //         });
    //     }
    //   },
    // );

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
                    if (text == "send mail" || text == "send email")
                      {
                        Future.delayed(const Duration(seconds: 1), () {
                          //  UrlLauncherService.scanText(text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SendEmail(),
                            ),
                          );
                        })
                      }
                    else if (text == "website" ||
                        text == "web" ||
                        text == "url")
                      {
                        Future.delayed(const Duration(seconds: 1), () {
                          //  UrlLauncherService.scanText(text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Website(),
                            ),
                          );
                        })
                      }
                    else if (text == "alarm" ||
                        text == "set alarm" ||
                        text == "go to alarm")
                      {
                        Future.delayed(const Duration(seconds: 1), () {
                          //  UrlLauncherService.scanText(text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Alarm(),
                            ),
                          );
                        })
                      }
                  }
              });
    }
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
            const SizedBox(height: 20),
            Card(
                elevation: 30,
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 170,
                  child: Center(
                      child: Text('Send Mail', style: TextStyle(fontSize: 50))),
                )),
            const SizedBox(height: 20),
            Card(
                elevation: 30,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 170,
                  child: Center(
                      child: Text('Website', style: TextStyle(fontSize: 50))),
                )),
            const SizedBox(height: 20),
            Card(
                elevation: 30,
                color: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const SizedBox(
                  width: 300,
                  height: 170,
                  child: Center(
                      child: Text('Alarm', style: TextStyle(fontSize: 50))),
                )),
            const SizedBox(height: 20),
            const Text('-----------------'),
            const SizedBox(height: 20),
            Text(
              isListening ? 'listening...' : text,
            ),
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

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }
}
