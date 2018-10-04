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
  double verticalpadding, horizontalpadding;

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
          print(gameState);
            gameState = gameController.gameState;
        });
      });

  }

  Widget _buildScreen() {
    Widget _currentScreen;
    switch (gameState) {
      case GameState.startscreen:
        _currentScreen = StartScreen(onChangeGameState: (_game) {
          gameController.gameState = _game;
        });
        break;
      case GameState.active:
        _currentScreen = Game(gameController: gameController);
        break;
      case GameState.gameover:
        _currentScreen = GameOverScreen(onChangeGameState: (_game) {
          gameController.gameState = _game;
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
