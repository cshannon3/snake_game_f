import 'package:flutter/material.dart';
import 'package:snake_game_f/Models/point.dart';
import 'package:snake_game_f/shared.dart';

class Apple {
  final Point appleLocation;
  final AppleType appleType;

  int ticksBeforeAppleDissapears;
  int secondsBeforeAppleDissapears = 10;

  Apple(this.appleLocation, this.appleType);

  Color getAppleColor() {
    switch (appleType) {
      case (AppleType.regularapple):
        return Colors.red;
      case (AppleType.doubleapple):
        return Colors.lime;
      case (AppleType.slowdownapple):
        return Colors.cyan;
      case (AppleType.splitapple):
        return Colors.brown[300];
      default:
        return Colors.red;
        break;
    }
  }

  int getPoints() {
    switch (appleType) {
      case (AppleType.regularapple):
        return 1;
      case (AppleType.doubleapple):
        return 2;
      case (AppleType.slowdownapple):
        return 0;
      case (AppleType.splitapple):
        return 1;
      default:
        break;
    }
  }
}
