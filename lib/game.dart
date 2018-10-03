import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game_f/ball.dart';
import 'package:snake_game_f/shared.dart';


class Game extends StatefulWidget {
  final int rows, columns;
  final double piecesize;
  final Function(GameState) onChangeGameState;

  const Game({Key key, this.rows, this.columns, this.piecesize, this.onChangeGameState}) : super(key: key);
  @override
  _GameState createState() => new _GameState();
}

class _GameState extends State<Game> {

  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  Offset _tapPosition;
  Random random;

  int taillocation, foodlocation, snakeheadlocation;
  int taillength = 0;
  List<int> taillocations = [];
  List<SnakeDirection> directionlist = [];
  SnakeDirection snakeDirection;
  bool turn = false;

 // double verticalpadding, horizontalpadding;

  int rows, columns, spots;
  double piecesize;
  int millisecondsPerMovement = 500;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      random = Random();
      rows = widget.rows;
      columns = widget.columns;
      piecesize = widget.piecesize;
      spots = rows * columns;
      taillength = 0;
      snakeDirection = SnakeDirection.down;
      taillocation = 0;
      snakeheadlocation = 30;
      taillocations?.clear();
      foodlocation = random.nextInt(spots);
    });
    setSpeed();

    /*timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(Duration(milliseconds: 500), (Timer timer) {
      setState(() {
        directionlist.insert(0, snakeDirection);
        switch (snakeDirection) {
          case SnakeDirection.down:
            ((snakeheadlocation / columns).floor() < rows - 1)
                ? snakeheadlocation += columns
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.up:
            ((snakeheadlocation / columns).floor() > 0)
                ? snakeheadlocation -= columns
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.right:
            (snakeheadlocation % columns != columns - 1)
                ? snakeheadlocation += 1
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.left:
            (snakeheadlocation % columns != 0)
                ? snakeheadlocation -= 1
                : widget.onChangeGameState(GameState.gameover);
        }
        (taillocations.isNotEmpty && taillocations.contains(snakeheadlocation))
            ? widget.onChangeGameState(GameState.gameover)
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
    });*/
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  setSpeed() {
    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(Duration(milliseconds: millisecondsPerMovement), (Timer timer) {
      setState(() {
        directionlist.insert(0, snakeDirection);
        switch (snakeDirection) {
          case SnakeDirection.down:
            ((snakeheadlocation / columns).floor() < rows - 1)
                ? snakeheadlocation += columns
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.up:
            ((snakeheadlocation / columns).floor() > 0)
                ? snakeheadlocation -= columns
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.right:
            (snakeheadlocation % columns != columns - 1)
                ? snakeheadlocation += 1
                : widget.onChangeGameState(GameState.gameover);
            break;
          case SnakeDirection.left:
            (snakeheadlocation % columns != 0)
                ? snakeheadlocation -= 1
                : widget.onChangeGameState(GameState.gameover);
        }
        (taillocations.isNotEmpty && taillocations.contains(snakeheadlocation))
            ? widget.onChangeGameState(GameState.gameover)
            : turn = false;
      });
      if (snakeheadlocation == foodlocation) {
        foodlocation = random.nextInt(spots);
        taillocations.add(snakeheadlocation);
        taillength += 1;

        while (taillocations.contains(foodlocation)) {
          foodlocation = random.nextInt(spots);
        }
        if (millisecondsPerMovement> 200) millisecondsPerMovement-=10;
        setSpeed();
      }
    });
  }

  double getY(int _location) {
    return ((_location / columns).floor() * piecesize);
  }

  double getX(int _location) {
    return ((_location % columns) * piecesize);
  }


  void _onTapDown(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
    if (!turn) onGameTap();
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
        child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Ball(x: getX(snakeheadlocation),
                  y: getY(snakeheadlocation),
                  piecesize: piecesize,
                  isSnake: true,),

                AnimatedApple(
                  radius: piecesize/4,
                  x: getX(foodlocation),
                  y: getY(foodlocation),
                  piecesize: piecesize,
                ),
              /*  Ball(x: getX(foodlocation),
                  y: getY(foodlocation),
                  piecesize: piecesize,
                  isSnake: false,),
*/
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
                      return Ball(x: getX(taillocation),
                        y: getY(taillocation),
                        piecesize: piecesize,
                        isSnake: true,);
                    }
                    )
                ),
            )
        )
    );
  }
}

enum SnakeDirection {
  up,
  down,
  left,
  right
}


