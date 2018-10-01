import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game_f/gameboard.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Snake',
        theme: ThemeData(fontFamily: 'Pixel Emulator'),
      home: new MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  final Size boardsize = Size(350.0,550.0);
  final double piecesize = 30.0;

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        title: new Text("Snake"),
      ),
      body: Center(
        child: GameBoard(boardsize: boardsize,piecesize: piecesize,),
        ),
    );
  }
}

