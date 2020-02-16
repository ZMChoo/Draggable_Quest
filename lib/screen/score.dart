import 'package:draggable_project/common/customColors.dart';
import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  final String score;

  const ScorePage({Key key, this.score = "0"}) : super(key: key);

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text("Scoreboard"),
      ),
      body: Center(
          child: Text(
        "You have answered " + widget.score + " correctly.",
        style: TextStyle(
            fontSize: 22,
            color: CustomColors.veryOrange,
            fontWeight: FontWeight.bold),
      )),
    );
  }
}
