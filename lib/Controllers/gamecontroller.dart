
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';
import 'package:snake_game_f/shared.dart';
import 'dart:math' as math;


class GameController extends ChangeNotifier {

  final int rows, columns;
  final double piecesize;

  GameController(this.rows, this.columns, this.piecesize);

  // Position and direction variables
  var _snakePiecePositions;
  Point _applePosition;
  SnakeDirection snakeDirection= SnakeDirection.down;
  bool turn = false;

  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  GameState _gameState = GameState.startscreen;
  int ticksBeforeAppleDissapears;
  int _millisecondsPerMovement = 500;
  int _secondsBeforeAppleDissapears = 10;



  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }


  /*

  GETTERS AND SETTERS

   */

  GameState get gameState => _gameState;

  set gameState(GameState newgamestate) {
    _gameState = newgamestate;
    if (_gameState==GameState.active){
        initiateGame();
    }
    notifyListeners();

  }

  Point getSnakePosition(int index){
    return _snakePiecePositions[index];
  }

  Point get applePosition => _applePosition;


  int get snakelength => _snakePiecePositions.length;

  int get inittick =>(_secondsBeforeAppleDissapears*1000/_millisecondsPerMovement).floor();

  double get piece => piecesize;

 int get secondsBeforeAppleDissapears => _secondsBeforeAppleDissapears;


  /*

  EXTERNAL

   */



  void initiateGame(){
    snakeDirection = SnakeDirection.down;
    turn = false;
    _generateFirstSnakePosition();
    _generateNewApple();
    notifyListeners();
    if(_gameState == GameState.active) startTimer();
  }

  startTimer() {
    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(
        Duration(milliseconds: _millisecondsPerMovement), (Timer timer) {
      tickUpdate();
    });
  }

  void tickUpdate() {
    _move();

    if (_isWallCollision()) {
      _gameState = GameState.gameover;
      timer?.cancel();
      notifyListeners();
      return;
    }

    if (_isAppleCollision()) {
      if (_isBoardFilled()) {
        _gameState = GameState.gameover;
        timer?.cancel();
        notifyListeners();
      } else {
        _generateNewApple();
        _grow();
      }
      notifyListeners();
      return;
    }
    if (ticksBeforeAppleDissapears == 0 ) _generateNewApple();

    ticksBeforeAppleDissapears -=1;

    notifyListeners();

  }


  void changeDirection(Offset _tapPosition){
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

  /*

  INTERNAL

  */

  void _grow() {
    _snakePiecePositions.insert(0, _getNewHeadPosition());
    notifyListeners();
  }

  void _move() {
    _snakePiecePositions.insert(0, _getNewHeadPosition());
    _snakePiecePositions.removeLast();
    turn = false;
    notifyListeners();
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
    notifyListeners();

    return newHeadPos;

  }


  void _generateFirstSnakePosition() {
    _snakePiecePositions?.clear();
    final midPoint = columns/ 2;
    _snakePiecePositions = [
      Point(rows/2.floorToDouble(), midPoint.floorToDouble()),
    ];
  }

  void _generateNewApple() {
    math.Random rng = math.Random();
    var nextX = rng.nextInt(columns);
    var nextY = rng.nextInt(rows);
    var newApple = Point(nextX.toDouble(), nextY.toDouble());
    if (_snakePiecePositions.contains(newApple)) {
      _generateNewApple();
    } else {
      _applePosition = newApple;
      ticksBeforeAppleDissapears = inittick;
      //  if (millisecondsPerMovement > 200) millisecondsPerMovement -= 10;
      //  spedup = true;
      // setSpeed2();
    }
    notifyListeners();

  }



  /*

  POSITION CHECKS

   */

  bool _isWallCollision() {
    var currentHeadPos = _snakePiecePositions.first;

    return (currentHeadPos.x < 0 ||
        currentHeadPos.y < 0 ||
        currentHeadPos.x > columns-1 ||
        currentHeadPos.y > rows-1)
        ? true
        :false;
  }

  bool _isAppleCollision() {
    return (_snakePiecePositions.first.x == _applePosition.x &&
        _snakePiecePositions.first.y == _applePosition.y)
        ? true
        : false;

  }

  bool _isBoardFilled() {
    return (rows*columns == snakelength)
        ? true
        : false;
  }


}

