import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'dart:async';

// test nsdr
void main() {
  runApp(const MaterialApp(
    home: NSDR(),
  ));
}

class NSDR extends StatefulWidget {
  const NSDR({Key? key}) : super(key: key);

  @override
  _AudioplayerState createState() => _AudioplayerState();
}

class _AudioplayerState extends State<NSDR> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPlaylist();
  }

  void setupPlaylist() async {
    await audioPlayer.open(Audio('asset/nsdr.mp3'), autoStart: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  Widget circularAudioPlayer(
      RealtimePlayingInfos realtimePlayingInfos, double screenWidth) {
    Color primaryColor = Color(0xff2f6f88);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        CircularPercentIndicator(
            radius: screenWidth / 2,
            arcType: ArcType.HALF,
            backgroundColor: primaryColor,
            progressColor: Colors.white,
            percent: realtimePlayingInfos.currentPosition.inSeconds /
                realtimePlayingInfos.duration.inSeconds,
            center: IconButton(
              iconSize: screenWidth / 8,
              color: primaryColor,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              icon: Icon(realtimePlayingInfos.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded),
              onPressed: () => audioPlayer.playOrPause(),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/NSDR1.png'), fit: BoxFit.cover)),
        alignment: Alignment.center,
        child: audioPlayer.builderRealtimePlayingInfos(
            builder: (context, realtimePlayingInfos) {
          if (realtimePlayingInfos != null) {
            return circularAudioPlayer(
                realtimePlayingInfos, MediaQuery.of(context).size.width);
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
