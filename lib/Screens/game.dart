

import 'package:flutter/material.dart';
import 'package:snake_game_f/Components/animatedapplepiece.dart';
import 'package:snake_game_f/Components/snakepiece.dart';
import 'package:snake_game_f/shared.dart';
import 'package:snake_game_f/Controllers/gamecontroller.dart';


class Game extends StatefulWidget {
  final GameController gameController;
  const Game({this.gameController});

  
  @override
  _GameState createState() => new _GameState();
}



class _GameState extends State<Game> {
 /* Timer timer;
  Stopwatch stopwatch = Stopwatch();

  m.Random random;

  int rows, columns, spots;
  double piecesize;
  int millisecondsPerMovement = 500;
  int secondsBeforeAppleDissapears = 10;
  GameController gameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      random = m.Random();
      rows = widget.rows;
      columns = widget.columns;
      piecesize = widget.piecesize;
     // ..initiateGame()
     // ..addListener(() {
       // setState(() {
        //  if (!gameController.activegame)
            return widget.onChangeGameState(GameState.gameover);
        });
   //   });
   // });
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  startTimer() {
    timer?.cancel(); // cancel old timer if it exists
    timer = Timer.periodic(
        Duration(milliseconds: millisecondsPerMovement), (Timer timer) {
      gameController.tickUpdate();
    });
  }


  void _changeDirectionBasedOnTap(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject();
    Offset _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    gameController.changeDirection(_tapPosition);
  }
*/

  @override
  Widget build(BuildContext context) {
    return  Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                AnimatedApple(
                  position: widget.gameController.applePosition,
                  piecesize: widget.gameController.piecesize,
                  secondsBeforeDissapears: widget.gameController.secondsBeforeAppleDissapears,
                )
              ]
                ..addAll(
                    List.generate(widget.gameController.snakelength, (index) {
                      return SnakePiece(
                        position: widget.gameController.getSnakePosition(index),
                        piecesize: widget.gameController.piecesize,
                      );
                    }

                    )
                ),
            ),
            );
  }
}



