import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioAssetPlayer {
  final String filename;
  final progressStreamController = StreamController<double>();

  late final AudioPlayer audioPlayer;
  late final StreamSubscription progressSubscription;
  late final num audioDurationMS;

  Stream<double> get progressStream => progressStreamController.stream;

  Stream<PlayerState> get stateStream => audioPlayer.onPlayerStateChanged;

  AudioAssetPlayer(this.filename);

  Future<void> init() async {
    audioPlayer = await AudioCache().play(filename);

    // avoid bug - the duration returned = 0
    await Future.delayed(const Duration(milliseconds: 200));

    audioDurationMS = await audioPlayer.getDuration();

    // avoid audio automatically played
    await audioPlayer.stop();

    // first state: 0 ms played
    progressStreamController.add(0.0);

    // update progress bar
    progressSubscription =
        audioPlayer.onAudioPositionChanged.listen((duration) {
      return progressStreamController
          .add(duration.inMilliseconds / audioDurationMS);
    });
  }

  Future<void> dispose() => Future.wait([
        audioPlayer.dispose(),
        progressSubscription.cancel(),
        progressStreamController.close(),
      ]);

  Future<void> play() {
    return audioPlayer.resume();
  }

  Future<void> pause() => audioPlayer.pause();

  Future<void> reset() async {
    await audioPlayer.stop();
    progressStreamController.add(0.0);
  }

  Future<void> forward10s() {
    return audioPlayer.seek(Duration(milliseconds: 10000));
  }

  Future<void> backward10s() {
    return audioPlayer.seek(Duration(milliseconds: -10000));
  }
}
