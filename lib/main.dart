import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Snake',
        theme: ThemeData(fontFamily: 'Pixel Emulator'),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Size boardsize = Size(300.0,510.0);
  final double piecesize = 30.0;



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: Center(
        child: GameBoard(boardsize: boardsize,piecesize: piecesize,),
        ),

   // )
    );
  }
}

class GameBoard extends StatefulWidget {
  final Size boardsize;
  final double piecesize;

  const GameBoard({Key key, this.boardsize, this.piecesize}) : super(key: key);
  @override
  _GameBoardState createState() => new _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  GameState gameState = GameState.startscreen;
  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  Offset _tapPosition;
  Random random;
  int taillocation;
  int foodlocation;
  int snakeheadlocation;
  List<SnakeDirection> directionlist = [];
  SnakeDirection snakeDirection;
  bool turn = false;
  int taillength = 0;
  List<int> taillocations = [];


  @override
  void initState() {
    super.initState();
    snakeheadlocation = 0;
    random = Random();
    foodlocation = random.nextInt(150);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget startText() {
    return Center(
      child: RichText(text: TextSpan(
          text: "Tap to start a New Game!",
          style: TextStyle(
              color: Colors.green
          )
      )),
    );
  }

  Widget gameoverText() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Game Over! Tap to play again!",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget game() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: ((snakeheadlocation / 10).floor()) * 30.0,
          left: snakeheadlocation % 10 * 30.0, //snakeHeadX*30.0,
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle
            ),
          ),
        ),

        Positioned(
          top: ((foodlocation / 10).floor()) * 30.0, //foodY*30.0,
          left: foodlocation % 10 * 30.0,
          child: Container(
            height: 30.0,
            width: 30.0,
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle
            ),
          ),
        ),
      ]
        ..addAll(
            List.generate(taillength, (index) {
              if (index == 0) {
                taillocation = snakeheadlocation;
              }
              setState(() {
                switch (directionlist[index]) {
                  case SnakeDirection.down:
                    taillocation -= 10;
                    break;
                  case SnakeDirection.up:
                    taillocation += 10;
                    break;
                  case SnakeDirection.right:
                    taillocation -= 1;
                    break;
                  case SnakeDirection.left:
                    taillocation += 1;
                    break;
                }
                taillocations[index] = taillocation;
              });
              return Positioned(
                  top: ((taillocation / 10).floor()) * 30.0,
                  left: taillocation % 10 * 30.0,
                  child: Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle
                    ),
                  )
              );
            }
            )
        ),
    );
  }

  void gameOver() {
    setState(() {
      timer?.cancel();
      gameState = GameState.gameover;
    });
  }

  startGame() {
    setState(() {
      taillength = 0;
      snakeDirection = SnakeDirection.down;
      taillocation = 0;
      snakeheadlocation = 0;
    });

    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        directionlist.insert(0, snakeDirection);
        switch (snakeDirection) {
          case SnakeDirection.down:
            (snakeheadlocation / 10.floor() < 15)
                ? snakeheadlocation += 10
                : gameOver();
            break;
          case SnakeDirection.up:
            (snakeheadlocation / 10.floor() > 0)
                ? snakeheadlocation -= 10
                : gameOver();
            break;
          case SnakeDirection.right:
            (snakeheadlocation % 10 != 9)
                ? snakeheadlocation += 1
                : gameOver();
            break;
          case SnakeDirection.left:
            (snakeheadlocation % 10 != 0)
                ? snakeheadlocation -= 1
                : gameOver();
        }
        (taillocations.isNotEmpty && taillocations.contains(snakeheadlocation))
            ? gameOver()
            : turn = false;
      });
      if (snakeheadlocation == foodlocation) {
        foodlocation = random.nextInt(150);
        taillocations.add(snakeheadlocation);
        taillength += 1;
        while (taillocations.contains(foodlocation)) {
          foodlocation = random.nextInt(150);
        }
      }
    });
  }


  void _onTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      print(_tapPosition);
    });
    switch (gameState) {
      case GameState.startscreen:
        setState(() {
          gameState = GameState.active;
          startGame();
        });
        break;
      case GameState.active:
        if (!turn) onGameTap();
        break;
      case GameState.gameover:
        setState(() {
          gameState = GameState.startscreen;
        });
        break;
    }
  }

  onGameTap() {
    setState(() {
      turn = true;
      (snakeDirection == SnakeDirection.down ||
          snakeDirection == SnakeDirection.up)
          ? (_tapPosition.dx > (snakeheadlocation % 10) * 30)
          ? snakeDirection = SnakeDirection.right
          : snakeDirection = SnakeDirection.left
          : (_tapPosition.dy > (snakeheadlocation / 10.floor()) * 30)
          ? snakeDirection = SnakeDirection.down
          : snakeDirection = SnakeDirection.up;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: _onTapDown,
        onTap: () {
          print("hi");
        },
        child:
        ConstrainedBox(
          constraints: BoxConstraints.tight(
              Size(widget.boardwidth, widget.boardheight)),
          child:
          Container(
            color: Colors.white,
            child:
            (gameState == GameState.active)
                ? game()
                : (gameState == GameState.startscreen)
                ? startText()
                : gameoverText(),
          ),

        )
    );
  }
}

enum GameState {
  gameover,
  startscreen,
  active,
}
enum SnakeDirection {
  up,
  down,
  left,
  right
}