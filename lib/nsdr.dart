import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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
  final nsdrEN = AudioAssetPlayer('QuanComNgayMua.mp3');
  AudioAssetPlayer alarmPlayer = AudioAssetPlayer('alarm.wav');
  AudioAssetPlayer alarmPlayerEN = AudioAssetPlayer('alarm.wav');

  // stuff need getting update: state & progress
  late final StreamSubscription progressSubscription;
  late final StreamSubscription progressSubscriptionEN;
  late final StreamSubscription stateSubscription;
  late final StreamSubscription stateSubscriptionEN;

  double progress = 0.0;
  double progressEN = 0.0;
  PlayerState state = PlayerState.STOPPED;
  PlayerState stateEN = PlayerState.STOPPED;

  late final Future initFuture;
  late final Future initFutureEN;

  @override
  void initState() {
    initFuture = nsdrPlayer.init().then((_) {
      alarmPlayer.init();
      progressSubscription =
          nsdrPlayer.progressStream.listen((p) => setState(() => progress = p));
      stateSubscription =
          nsdrPlayer.stateStream.listen((s) => setState(() => state = s));
    });
    initFutureEN = nsdrEN.init().then((_) {
      alarmPlayerEN.init();
      progressSubscriptionEN =
          nsdrEN.progressStream.listen((p) => setState(() => progressEN = p));
      stateSubscriptionEN =
          nsdrEN.stateStream.listen((s) => setState(() => stateEN = s));
    });
    super.initState();
  }

  // void initStateEN() {
  //   initFutureEN = nsdrEN.init().then((_) {
  //     alarmPlayerEN.init();
  //     progressSubscriptionEN =
  //         nsdrEN.progressStream.listen((p) => setState(() => progressEN = p));
  //     stateSubscriptionEN =
  //         nsdrEN.stateStream.listen((s) => setState(() => stateEN = s));
  //   });
  //   super.initState();
  // }

  @override
  void dispose() {
    nsdrPlayer.dispose();
    nsdrEN.dispose();
    alarmPlayer.dispose();
    super.dispose();
  }

  AlarmSwitch alarmSwitch = AlarmSwitch();

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

                Text('Alarm on: ' + alarmSwitch.alarmOn.toString());
                // -> this gets updated constantly
                if (state == PlayerState.COMPLETED) {
                  const Text('Completed');
                  if (alarmSwitch.alarmOn == true) {
                    alarmPlayer.play();
                  }
                }
                if (stateEN == PlayerState.COMPLETED) {
                  const Text('Completed');
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
                    Text('English version',
                        style: Theme.of(context).textTheme.headline5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildPlayButtonEN(),
                        buildPauseButtonEN(),
                        buildResetButtonEN(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
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

  Widget buildPlayButtonEN() {
    if (stateEN == PlayerState.PLAYING) {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.play_arrow,
            color: Colors.grey,
            size: iconSize,
          ));
    }

    return IconButton(
        onPressed: nsdrEN.play,
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

  Widget buildPauseButtonEN() {
    if (stateEN == PlayerState.PLAYING) {
      return IconButton(
          onPressed: nsdrEN.pause,
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

  Widget buildResetButtonEN() {
    if (stateEN == PlayerState.STOPPED) {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.replay,
            color: Colors.grey,
            size: iconSize,
          ));
    }

    return IconButton(
        onPressed: nsdrEN.reset,
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
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    '- Lắng nghe và làm theo chỉ dẫn trong đoạn ghi âm \n\n- Tác dụng: giúp bạn thư giãn nhanh và sâu, dễ dàng chìm vào giấc ngủ hoặc ngủ trở lại nếu thức dậy giữa chừng lúc nửa đêm, có thể dùng để thay thế giấc ngủ đã mất\n',
                    // '- Nguồn khoa học nghiên cứu (trích): published by Front Psychiatry (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6361823/)',
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
