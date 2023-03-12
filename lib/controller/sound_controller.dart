import 'package:audioplayers/audioplayers.dart';

class SoundController {
  ///
  factory SoundController() => _getInstance();

  // 静态私有成员，没有初始化
  static SoundController? _instance;

  // 静态、同步、私有访问点
  static SoundController _getInstance() {
    _instance ??= SoundController._internal();
    return _instance!;
  }

  // 私有构造函数
  SoundController._internal() {}

  AudioPlayer audioPlayer = AudioPlayer();

  void playDiDiDi() {
    audioPlayer.play(AssetSource("sound/kefu_ding.mp3"));
  }

  Future<void> playDingDong() async {
    audioPlayer.play(AssetSource("sound/567.mp3"));
  }

  void playApply() async {
    int timesPlayed = 0;
    const timestoPlay = 3;
    audioPlayer.play(AssetSource("sound/567.mp3")).then((player) {
      audioPlayer.onPlayerComplete.listen((event) {
        timesPlayed++;
        if (timesPlayed >= timestoPlay) {
          timesPlayed = 0;
          audioPlayer.stop();
        } else {
          audioPlayer.resume();
        }
      });
    });
  }

  void pause() {
    audioPlayer.pause();
  }

  void stop() {
    audioPlayer.stop();
  }
}
