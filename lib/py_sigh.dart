import 'package:flutter/material.dart';
import 'nsdr.dart';
void main() => runApp(const FirstPageApp());

class FirstPageApp extends StatelessWidget {
  const FirstPageApp({Key? key}) : super(key: key);
  static List<Tab> myTabs = <Tab>[
    Tab(
        icon: Image.asset(
          'assets/breathing.png',
          height: 32,
          width: 32,
        )),
    Tab(
        icon: Image.asset(
          'assets/listening.png',
          height: 32,
          width: 32,
        )),
    Tab(icon: Image.asset('assets/Numbers_4_icon.png')),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Stress reduce method'),
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: const TabBarView(
            children: [
              Bubble(),
              NSDR(),
              Text('Tab three'),
            ],
          ),
        ),
      ),
    );
  }
}

class Bubble extends StatefulWidget {
  const Bubble({Key? key}) : super(key: key);
  @override
  BubbleState createState() {
    return BubbleState();
  }
}

class BubbleState extends State<Bubble> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _marginAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));

    _marginAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        // inhale 1
          tween: Tween<double>(begin: 100, end: 40),
          weight: 1.5),
      TweenSequenceItem(
        // stop
          tween: Tween<double>(begin: 40, end: 40),
          weight: 1),
      TweenSequenceItem(
        // inhale 2
          tween: Tween<double>(begin: 40, end: 30),
          weight: 1),
      TweenSequenceItem(
        // stop
          tween: Tween<double>(begin: 30, end: 30),
          weight: 1),
      TweenSequenceItem(
        // exhale
          tween: Tween<double>(begin: 30, end: 100),
          weight: 7),
      TweenSequenceItem(
        // stop
          tween: Tween<double>(begin: 100, end: 100),
          weight: 2),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.repeat().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  createDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const Dialog(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Center(
                child: Text(
                  ' -Physiological sigh: là phương pháp thở vào 2 lần thật nhanh và mạnh rồi thở ra từ từ \n\n'
                  ' -Tác dụng: giúp bạn thở có chủ đích, bình tĩnh lại và cân bằng lại cảm xúc ngay lúc thở \n\n',
                // ' -Nguồn khoa học: https://scopeblog.stanford.edu/2020/10/07/how-stress-affects-your-brain-and-how-to-reverse-it/',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, _) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                CircleBox(marginAnimation: _marginAnimation),
                ElevatedButton(
                    onPressed: () {
                      _playAnimation();
                    },
                    child: const Text('Start'))
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                createDialog(context);
              },
              child: const Text('?'),
            ),
          );
        });
  }
}

class CircleBox extends StatelessWidget {
  const CircleBox({
    Key? key,
    required Animation<double> marginAnimation,
  })  : _marginAnimation = marginAnimation,
        super(key: key);

  final Animation<double> _marginAnimation;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(0, -1),
        child: SizedBox(
          width: 280,
          height: 300,
          // color: Colors.red,   // uncomment to see container
          child: Container(
            margin: EdgeInsets.all(_marginAnimation.value),
            decoration: const BoxDecoration(
              color: Colors.pinkAccent,
              shape: BoxShape.circle,
            ),
          ),
        )
    );
  }
}
