import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../repositories/speech_repository.dart';

class SpeechRecognitionViewModel extends ChangeNotifier {
  static final SpeechRecognitionViewModel _instance = SpeechRecognitionViewModel._internal();
  SpeechRecognitionViewModel._internal();
  factory SpeechRecognitionViewModel() {
    return _instance;
  }
  static final _searchRepository = SpeechRepository();

  bool isVisibleAnimation = false;
  String? recognizedText;


  Future<bool> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  void startListening() async {
  if (!await requestMicrophonePermission()) {
    return;
  }
  if (_searchRepository.isRecording == false) {
    await _searchRepository.initRecoreder();
    await _searchRepository.startRecording();
    isVisibleAnimation = true;
    notifyListeners();
  }
}

  Future<void> stopListening() async {
    String audioPath = await _searchRepository.stopRecording();
    if (audioPath.isNotEmpty) {
      recognizedText = await _searchRepository.transcribeAudio(audioPath);
    }
    isVisibleAnimation = false;
    notifyListeners();
  }
}
