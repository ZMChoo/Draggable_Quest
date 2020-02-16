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
  int questionIndex = 0;
  bool questionIsCorrect = false;
  List<String> answerList = [];
  bool onPause = false;
  bool showMsg = false;
  final correctMsg = "Congratulation!\nWell done";
  final wrongMsg = "Opss!\nThis is not the correct answer";

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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draggable Game"),
        backgroundColor: CustomColors.main,
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
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
                            return Container(
                                width: 50,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Draggable(
                                  data: fruit.name,
                                  onDragCompleted: () {
                                    print("accepted");
                                    setState(() {
                                      showMsg = true;
                                    });
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Image.asset(
                                        'assets/img/' + fruit.name + '.png'),
                                  ),
                                  feedback: Container(
                                    width: 80,
                                    height: 80,
                                    child: Image.asset(
                                        'assets/img/' + fruit.name + '.png'),
                                  ),
                                  childWhenDragging: Container(),
                                ));
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
                padding: EdgeInsets.all(10),
                child: FutureBuilder(
                  future: fetchQuestions(context),
                  builder: (context, questiondata) {
                    if (questiondata.hasData) {
                      Questions question = questiondata.data[questionIndex];
                      return Column(
                        children: <Widget>[
                          Text(
                            question.title,
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              question.instruction,
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.grey3),
                            ),
                          ),
                          DragTarget(
                            builder: (context, List<String> draggableData,
                                rejectedData) {
                              return Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child:
                                      // questionIndex == 0 && !questionIsCorrect
                                      questionIndex <= 2 && !questionIsCorrect
                                          ? Image.asset(
                                              'assets/img/monkey_question.jpg')
                                          : Image.asset(
                                              'assets/img/monkey_success.png'),
                                ),
                              );
                            },
                            onWillAccept: (data) {
                              // print(data);
                              if (!onPause) {
                                if (data == "banana") {
                                  return true;
                                } else {
                                  setState(() {
                                    questionIsCorrect = false;
                                    showMsg = true;
                                  });
                                  return false;
                                }
                              }
                              return false;
                            },
                            onAccept: (data) {
                              // print(data);
                              if (!onPause) {
                                if (data == "banana") {
                                  setState(() {
                                    questionIsCorrect = true;
                                    showMsg = true;
                                    onPause = true;
                                  });
                                } else {
                                  setState(() {
                                    questionIsCorrect = true;
                                    showMsg = true;
                                  });
                                }
                              }
                            },
                          ),
                          showMsg
                              ? Padding(
                                  padding: EdgeInsets.only(top: 50, bottom: 30),
                                  child: Text(
                                    questionIsCorrect ? correctMsg : wrongMsg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: CustomColors.veryOrange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                          showMsg && questionIsCorrect
                              ? InkWell(
                                  onTap: () {
                                    print(questionIndex);
                                    print("next question");
                                    questionIndex < 2
                                        ? setState(() {
                                            onPause = false;
                                            questionIsCorrect = false;
                                            showMsg = false;
                                            questionIndex = questionIndex + 1;
                                          })
                                        : Navigator.of(context)
                                            .pushNamed('/score',arguments: "3");
                                    ;
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text("Next")),
                                )
                              : Container()
                        ],
                      );
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
