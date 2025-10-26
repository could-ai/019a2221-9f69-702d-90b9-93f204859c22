import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flashlight/flashlight.dart';

void main() {
  runApp(SaraAIApp());
}

class SaraAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sara AI Assistant',
      home: SaraHome(),
    );
  }
}

class SaraHome extends StatefulWidget {
  @override
  _SaraHomeState createState() => _SaraHomeState();
}

class _SaraHomeState extends State<SaraHome> {
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          setState(() {
            _command = result.recognizedWords.toLowerCase();
            if (_command.contains('flashlight on')) {
              Flashlight.lightOn();
            } else if (_command.contains('flashlight off')) {
              Flashlight.lightOff();
            }
            // More commands can be added here
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sara AI Assistant')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Command: $_command'),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic_off : Icons.mic),
            ),
          ],
        ),
      ),
    );
  }
}