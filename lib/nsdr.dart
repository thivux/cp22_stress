import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audio_player.dart';
import 'alarm.dart';

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

  final nsdrPlayer = AudioAssetPlayer('nsdr.mp3');
  // final nsdrPlayer = AudioAssetPlayer('alarm.wav');
  AudioAssetPlayer alarmPlayer = AudioAssetPlayer('alarm.wav');

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
    alarmPlayer.dispose();
    super.dispose();
  }

  AlarmSwitch alarmSwitch = AlarmSwitch();

  // print('alarm being called');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: alarmSwitch,
            ),
            const Padding(padding: EdgeInsets.all(30)),
            FutureBuilder<void>(
              future: initFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Text('loading');
                }

                Text('alarm on: ' + alarmSwitch.alarmOn.toString());
                // -> this gets updated constantly
                if (state == PlayerState.COMPLETED) {
                  const Text('completed');
                  if (alarmSwitch.alarmOn == true) {
                    alarmPlayer.play();
                  }
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Non-Sleep Deep Rest',
                        style: Theme.of(context).textTheme.headline5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildPlayButton(),
                        buildPauseButton(),
                        buildResetButton(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(32.0),
                      child: LinearProgressIndicator(
                        value: progress,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
          // child:
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createDialog(context);
        },
        child: const Text('?'),
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
        onPressed: nsdrPlayer.play,
        icon: const Icon(
          Icons.play_arrow,
          color: Colors.green,
          size: iconSize,
        ));
  }

  Widget buildPauseButton() {
    if (state == PlayerState.PLAYING) {
      return IconButton(
          onPressed: nsdrPlayer.pause,
          icon: const Icon(
            Icons.pause,
            color: Colors.green,
            size: iconSize,
          ));
    }
    // if (state == PlayerState.PAUSED) {
    return const IconButton(
        onPressed: null,
        icon: Icon(
          Icons.pause,
          color: Colors.grey,
          size: iconSize,
        ));
    // }
  }

  Widget buildResetButton() {
    if (state == PlayerState.STOPPED) {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.replay,
            color: Colors.grey,
            size: iconSize,
          ));
    }

    return IconButton(
        onPressed: nsdrPlayer.reset,
        icon: const Icon(
          Icons.replay,
          color: Colors.green,
          size: iconSize,
        ));
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              width: 300,
              height: 350,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    '- H?????ng d???n: l???ng nghe v?? l??m theo ch??? d???n trong ??o???n ghi ??m \n\n- T??c d???ng: gi??p b???n th?? gi??n nhanh v?? s??u, d??? d??ng ch??m v??o gi???c ng??? ho???c ng??? tr??? l???i n???u th???c d???y gi???a ch???ng l??c n???a ????m, c?? th??? d??ng ????? thay th??? gi???c ng??? ???? m???t\n',
                    // '- Ngu???n khoa h???c nghi??n c???u (tr??ch): published by Front Psychiatry (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6361823/)',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
