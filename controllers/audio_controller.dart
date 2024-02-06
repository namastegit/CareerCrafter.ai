import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class AppAudioController extends GetxController {
  AudioPlayer? _audioPlayer;
  AudioPlayer? get audioPlayer => _audioPlayer;
  // AudioPlayer? _audioPlayer1;
  // AudioPlayer get audioPlayer1 => _audioPlayer1!;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _playingIndex = 0;
  int get playingIndex => _playingIndex;

  void setPlaying(bool value, {int? index}) {
    _isPlaying = value;
    if (index != null) {
      _playingIndex = index;
    }
    update();
  }

  void setAudioDispose() {
    _isPlaying = false;
  }

  //play audio from network
  // void playAudioFromUrl(String url) async {
  //   await _audioPlayer1!.setUrl(url);
  //   setVolume(0.4);
  //   _audioPlayer1!.play();
  // }

  bool _isMusicEnabled = true;
  bool get isMusicEnabled => _isMusicEnabled;

  Future<void> setMusicEnabled(bool value) async {
    _isMusicEnabled = value;
    GetStorage().write("isMusicEnabled", value);
    if (value) {
    } else {
      // _audioPlayer1!.stop();
    }
    update();
  }

//fetch isMusicEnabled from local

  getMusicEnabled() {
    // _audioPlayer1 = AudioPlayer();
    GetStorage().writeIfNull("isMusicEnabled", true);
    GetStorage().read("isMusicEnabled");
    _isMusicEnabled = GetStorage().read("isMusicEnabled");
    update();
    if (_isMusicEnabled) {
      // _audioPlayer1!.setLoopMode(LoopMode.one);
    }
  }

  //play on intt
  @override
  void onInit() {
    super.onInit();
    getMusicEnabled();

    _audioPlayer = AudioPlayer();
  }

  //stop audio
  void stopAudio() async {
    if (audioPlayer != null) {
      await audioPlayer!.stop();
    }
  }

  //set volume
  void setVolume(double volume) async {
    // await _audioPlayer1!.setVolume(volume);
    update();
  }

  double _sliderValue = 0.3;
  double get sliderValue => _sliderValue;

  void setSliderValue(double value) {
    _sliderValue = value;
    setVolume(value);
    update();
  }

  //play base64 mp3 audio content
  void playAudioFromBase64(String base64, {int? index}) async {
    if (index != null) {
      setPlaying(true, index: index);
    }

    Uint8List bytes = base64Decode(base64);
    List<int> intList = bytes.toList();

    final applicationDirectory = await getApplicationDocumentsDirectory();
    File file = File("${applicationDirectory.path}/audio1.mp3");
    await file.writeAsBytes(intList);
    await _audioPlayer?.setFilePath(file.path);
    setVolume(0.8);
    _audioPlayer?.setLoopMode(LoopMode.off);
    _audioPlayer?.play();
    _isPlaying = true;
    update();
    _audioPlayer?.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        setPlaying(false, index: index ?? 0);
      }
    });
  }
}
