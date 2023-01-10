import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audio_player.dart';

void main() {
  runApp(const MaterialApp(
    home: NSDR(fileName: 'Entrelosdos.mp3'),
  ));
}

class NSDR extends StatefulWidget {
  final String fileName;

  // NSDR (this.fileName);

  const NSDR({Key? key, required this.fileName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NSDRState();
  }
}

class NSDRState extends State<NSDR> {
  Color primaryColor = Color(0xff2f6f88);
  bool alarmOn = false;
  bool backgroundMusicOn = false;

  late final nsdrPlayer = AudioAssetPlayer(widget.fileName);

  AudioAssetPlayer alarmPlayer = AudioAssetPlayer('alarm_i_miss_u.mp3');
  AudioAssetPlayer backgroundPlayer =
      AudioAssetPlayer('30_min_background_music.mp3');

  // stuff need getting update: state & progress
  late final StreamSubscription progressSubscription;
  late final StreamSubscription stateSubscription;

  double progress = 0.0;
  PlayerState state = PlayerState.STOPPED;

  late final Future initFuture;

  @override
  void initState() {
    initFuture = nsdrPlayer.init().then((_) {
      alarmPlayer.init();
      backgroundPlayer.init();
      progressSubscription =
          nsdrPlayer.progressStream.listen((p) => setState(() => progress = p));
      stateSubscription =
          nsdrPlayer.stateStream.listen((s) => setState(() => state = s));
      // print('fuck you: ' + progress.toString()); -> only gets called once
    });
    super.initState();
  }

  @override
  void dispose() {
    nsdrPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<void>(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text('loading');
            }

            if (state == PlayerState.COMPLETED) {
              print('completed');
              if (alarmOn == true) {
                alarmPlayer.play();
              }
            }

            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_1.jpg'),
                  fit: BoxFit.cover,
                  // opacity: 0.8,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        iconSize: screenWidth / 10,
                        icon: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => {
                          Navigator.of(context).pop(),
                        },
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(32.0),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white70,
                            color: primaryColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            buildPlayOrPauseButton(screenWidth),
                            buildReplayButton(screenWidth),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      // color: Colors.red,   // uncomment to see shape of container
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: [
                                IconButton(
                                  iconSize: screenWidth / 10,
                                  onPressed: () {
                                    setState(() {
                                      backgroundMusicOn
                                          ? backgroundPlayer.pause()
                                          : backgroundPlayer.play();
                                      backgroundMusicOn = !backgroundMusicOn;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.surround_sound_outlined,
                                    color: backgroundMusicOn
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                                Text(
                                  "Nhạc nền",
                                  style: TextStyle(
                                    color: backgroundMusicOn
                                        ? Colors.white
                                        : Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  iconSize: screenWidth / 10,
                                  onPressed: () {
                                    setState(() {
                                      alarmOn = !alarmOn;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.alarm,
                                    color:
                                        alarmOn ? Colors.white : Colors.white54,
                                  ),
                                ),
                                Text(
                                  "Báo thức",
                                  style: TextStyle(
                                    color:
                                        alarmOn ? Colors.white : Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget buildPlayOrPauseButton(double screenWidth) {
    return IconButton(
        iconSize: screenWidth / 8,
        color: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(state == PlayerState.PLAYING
            ? Icons.pause_rounded
            : Icons.play_arrow_rounded),
        onPressed: () {
          state == PlayerState.PLAYING ? nsdrPlayer.pause() : nsdrPlayer.play();
        });
  }

  Widget buildReplayButton(double screenWidth) {
    return IconButton(
        iconSize: screenWidth / 10,
        color: Colors.white,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(Icons.replay_rounded),
        onPressed: () {
          nsdrPlayer.reset();
        });
  }
}
