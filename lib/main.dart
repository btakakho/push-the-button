import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push The Button',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;
  Timer? waitingTimer;
  Timer? stoppableTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF282E3D),
      body: Stack(children: [
        Align(
          alignment: Alignment(0, -0.8),
          child: Text(
            "Test your reaction!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                color: Colors.white
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ColoredBox(
            color: Colors.black12,
            child: SizedBox(
              width: 300,
              height: 80,
              child: Center(
                child: Text(
                  millisecondsText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(0, 0.9),
          child: GestureDetector(
            onTap: _handleTap,
            child: ColoredBox(
              color: _getButtonBackground(),
              child: SizedBox(
                width: 300,
                height: 200,
                child: Center(
                  child: Text(
                    _getButtonText().toUpperCase(),
                    style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  void _handleTap() {
    setState(() {
      switch (gameState) {
        case GameState.readyToStart:
          gameState = GameState.waiting;
          millisecondsText = "";
          _startWaitingTimer();
          break;
        case GameState.canBeStopped:
          gameState = GameState.readyToStart;
          stoppableTimer?.cancel();
          break;
        case GameState.waiting:
          millisecondsText = "wait...";
          break;
      }
    });
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "Start";
      case GameState.canBeStopped:
        return "Stop";
      case GameState.waiting:
        return "Wait";
    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;

    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), () {
      setState(() {
        gameState = GameState.canBeStopped;
      });
      _startStoppableTimer();
    });
  }

  Color _getButtonBackground() {
    switch (gameState) {
      case GameState.readyToStart:
        return Color(0xFF40CA88);
      case GameState.canBeStopped:
        return Color(0xFFE02D47);
      case GameState.waiting:
        return Color(0xFFE0982D);
    }
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}

enum GameState {
  readyToStart,
  canBeStopped,
  waiting
}
