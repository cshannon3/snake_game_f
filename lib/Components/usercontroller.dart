import 'package:flutter/material.dart';
import 'package:snake_game_f/Controllers/gamecontroller.dart';
import 'package:snake_game_f/shared.dart';

class UserController extends StatelessWidget {
  final double boxwidth;
  final bool isActive;
  final int snakenumber;
  final Color snakeColor;
  final GameController gameController;

  const UserController(
      {this.isActive,
      this.snakenumber,
      this.boxwidth,
      this.gameController,
      this.snakeColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return gameController.isSnakeActive(snakenumber)
        ? GestureDetector(
            onTapDown: (TapDownDetails details) {
              final RenderBox referenceBox = context.findRenderObject();
              Offset _tapPosition =
                  referenceBox.globalToLocal(details.globalPosition);

              if (gameController.isSnakeMovingVertically(snakenumber)) {
                gameController.changeDirectionsWithController(
                    (_tapPosition.dx < boxwidth / 2)
                        ? SnakeDirection.left
                        : SnakeDirection.right,
                    snakenumber);
              } else {
                gameController.changeDirectionsWithController(
                    (_tapPosition.dy < boxwidth / 2)
                        ? SnakeDirection.up
                        : SnakeDirection.down,
                    snakenumber);
              }
            },
            child: Container(
              color: snakeColor,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Opacity(
                      opacity:
                          gameController.isSnakeMovingVertically(snakenumber)
                              ? 1.0
                              : .5,
                      child: Container(
                        width: boxwidth,
                        height: 40.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0),
                    child: Opacity(
                      opacity:
                          gameController.isSnakeMovingVertically(snakenumber)
                              ? .5
                              : 1.0,
                      child: Container(
                        width: 40.0,
                        height: boxwidth,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Icon(
                              Icons.arrow_upward,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : InactiveController(
            boxwidth: boxwidth,
          );
  }
}

class InactiveController extends StatelessWidget {
  final double boxwidth;

  const InactiveController({Key key, this.boxwidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: .5,
      child: new Container(
          color: Colors.grey,
          child: Stack(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Container(
                width: boxwidth,
                height: 40.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Container(
                width: 40.0,
                height: boxwidth,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.arrow_upward,
                      color: Colors.black,
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            )
          ])),
    );
  }
}
