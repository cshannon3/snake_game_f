import 'package:flutter/material.dart';
import 'package:snake_game_f/Components/animatedapplepiece.dart';
import 'package:snake_game_f/Components/snakepiece.dart';
import 'package:snake_game_f/Controllers/gamecontroller.dart';


class Game extends StatelessWidget {
  final GameController gameController;
  const Game({this.gameController});


  @override
  Widget build(BuildContext context) {
    /*void _changeDirectionBasedOnTap(TapDownDetails details) {
      final RenderBox referenceBox = context.findRenderObject();
      Offset _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      gameController.changeDirection(_tapPosition);
    }*/
    return  /*GestureDetector(
        onTapDown: _changeDirectionBasedOnTap,
        child:*/ Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                AnimatedApple(
                  position: gameController.applePosition,
                  piecesize: gameController.piecesize,
                  secondsBeforeDissapears: gameController.secondsBeforeAppleDissapears,
                )
              ]
                ..addAll(
                    List.generate(gameController.snakelength, (index) {
                      return SnakePiece(
                        position: gameController.getSnakePosition(index, 0),
                        piecesize: gameController.piecesize,
                        snakeColor:Colors.blue,
                      );

                    }

                    )
                )
                ..addAll(
                    List.generate(gameController.snakelength2, (index) {
                      return SnakePiece(
                        position: gameController.getSnakePosition(index, 1),
                        piecesize: gameController.piecesize,
                        snakeColor:Colors.orange,
                      );

                    }

                    )
                ),
            ),
          //  )
    );
  }
}



