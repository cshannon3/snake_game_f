import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/apple.dart';
import 'package:snake_game_f/Models/point.dart';
import 'package:snake_game_f/Models/snake.dart';
import 'package:snake_game_f/shared.dart';
import 'dart:math' as math;

class GameController extends ChangeNotifier {
  final int rows, columns;
  final double piecesize;

  GameController(this.rows, this.columns, this.piecesize);

  //Point _applePosition;
  //Color _appleColor;
  Apple _apple;

  List<Snake> _snakes = initsnake;
  int snakesalive = 0;

  Timer timer;
  Stopwatch stopwatch = Stopwatch();
  GameState _gameState = GameState.startscreen;

  int ticksBeforeAppleDissapears;
  int _millisecondsPerMovement = 500;
  int _secondsBeforeAppleDissapears = 10;
  int _points = 0;
  int _minMillisecondsPerMovement = 250;

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
    if (_gameState == GameState.active) {
      initiateGame();
    }
    notifyListeners();
  }

  Point getSnakePosition(int index, int snakenum) {
    return _snakes[snakenum].getSnakePosition(index);
  }

  Point get applePosition => _apple.appleLocation;
  Color get appleColor => _apple.getAppleColor();
  Apple get apple => _apple;

  int get secondsBeforeAppleDissapears => _secondsBeforeAppleDissapears;

  int get inittick =>
      (_secondsBeforeAppleDissapears * 1000 / _millisecondsPerMovement).floor();

  ///
  List<Snake> get snakes => _snakes;

  double get piece => piecesize;

  int get points => _points;

  bool isSnakeMovingVertically(int _snakenum) {
    return _snakes[_snakenum].isSnakeMovingVertically();
  }

  bool isSnakeActive(int _snakenum) {
    return _snakes[_snakenum].isAlive;
  }

  int getsnakelength(int _snakenum) {
    return _snakes[_snakenum].getSnakeLength();
  }
  /*

  EXTERNAL

   */

  void initiateGame() {
    _points = 0;
    _snakes[1].activateSnake(
        [Point((rows / 2).floorToDouble(), (columns / 2).floorToDouble())],
        SnakeDirection.down);
    _snakes[2].activateSnake([
      Point((rows / 2).floorToDouble() + 2, (columns / 2).floorToDouble() + 2)
    ], SnakeDirection.down);
    snakesalive = 2;
    //TODO
    _generateNewApple();
    notifyListeners();
    if (_gameState == GameState.active) startTimer();
  }

  startTimer() {
    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(Duration(milliseconds: _millisecondsPerMovement),
        (Timer timer) {
      tickUpdate();
    });
  }

  void tickUpdate() {
    _snakes.forEach((_snake) {
      if (_snake.isAlive) {
        _snake.getNewHead();
        _snake.snakelocations.removeLast();
        _snake.turnstatus = false;
        if (_isStillInPlay(_snake.getHead())) {
          if (_isAppleCollision(_snake.getHead())) {
            switch (_apple.appleType) {
              case (AppleType.regularapple):
                _points += 1;
                _generateNewApple();
                notifyListeners();
                break;
              case (AppleType.doubleapple):
                _points += 2;
                if (_millisecondsPerMovement > _minMillisecondsPerMovement) {
                  _millisecondsPerMovement -= 50;
                  _generateNewApple();
                  notifyListeners();
                  startTimer();
                }
                // increase speed
                break;
              case (AppleType.slowdownapple):
                _millisecondsPerMovement += 50;
                _generateNewApple();
                notifyListeners();
                startTimer();
                // decreaseSpeed
                break;
              case (AppleType.splitapple):
                if (snakesalive < _snakes.length &&
                    _snake.snakelocations.length > 1) {
                  int newsnakenum = _snakes.indexWhere((_s) => !_s.isAlive);
                  _snakes[newsnakenum].activateSnake(
                      _snake.snakelocations.sublist(
                          (_snake.getSnakeLength() / 2).ceil(),
                          _snake.getSnakeLength()),
                      _snake.currentdirection);
                  _snake.snakelocations = _snake.snakelocations
                      .sublist(0, (_snake.getSnakeLength() / 2).floor());
                  snakesalive += 1;
                }
                _generateNewApple();
                notifyListeners();
                break;
              default:
                break;
            }
            //_points += _apple.getPoints();
            //TODO
            // if(_apple.appleType == )
            // _generateNewApple();
            _snake.getNewHead();
          }
        } else {
          _snake.deactivateSnake();
          snakesalive -= 1;
          if (snakesalive == 0) {
            _gameState = GameState.gameover;
            timer?.cancel();
            notifyListeners();
          }
        }
      }
    });
    if (ticksBeforeAppleDissapears == 0) _generateNewApple();

    ticksBeforeAppleDissapears -= 1;

    notifyListeners();
  }

  void changeDirectionsWithController(
      SnakeDirection _newsnakeDirection, int _snakenum) {
    if (!_snakes[_snakenum].turnstatus) {
      _snakes[_snakenum].turnstatus = true;
      _snakes[_snakenum].currentdirection = _newsnakeDirection;
    }
    notifyListeners();
  }

  /*

  INTERNAL
*/
//TODO
  void _generateNewApple() {
    math.Random rng = math.Random();
    Point newApple =
        Point(rng.nextInt(columns).toDouble(), rng.nextInt(rows).toDouble());
    if (_snakes.any((_snake) => _snake.containsNewApple(newApple))) {
      _generateNewApple();
    } else {
      var nextAppleType = rng.nextInt(AppleType.values.length);
      _apple = Apple(newApple, AppleType.values[nextAppleType]);
      ticksBeforeAppleDissapears = inittick;
      // }
      notifyListeners();
    }
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
        : false;
  }

  // TODO
  bool _isAppleCollision(Point currentHeadPos) {
    return (currentHeadPos.x == _apple.appleLocation.x &&
            currentHeadPos.y == _apple.appleLocation.y)
        ? true
        : false;
  }
  /*bool _isBoardFilled() {
    return (rows * columns == snakelength) ? true : false;
  }*/
}
