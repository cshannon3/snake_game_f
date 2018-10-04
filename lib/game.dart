import 'dart:async';
import 'dart:math' as m;

import 'package:flutter/material.dart';
import 'package:snake_game_f/ball.dart';
import 'package:snake_game_f/point.dart';
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
  m.Random random;
  int ticksBeforeAppleDissapears;

  SnakeDirection snakeDirection;
  bool turn = false;
  bool spedup= false;

  int rows, columns, spots;
  double piecesize;
  int millisecondsPerMovement = 500;

// TODO New
  var _snakePiecePositions;
  Point _applePosition;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      random = m.Random();
      rows = widget.rows;
      columns = widget.columns;
      piecesize = widget.piecesize;
      spots = rows * columns;
      snakeDirection = SnakeDirection.down;

      _generateFirstSnakePosition();
      _generateNewApple();
    });
    setSpeed2();

  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  setSpeed2() {
    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(
        Duration(milliseconds: millisecondsPerMovement), (Timer timer) {
          _move();

      if (_isWallCollision()) {
        widget.onChangeGameState(GameState.gameover);
        return;
      }

      if (_isAppleCollision()) {
        if (_isBoardFilled()) {
          widget.onChangeGameState(GameState.gameover);
        } else {
          _generateNewApple();
          _grow();
        }
        return;
      }
      if (ticksBeforeAppleDissapears == 0 ) _generateNewApple();

      ticksBeforeAppleDissapears -=1;

    });
  }

  void _grow() {
    setState(() {
      _snakePiecePositions.insert(0, _getNewHeadPosition());
    });
  }

  void _move() {
    setState(() {
      _snakePiecePositions.insert(0, _getNewHeadPosition());
      _snakePiecePositions.removeLast();
      turn = false;
    });
  }

  Point _getNewHeadPosition() {
    var newHeadPos;
    switch (snakeDirection) {
      case SnakeDirection.down:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
      case SnakeDirection.up:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case SnakeDirection.right:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;
      case SnakeDirection.left:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;
    }


    return newHeadPos;
  }

  bool _isWallCollision() {
    var currentHeadPos = _snakePiecePositions.first;

    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > columns ||
        currentHeadPos.y > rows) {
      return true;
    }
    return false;
  }

  bool _isAppleCollision() {
    if (_snakePiecePositions.first.x == _applePosition.x &&
        _snakePiecePositions.first.y == _applePosition.y) {
     // print("Hey");
      return true;

    }

    return false;
  }

  bool _isBoardFilled() {
    final totalPiecesThatBoardCanFit =
        spots;
    if (_snakePiecePositions.length == totalPiecesThatBoardCanFit) {
      return true;
    }
    return false;
  }


  void _changeDirectionBasedOnTap(TapDownDetails details) {

    final RenderBox referenceBox = context.findRenderObject();
    if (!turn) {
      final currentHeadPos = _snakePiecePositions.first;
      setState(() {
        _tapPosition = referenceBox.globalToLocal(details.globalPosition);
        turn = true;
        (snakeDirection == SnakeDirection.down ||
            snakeDirection == SnakeDirection.up)
            ? (_tapPosition.dx > (currentHeadPos.x*piecesize))
            ? snakeDirection = SnakeDirection.right
            : snakeDirection = SnakeDirection.left
            : (_tapPosition.dy > (currentHeadPos.y*piecesize))
            ? snakeDirection = SnakeDirection.down
            : snakeDirection = SnakeDirection.up;
      });
    }
  }

  void _generateFirstSnakePosition() {
    setState(() {
      final midPoint = columns/ 2;
      _snakePiecePositions = [
        Point(rows/2.floorToDouble(), midPoint.floorToDouble()),
      ];
    });
  }

  void _generateNewApple() {
    setState(() {
      m.Random rng = m.Random();
      var nextX = rng.nextInt(columns);
      var nextY = rng.nextInt(rows);
      var newApple = Point(nextX.toDouble(), nextY.toDouble());
      if (_snakePiecePositions.contains(newApple)) {
        _generateNewApple();
      } else {
        _applePosition = newApple;
        ticksBeforeAppleDissapears = 10;
      //  if (millisecondsPerMovement > 200) millisecondsPerMovement -= 10;
      //  spedup = true;
       // setSpeed2();
      }

    });

  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: _changeDirectionBasedOnTap,// _onTapDown,
        child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[

              AnimatedApple(
                x: _applePosition.x,
                y: _applePosition.y,
                piecesize: piecesize,
              )
              ]
    ..addAll(
    List.generate(_snakePiecePositions.length, (index) {
      return  Ball(
      x: _snakePiecePositions[index].x,
      y: _snakePiecePositions[index].y,
      piecesize: piecesize,
      );
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


class GameController extends ChangeNotifier {

  int ticksBeforeAppleDissapears;
  SnakeDirection snakeDirection= SnakeDirection.down;
  bool turn = false;
  bool spedup= false;
  var _snakePiecePositions;
  Point _applePosition;
  final int rows, columns;
  final double piecesize;

  GameController(this.rows, this.columns, this.piecesize);




  void _grow() {
      _snakePiecePositions.insert(0, _getNewHeadPosition());

  }

  void _move() {
      _snakePiecePositions.insert(0, _getNewHeadPosition());
      _snakePiecePositions.removeLast();
      turn = false;
  }

  Point _getNewHeadPosition() {
    var newHeadPos;
    switch (snakeDirection) {
      case SnakeDirection.down:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
      case SnakeDirection.up:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;

      case SnakeDirection.right:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;
      case SnakeDirection.left:
        var currentHeadPos = _snakePiecePositions.first;
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;
    }


    return newHeadPos;
  }
  bool _isWallCollision() {
    var currentHeadPos = _snakePiecePositions.first;

    if (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > columns ||
        currentHeadPos.y > rows) {
      return true;
    }
    return false;
  }

  bool _isAppleCollision() {
    if (_snakePiecePositions.first.x == _applePosition.x &&
        _snakePiecePositions.first.y == _applePosition.y) {
      // print("Hey");
      return true;

    }
    return false;
  }

  bool _isBoardFilled() {
    final totalPiecesThatBoardCanFit =
        rows*columns;
    if (_snakePiecePositions.length == totalPiecesThatBoardCanFit) {
      return true;
    }
    return false;
  }

  void _changeDirection(Offset _tapPosition){
    if (!turn) {
      final currentHeadPos = _snakePiecePositions.first;
        turn = true;
        (snakeDirection == SnakeDirection.down ||
            snakeDirection == SnakeDirection.up)
            ? (_tapPosition.dx > (currentHeadPos.x*piecesize))
            ? snakeDirection = SnakeDirection.right
            : snakeDirection = SnakeDirection.left
            : (_tapPosition.dy > (currentHeadPos.y*piecesize))
            ? snakeDirection = SnakeDirection.down
            : snakeDirection = SnakeDirection.up;
    }
    notifyListeners();
  }
  void _generateNewApple() {
      m.Random rng = m.Random();
      var nextX = rng.nextInt(columns);
      var nextY = rng.nextInt(rows);
      var newApple = Point(nextX.toDouble(), nextY.toDouble());
      if (_snakePiecePositions.contains(newApple)) {
        _generateNewApple();
      } else {
        _applePosition = newApple;
        ticksBeforeAppleDissapears = 10;
        //  if (millisecondsPerMovement > 200) millisecondsPerMovement -= 10;
        //  spedup = true;
        // setSpeed2();
      }
      notifyListeners();

  }






}

