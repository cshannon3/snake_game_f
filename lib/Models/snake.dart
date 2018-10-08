

import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';
import 'package:snake_game_f/shared.dart';

class Snake {
  final Color snakeColor;
  bool isAlive;
  List<Point> snakelocations;
  SnakeDirection currentDirection;
  Snake({
    this.snakeColor,
    this.isAlive = false,
      this.currentDirection = SnakeDirection.down,
  });

  Point getHead(){
    return (isAlive && snakelocations.isNotEmpty)
        ? snakelocations.first
    :Point(0.0,0.0);
  }


}