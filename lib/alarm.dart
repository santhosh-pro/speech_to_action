import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Alarm extends StatefulWidget {
  const Alarm({super.key});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  String text = 'Press the mic button and start speaking';
  bool isListening = false;
  final _speech = SpeechToText();

  Future toggleRecording() async {
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
                      final splitted = text.split(':');
                      FlutterAlarmClock.createAlarm(
                          int.parse(splitted[0]), int.parse(splitted[1]));
                    })
                  }
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(25),
          child: TextButton(
            child: const Text(
              '(HH:MM) 24hrs Clock \n----- Example  23 colon 10 -----',
              style: TextStyle(fontSize: 20.0),
            ),
            onPressed: () {},
          ),
        ),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleRecording,
        tooltip: 'Voice',
        child: const Icon(Icons.mic),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
