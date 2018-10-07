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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
    Container(
    width: widget.boardsize.width,
      height: 60.0,
      color: Colors.blue,
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: widget.boardsize.width/4,
            height: 50.0,
            color: Colors.white,
            child: Center(
              child: Text("${gameController.points}"),
            ),
          ),
          Container(
            width: widget.boardsize.width/4,
            height: 50.0,
            color: Colors.white,
          ),
          Container(
            width: widget.boardsize.width/4,
            height: 50.0,
            color: Colors.white,
          ),

        ],
      ),
    ),
        ConstrainedBox(
          constraints: BoxConstraints.tight(widget.boardsize),
          child: Container(
            color: Colors.grey[400],
            padding: EdgeInsets.symmetric(vertical: verticalpadding, horizontal: horizontalpadding),
            child: _buildScreen()
          ),
    ),
        Expanded(
          child: Container(
            width:  widget.boardsize.width,
            color: Colors.grey[400],

            child: Row(
              children: <Widget>[
                UserController(
                  boxwidth: widget.boardsize.width/4,
                  isActive: false,
                  gameController: gameController,
                ),
                UserController(
                  boxwidth: widget.boardsize.width/4,
                   snakenumber:  0,
                  isActive: true,
                  snakeColor: Colors.black,
                  gameController: gameController,
                ),
                UserController(
                  boxwidth: widget.boardsize.width/4,
                  // boxheight:  0.0,
                  isActive: false,
                  gameController: gameController,
                ),
                UserController(
                  boxwidth: widget.boardsize.width/4,
                  // boxheight:  0.0,
                  isActive: false,
                  gameController: gameController,
                ),


              ],
            ),
          ),

        )
    ]

    );
  }
}


class UserController extends StatelessWidget {

  final double boxwidth;
  final bool isActive;
  final int snakenumber;
  final Color snakeColor;
  final GameController gameController;

  const UserController({
    this.isActive,
    this.snakenumber,
    this.boxwidth,
    this.gameController,
  this.snakeColor = Colors.grey});


  @override
  Widget build(BuildContext context) {
    final double boxheight = MediaQuery.of(context).size.height;
    return

    isActive ? GestureDetector(
      onTapDown: (TapDownDetails details) {
        final RenderBox referenceBox = context.findRenderObject();
        Offset _tapPosition = referenceBox.globalToLocal(details.globalPosition);
       print("${_tapPosition}");

         if (gameController.isSnakeMovingVertically()){

             gameController.changeDirectionsWithController(
                 (_tapPosition.dx< boxwidth/2)
                 ?SnakeDirection.left
                  : SnakeDirection.right);

         }else {
           gameController.changeDirectionsWithController(
               (_tapPosition.dy < boxwidth / 2)
                   ? SnakeDirection.up
                   : SnakeDirection.down);
         }

      },
      child: Container(
        color: snakeColor,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:30.0  ),
              child: Opacity(
                opacity: gameController.isSnakeMovingVertically()? 1.0: .5,
                child: Container(
                  width:boxwidth,
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.arrow_back, color: Colors.black,),
                      Icon(Icons.arrow_forward,color: Colors.black,),

                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left:30.0 ),
              child: Opacity(
                  opacity: gameController.isSnakeMovingVertically()? .5: 1.0,
                child: Container(
                  width: 40.0,
                  height: boxwidth,

                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.arrow_upward, color: Colors.black,),
                      Icon(Icons.arrow_downward,color: Colors.black,),

                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ): InactiveController(boxwidth: boxwidth,);
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
          child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Container(
                    width: boxwidth,
                    height: 40.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.arrow_back, color: Colors.black,),
                        Icon(Icons.arrow_forward, color: Colors.black,),

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
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(Icons.arrow_upward, color: Colors.black,),
                        Icon(Icons.arrow_downward, color: Colors.black,),

                      ],
                    ),
                  ),
                )
              ]
          )
      ),
    );
  }
}
