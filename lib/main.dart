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
  final Size boardsize = Size(350.0,550.0);
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
  double verticalpadding;
  double horizontalpadding;
  int rows, columns, spots;
  double piecesize;


  @override
  void initState() {
    super.initState();
    snakeheadlocation = 0;
    random = Random();

    piecesize = widget.piecesize;
    verticalpadding = (widget.boardsize.height%widget.piecesize)/2;
    horizontalpadding = (widget.boardsize.width%widget.piecesize)/2;
    rows = (widget.boardsize.height/widget.piecesize).floor();
    columns =(widget.boardsize.width/widget.piecesize).floor();
    print("rows $rows and columns $columns");
    spots = rows * columns;

    foodlocation = random.nextInt(spots);
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

  double getY(int _location){
    return ((_location / columns).floor() * piecesize);
  }

  double getX(int _location){
    return (_location % columns) * piecesize;
  }
  Widget game() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: getY(snakeheadlocation),
          left: getX(snakeheadlocation) ,
          child: Container(
            height: piecesize,
            width: piecesize,
            decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle
            ),
          ),
        ),
        Positioned(
          top: getY(foodlocation),
          left: getX(foodlocation),
          child: Container(
            height: piecesize,
            width: piecesize,
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
                    taillocation -= columns;
                    break;
                  case SnakeDirection.up:
                    taillocation += columns;
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
                  top: getY(taillocation),
                  left: getX(taillocation),
                  child: Container(
                    height: piecesize,
                    width: piecesize,
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
      taillocations.clear();
    });

    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        directionlist.insert(0, snakeDirection);
        switch (snakeDirection) {
          case SnakeDirection.down:
            ((snakeheadlocation / columns).floor() < rows-1)
                ? snakeheadlocation += columns
                : gameOver();
            break;
          case SnakeDirection.up:
            ((snakeheadlocation / columns).floor() > 0)
                ? snakeheadlocation -= columns
                : gameOver();
            break;
          case SnakeDirection.right:
            (snakeheadlocation % columns != columns-1)
                ? snakeheadlocation += 1
                : gameOver();
            break;
          case SnakeDirection.left:
            (snakeheadlocation %columns != 0)
                ? snakeheadlocation -= 1
                : gameOver();
        }
        (taillocations.isNotEmpty && taillocations.contains(snakeheadlocation))
            ? gameOver()
            : turn = false;
      });
      if (snakeheadlocation == foodlocation) {
        foodlocation = random.nextInt(spots);
        taillocations.add(snakeheadlocation);
        taillength += 1;
        while (taillocations.contains(foodlocation)) {
          foodlocation = random.nextInt(spots);
        }
      }
    });
  }


  void _onTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
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
          ? (_tapPosition.dx > getX(snakeheadlocation))
          ? snakeDirection = SnakeDirection.right
          : snakeDirection = SnakeDirection.left
          : (_tapPosition.dy > getY(snakeheadlocation))
          ? snakeDirection = SnakeDirection.down
          : snakeDirection = SnakeDirection.up;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: _onTapDown,
        child:
        ConstrainedBox(
          constraints: BoxConstraints.tight(widget.boardsize),
          child:
          Container(
            color: Colors.grey[400],
            padding: EdgeInsets.symmetric(vertical: verticalpadding, horizontal: horizontalpadding),
            child: Container(
              color: Colors.white,
              child:
              (gameState == GameState.active)
                  ? game()
                  : (gameState == GameState.startscreen)
                  ? startText()
                  : gameoverText(),
            ),
          ),
        ),
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