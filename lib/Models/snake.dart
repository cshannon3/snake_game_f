import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';
import 'package:snake_game_f/shared.dart';

class Snake {
  final Color snakeColor;
  bool isAlive;

  SnakeDirection currentdirection;

  List<Point> snakelocations;
  bool turnstatus = false;

  Snake(
      {this.snakeColor,
      this.currentdirection = SnakeDirection.down,
      this.isAlive = false});

  Point getHead() {
    return (isAlive && snakelocations.isNotEmpty)
        ? snakelocations.first
        : Point(0.0, 0.0);
  }

  Point getSnakePosition(int index) {
    return (isAlive && snakelocations.isNotEmpty)
        ? snakelocations[index]
        : Point(0.0, 0.0);
  }

  void getNewHead() {
    var newHeadPos;
    if (isAlive && snakelocations.isNotEmpty) {
      switch (currentdirection) {
        case SnakeDirection.down:
          newHeadPos = Point(getHead().x, getHead().y + 1);
          break;
        case SnakeDirection.up:
          newHeadPos = Point(getHead().x, getHead().y - 1);
          break;
        case SnakeDirection.right:
          newHeadPos = Point(getHead().x + 1, getHead().y);
          break;
        case SnakeDirection.left:
          newHeadPos = Point(getHead().x - 1, getHead().y);
          break;
      }
      snakelocations.insert(0, newHeadPos);
    }
  }

  void activateSnake(
      List<Point> _initialPoints, SnakeDirection _initialDirection) {
    snakelocations?.clear();
    snakelocations = _initialPoints;
    currentdirection = _initialDirection;
    isAlive = true;
  }

  void deactivateSnake() {
    snakelocations?.clear();
    isAlive = false;
  }

  bool isSnakeMovingVertically() {
    return (currentdirection == SnakeDirection.down ||
            currentdirection == SnakeDirection.up)
        ? true
        : false;
  }

  int getSnakeLength() {
    return (isAlive) ? snakelocations.length : 0;
  }

  bool containsNewApple(Point _newApple) {
    return (isAlive && snakelocations.contains(_newApple)) ? true : false;
  }
}

final List<Snake> initsnake = [
  Snake(
    snakeColor: Colors.green,
  ),
  Snake(
    snakeColor: Colors.blue,
  ),
  Snake(
    snakeColor: Colors.orange,
  ),
  Snake(
    snakeColor: Colors.amber,
  ),
];
