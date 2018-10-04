import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game_f/Controllers/gamecontroller.dart';
import 'package:snake_game_f/Screens/game.dart';
import 'package:snake_game_f/Screens/gameoverscreen.dart';
import 'package:snake_game_f/shared.dart';
import 'package:snake_game_f/Screens/startscreen.dart';

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

  GameController gameController;

  @override
  void initState() {
    super.initState();
    piecesize = widget.piecesize;
    verticalpadding = (widget.boardsize.height%widget.piecesize)/2;
    horizontalpadding = (widget.boardsize.width%widget.piecesize)/2;
    rows = (widget.boardsize.height/widget.piecesize).floor();
    columns =(widget.boardsize.width/widget.piecesize).floor();

    gameController = GameController(rows, columns, piecesize)
      ..addListener(() {
        setState(() {
         // if (gameState != gameController.gameState) {
            gameState = gameController.gameState;
        //  }
        });
      });
    //..initiateGame();
  }


  void onChangeGameState(GameState _gamestate) {

      /*if (_gamestate == GameState.active) {
        gameController.initiateGame();
        gameController.startTimer();

      }*/

        gameController.gameState = _gamestate;


  }


  void _changeDirectionBasedOnTap(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    gameController.changeDirection(_tapPosition);
  }


  Widget _buildScreen() {
    Widget _currentScreen;
    switch (gameState) {
      case GameState.startscreen:
        _currentScreen = StartScreen(onChangeGameState: (game) {
          onChangeGameState(game);
        });
        break;
      case GameState.active:
        _currentScreen = GestureDetector(
            onTapDown: _changeDirectionBasedOnTap,
            child: Game(gameController: gameController)
        );
        break;
      case GameState.gameover:
        _currentScreen = GameOverScreen(onChangeGameState: (game) {
          onChangeGameState(game);
        });

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