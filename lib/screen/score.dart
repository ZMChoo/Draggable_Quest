import 'package:draggable_project/common/customColors.dart';
import 'package:flutter/material.dart';

class ScorePage extends StatefulWidget {
  // final String score;

  const ScorePage({
    Key key,
  }) : super(key: key);

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "You have answered all the questions!",
            style: TextStyle(
                fontSize: 22,
                color: CustomColors.veryOrange,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.blue,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text("Back to Home"),
            ),
          ),
        )
      ]),
    );
  }
}
