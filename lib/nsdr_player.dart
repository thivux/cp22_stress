import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audio_player.dart';

void main() {
  runApp(const MaterialApp(
    home: NSDR(),
  ));
}

class NSDR extends StatefulWidget {
  const NSDR({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NSDRState();
  }
}

class NSDRState extends State<NSDR> {
  Color primaryColor = const Color(0xff2f6f88);

  final nsdrPlayer = AudioAssetPlayer('nsdr.mp3');

  // stuff need getting update: state & progress
  late final StreamSubscription progressSubscription;
  late final StreamSubscription stateSubscription;

  double progress = 0.0;
  PlayerState state = PlayerState.STOPPED;

  late final Future initFuture;

  @override
  void initState() {
    initFuture = nsdrPlayer.init().then((_) {
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

  // AlarmSwitch alarmSwitch = AlarmSwitch();

  // print('alarm being called');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_1.jpg'), fit: BoxFit.cover)),
        alignment: Alignment.center,
        child: FutureBuilder<void>(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Text('loading');
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    color: primaryColor,
                  ),
                ),
                buildPlayOrPauseButton(MediaQuery.of(context).size.width),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildPlayOrPauseButton(double screenWidth) {
    return IconButton(
        iconSize: screenWidth / 8,
        color: primaryColor,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: Icon(state == PlayerState.PLAYING
        ? Icons.pause_rounded
        : Icons.play_arrow_rounded),
    onPressed: () {
      state == PlayerState.PLAYING ? nsdrPlayer.pause() : nsdrPlayer.play();
    }
    );
  }
}
