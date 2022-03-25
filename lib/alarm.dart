import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(AlarmSwitch());
}

class AlarmSwitch extends StatefulWidget {
  bool alarmOn = false;

  AlarmSwitch({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AlarmSwitchState();
  }
}

class AlarmSwitchState extends State<AlarmSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(30.0),
      // margin: EdgeInsets.all(0),
      // color: Colors.pink[100], // uncomment to see shape of container
      // elevation: 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Chuông báo khi bài tập kết thúc',
            style: TextStyle(
              fontSize: 15,
              // fontWeight: FontWeight.w400,
            ),
          ),
          buildSwitch(),
        ],
      ),
    );
    //   ),
    // );
  }

  Widget buildSwitch() {
    return Transform.scale(
      scale: 1,
      child: Switch.adaptive(
        activeColor: Colors.pinkAccent,
        activeTrackColor: Colors.pink.withOpacity(0.4),
        value: widget.alarmOn,
        onChanged: (alarmOn) => setState(() => widget.alarmOn = alarmOn),
      ),
    );
  }
}

void playAlarm() {}
