import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: Bubble(),
  ));
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
                  'hit vao 2 lan, tho ra 1 lan\ntho ik!!!',
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
    return buildDefaultTabController();
  }

  static List<Tab> myTabs = <Tab>[
    Tab(icon: Image.asset('assets/breathing.png', height: 32, width: 32,)),
    Tab(icon: Image.asset('assets/listening.png', height: 32, width: 32,)),
    Tab(icon: Image.asset('assets/Numbers_4_icon.png')),
  ];
  late TabController _tabController;
  DefaultTabController buildDefaultTabController() {
    return DefaultTabController(
      length: myTabs.length,
      child: Builder(builder: (BuildContext context) {
      final TabController tabController = DefaultTabController.of(context)!;
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
            return Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  tabs: myTabs,
                ),
                title: const Text('Tabbar stuff'),
              ),
              body:  TabBarView(
                  children: myTabs.map((Tab tab) {
                   return Wrap(

                   );
                }
              ).toList(),
              ),
              floatingActionButton: buildFloatingActionButton(context),
            );
          }));
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        createDialog(context);
      },
      child: const Text('?'),
    );
  }

  List<Widget> bubbleMechanic() {
    return
      <Widget>[
      CircleBox(marginAnimation: _marginAnimation),
      ElevatedButton(
          onPressed: () {
            _playAnimation();
          },
          child: const Text('Start'))
    ];
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
    return Wrap(
      children: [
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 280,
            height: 280,
            // color: Colors.red,   // uncomment to see container
            child: Container(
              margin: EdgeInsets.all(_marginAnimation.value),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
