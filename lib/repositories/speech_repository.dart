import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class SpeechRepository{
  static final SpeechRepository _instance = SpeechRepository._internal();
  SpeechRepository._internal();
  factory SpeechRepository(){
    return _instance;
  }

  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  String deepgramApiKey = "";
  String? audioPath;
  String _transcription = "";

  bool isRecording = false;


  String get transcription => _transcription;

  Future<void> initRecoreder() async {
    if (recorder.isStopped) {
      await recorder.openRecorder();
    }
  }

  Future<void> startRecording() async {
    if (recorder.isRecording) return;
    Directory tempDir = await getTemporaryDirectory();
    audioPath = "${tempDir.path}/recording.wav";
    await recorder.startRecorder(
      toFile: audioPath,
      codec: Codec.pcm16WAV,
    );
  }

  Future<String> stopRecording() async {
    if (!recorder.isRecording) return "";
    await recorder.stopRecorder();
    isRecording = false;
    if (audioPath != null) {
      return audioPath!;
    }
    return "";
  }

  Future<String> transcribeAudio(String filePath) async {
    try {
      File audioFile = File(filePath);

      List<int> audioBytes = await audioFile.readAsBytes();
      Response response = await Dio().post(
        "https://api.deepgram.com/v1/listen",
        queryParameters: {
          "model": "nova-2",
          "smart_format": "false",
          "punctuate": "false",
          "detect_language": "ru"
        },
        data: Stream.fromIterable([audioBytes]),
        options: Options(
          headers: {
            "Authorization": "Token $deepgramApiKey",
            "Content-Type": "audio/wav",
          },
        ),
      );
      _transcription = response.data["results"]["channels"][0]["alternatives"]
              [0]["transcript"] ??
          "Ошибка распознавания";

      return _transcription;
    } catch (e) {
      return "";
    }
  }
}
