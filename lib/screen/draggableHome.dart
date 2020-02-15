import 'dart:convert';

import 'package:draggable_project/common/customColors.dart';
import 'package:draggable_project/modal/fruits.dart';
import 'package:draggable_project/modal/questions.dart';
import 'package:flutter/material.dart';

class DraggableHome extends StatefulWidget {
  @override
  _DraggableHomeState createState() => _DraggableHomeState();
}

class _DraggableHomeState extends State<DraggableHome> {
  Future<List<Fruits>> fetchFruits(BuildContext context) async {
    final jsonString =
        await DefaultAssetBundle.of(context).loadString('assets/fruits.json');
    return fruitsFromJson(jsonString);
  }

  Future<List<Questions>> fetchQuestions(BuildContext context) async {
    final jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/questions.json');
    return questionsFromJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        backgroundColor: CustomColors.main,
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width * 0.20,
                decoration: BoxDecoration(
                    color: CustomColors.cyan,
                    border: Border(
                        right: BorderSide(width: 1, color: CustomColors.main))),
                child: FutureBuilder(
                  future: fetchFruits(context),
                  builder: (context, fruitsdata) {
                    if (fruitsdata.hasData) {
                      return ListView.builder(
                          itemCount: fruitsdata.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Fruits fruit = fruitsdata.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(fruit.name),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
            Expanded(
              child: Container(
                color: Colors.white,
                child: FutureBuilder(
                  future: fetchQuestions(context),
                  builder: (context, questiondata) {
                    if (questiondata.hasData) {
                      return ListView.builder(
                          itemCount: questiondata.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            Questions question = questiondata.data[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(question.title),
                            );
                          });
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
