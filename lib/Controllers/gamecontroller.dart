
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
  //var _snakePiecePositions;
  Point _applePosition;
 // SnakeDirection snakeDirection= SnakeDirection.down;
  //bool turn = false;

  List<List<Point>> _snakePiecePositions=[[
    Point(0.0,0.0),
  ],[
    Point(0.0,0.0),
  ]];
  List<SnakeDirection> snakeDirections = [SnakeDirection.down,SnakeDirection.down];
  List<bool> turnstatuses = [false,false];

  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  GameState _gameState = GameState.startscreen;
  int ticksBeforeAppleDissapears;
  int _millisecondsPerMovement = 500;
  int _secondsBeforeAppleDissapears = 10;
  int _points = 0;



  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }
/*GAMESTATE*/
/*SNAKE*/

  /*

  GETTERS AND SETTERS

   */
/*GAMESTATE*/
  GameState get gameState => _gameState;

  set gameState(GameState newgamestate) {
    _gameState = newgamestate;
    if (_gameState==GameState.active){
        initiateGame();
    }
    notifyListeners();

  }

  Point getSnakePosition(int index, int snakenum){
    return (isSnakeActive(snakenum))
    ?_snakePiecePositions[snakenum][index]
    : Point(0.0,0.0);
  }

  Point get applePosition => _applePosition;


  int get snakelength => (_snakePiecePositions.isNotEmpty)?_snakePiecePositions.first.length: 0;

  int get snakelength2 => (_snakePiecePositions.isNotEmpty)?_snakePiecePositions.last.length: 0;

  int get inittick =>(_secondsBeforeAppleDissapears*1000/_millisecondsPerMovement).floor();

  double get piece => piecesize;

  int get points => _points;

 int get secondsBeforeAppleDissapears => _secondsBeforeAppleDissapears;


  /*

  EXTERNAL

   */


  void initiateGame(){
    snakeDirections = [SnakeDirection.down, SnakeDirection.down];
    turnstatuses = [false, false];

   // snakeDirection = SnakeDirection.down;
    _points = 0;
   // turn = false;
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

    int _snakenum = 0;
   List<List<Point>> _newsnakes= [];
   List<SnakeDirection> _newdirections = [];

    _snakePiecePositions.forEach((_snake) {
      List<Point> newsnake = _snake;
      newsnake.insert(0, _getNewHead(newsnake.first,snakeDirections[_snakenum] ));
      newsnake.removeLast();
      turnstatuses[_snakenum]= false;

      if(_isStillInPlay(newsnake.first)){
        _newdirections.add(snakeDirections[_snakenum]);
        if(_isAppleCollision(newsnake.first)) {
          _points += 1;
          _generateNewApple();
          newsnake.insert(_snakenum, _getNewHead(newsnake.first,snakeDirections[_snakenum] ));

        }
        _newsnakes.add(newsnake);
      } else
         {
         if (_snakePiecePositions.length ==1) {
           _gameState = GameState.gameover;
           timer?.cancel();
           notifyListeners();
         }
      }
      _snakenum+=1;

    });
    snakeDirections = _newdirections;

    _snakePiecePositions = _newsnakes;
    notifyListeners();

      if (ticksBeforeAppleDissapears == 0 ) _generateNewApple();

      ticksBeforeAppleDissapears -=1;
      notifyListeners();

  }

  void changeDirectionsWithController(SnakeDirection _newsnakeDirection, int _snakenum){
    if (!turnstatuses[_snakenum]) {
      turnstatuses[_snakenum]= true;
      snakeDirections[_snakenum] = _newsnakeDirection;
    }
    notifyListeners();
  }

  bool isSnakeMovingVertically(int snakenum) {

    return (snakeDirections[snakenum] == SnakeDirection.down ||
        snakeDirections[snakenum] == SnakeDirection.up )
    ?true
    :false;
  }
  bool isSnakeActive(int snakenum) {
    return (_snakePiecePositions.length > snakenum)
        ? true
        : false;
  }

  /*

  INTERNAL

  */


  Point _getNewHead(Point currentHeadPos, SnakeDirection currentdirection){
    var newHeadPos;
    switch (currentdirection) {
      case SnakeDirection.down:
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
      case SnakeDirection.up:
        newHeadPos = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;
      case SnakeDirection.right:
        newHeadPos = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;
      case SnakeDirection.left:
        newHeadPos = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;
    }
    return newHeadPos;
  }


  void _generateFirstSnakePosition() {
    _snakePiecePositions?.clear();
    final midPoint = columns/ 2;
    _snakePiecePositions =[[
      Point(rows/2.floorToDouble(), midPoint.floorToDouble()),
    ],[
      Point(rows/2.floorToDouble()-3, midPoint.floorToDouble()-2),
    ]] ;
    snakeDirections = [SnakeDirection.down, SnakeDirection.down];
    turnstatuses = [false, false];

    notifyListeners();
  }

  void _generateNewApple() {
    math.Random rng = math.Random();
    var nextX = rng.nextInt(columns);
    var nextY = rng.nextInt(rows);
    var newApple = Point(nextX.toDouble(), nextY.toDouble());
    if (_snakePiecePositions.first.contains(newApple)) {
      _generateNewApple();
    } else {
      _applePosition = newApple;
      ticksBeforeAppleDissapears = inittick;

    }
    notifyListeners();
  }



  /*

  POSITION CHECKS

*/
  bool _isStillInPlay(Point currentHeadPos) {
    return (currentHeadPos.x > -1 &&
        currentHeadPos.y > -1 &&
        currentHeadPos.x < columns &&
        currentHeadPos.y < rows)
   ? true
        :false;
  }

  bool _isAppleCollision(Point currentHeadPos) {

    return (currentHeadPos.x == _applePosition.x &&
        currentHeadPos.y == _applePosition.y)
        ? true
        : false;

  }

  bool _isBoardFilled() {
    return (rows*columns == snakelength)
        ? true
        : false;
  }


}

