import "package:flutter/material.dart";
// import 'package:flutter_sound/flutter_sound.dart';
// import "package:intl/intl.dart";
import 'dart:io';
import "package:path_provider/path_provider.dart";
// import "package:audio_recorder2/audio_recorder2.dart";

class VoiceRecord extends StatefulWidget {
  @override
  _VoiceRecordState createState() => _VoiceRecordState();
}

class _VoiceRecordState extends State<VoiceRecord> {
  // FlutterSound flutterSound;
  bool _isPlaying = false, _isRecording = false;
  bool hasPermission = false;

  @override
  void initState() {
    super.initState();
    // flutterSound = new FlutterSound();
    _checkForPermissions();
  }

  void _checkForPermissions() async {
    // bool packagePermission = await AudioRecorder2.hasPermissions;

    setState(() {
      // hasPermission = packagePermission;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/flutter_recordings(2).mp4');
  }

  var _playerSubscription, _recorderSubscription;

  var _backgroundDecoration = BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.indigo[800],
            Colors.indigo[700],
            Colors.indigo[600],
            Colors.indigo[400],
          ],
        )
  );

  void startRecording() async {
    File file = await _localFile;
    
    // await AudioRecorder2.start(path: file.path.toString(), audioOutputFormat: AudioOutputFormat.AAC);
    setState(() {
      _isRecording = true;
    });
  }

  void stopRecording() async {
    // String result = await flutterSound.stopRecorder();
    // print("Stopped: $result");

    // Recording recording = await AudioRecorder2.stop();

    // print("Recording path: ${recording.path}, Duration: ${recording.duration}");

    setState((){
      _isRecording = false;
    });
  }

  Widget _handleRecorder() {
    if(!_isRecording)
      return FloatingActionButton(
        onPressed: (){ startRecording(); },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.record_voice_over)
      );
    else
      return FloatingActionButton(
        onPressed: () { stopRecording(); },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.stop,
          color: Colors.white,
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: _backgroundDecoration,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _handleRecorder()
    );
  }
}