import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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
  static const iconSize = 50.0;

  final player = AudioAssetPlayer('nsdr.mp3');

  // stuff need getting update: state & progress
  late final StreamSubscription progressSubscription;
  late final StreamSubscription stateSubscription;

  double progress = 0.0;
  PlayerState state = PlayerState.STOPPED;

  late final Future initFuture;

  @override
  void initState() {
    initFuture = player.int().then((_) {
      progressSubscription =
          player.progressStream.listen((p) => setState(() => progress = p));
      stateSubscription =
          player.stateStream.listen((s) => setState(() => state = s));
    });

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[100],
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<void>(
              future: initFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Text('loading');
                }

                return Container(
                  // color: Colors.blue[100],
                  // elevation: 3.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Non-Sleep Deep Rest',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline5
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildPlayButton(),
                          buildPauseButton(),
                          buildStopButton(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
      ),
    );
  }

  Widget buildPlayButton() {
    if (state == PlayerState.PLAYING) {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.play_arrow,
            color: Colors.grey,
            size: iconSize,
          ));
    }

    return IconButton(
        onPressed: player.play,
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.green,
          size: iconSize,
        ));
  }

  Widget buildPauseButton() {
      if (state == PlayerState.PAUSED) {
        return const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.pause,
              color: Colors.grey,
              size: iconSize,
            ));
      }

      return IconButton(
          onPressed: player.pause,
          icon: const Icon(
            Icons.pause,
            color: Colors.grey,
            size: iconSize,
          ));
  }

  Widget buildStopButton() {
    if (state == PlayerState.STOPPED) {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.stop,
            color: Colors.grey,
            size: iconSize,
          ));
    }

    return IconButton(
        onPressed: player.reset,
        icon: const Icon(
          Icons.stop,
          color: Colors.green,
          size: iconSize,
        ));
  }
}

