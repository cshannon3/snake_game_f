import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game_f/game.dart';
import 'package:snake_game_f/gameoverscreen.dart';
import 'package:snake_game_f/shared.dart';
import 'package:snake_game_f/startscreen.dart';

class GameBoard extends StatefulWidget {
  final Size boardsize;
  final double piecesize;

  const GameBoard({Key key, this.boardsize, this.piecesize}) : super(key: key);
  @override
  _GameBoardState createState() => new _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  GameState gameState = GameState.startscreen;
  double verticalpadding;
  double horizontalpadding;
  int rows, columns, spots;
  double piecesize;
  //Widget currentScreen;


  @override
  void initState() {
    super.initState();
    piecesize = widget.piecesize;
    verticalpadding = (widget.boardsize.height%widget.piecesize)/2;
    horizontalpadding = (widget.boardsize.width%widget.piecesize)/2;
    rows = (widget.boardsize.height/widget.piecesize).floor();
    columns =(widget.boardsize.width/widget.piecesize).floor();

  }

  void onChangeGameState(GameState _gamestate) {
    gameState = _gamestate;
    setState(() {

    });
  }

  Widget _buildScreen() {
    Widget _currentScreen;
    switch (gameState) {
      case GameState.startscreen:
        _currentScreen = StartScreen(onChangeGameState: (game) {onChangeGameState(game);});
        break;
      case GameState.active:
        _currentScreen = Game(rows: rows,columns: columns,piecesize: piecesize,onChangeGameState: (game) {onChangeGameState(game);});
        break;
      case GameState.gameover:
        _currentScreen = GameOverScreen(onChangeGameState: (game) {onChangeGameState(game);});
        break;
    }
    return _currentScreen;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(widget.boardsize),
      child: Container(
        color: Colors.grey[400],
        padding: EdgeInsets.symmetric(vertical: verticalpadding, horizontal: horizontalpadding),
        child: _buildScreen()
      ),
    );
  }
}

enum SnakeDirection {
  up,
  down,
  left,
  right
}