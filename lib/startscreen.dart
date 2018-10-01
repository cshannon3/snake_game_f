import 'package:flutter/material.dart';
import 'package:snake_game_f/shared.dart';

class StartScreen extends StatelessWidget {
  final Function(GameState) onChangeGameState;

  const StartScreen({Key key, this.onChangeGameState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => onChangeGameState(GameState.active),
      child: Container(
        color: Colors.white,
        child: Center(
          child: RichText(text: TextSpan(
              text: "Tap to start a New Game!",
              style: TextStyle(
                color: Colors.green,
              )
          )),
        ),
      ),
    );
  }
}
