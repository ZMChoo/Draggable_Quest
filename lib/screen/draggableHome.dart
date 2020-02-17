import 'dart:convert';

import 'package:draggable_project/common/customColors.dart';
import 'package:draggable_project/modal/fruits.dart';
import 'package:draggable_project/modal/questions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DraggableHome extends StatefulWidget {
  @override
  _DraggableHomeState createState() => _DraggableHomeState();
}

class _DraggableHomeState extends State<DraggableHome> {
  int questionIndex = 0;
  bool questionIsCorrect = false;
  List<String> answerList = [];
  List<String> selectedFruits = [];
  bool onPause = false;
  bool showMsg = false;
  bool showButton = false;
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

  // List<Widget> buildSelectedFruits(List<String> selectedFruits) {
  //   List<Widget> selectedFruitsList = [];

  //   selectedFruits.forEach((f) {
  //     selectedFruitsList.add(Container(
  //       width: 50,
  //       height: 50,
  //       child: Image.asset('assets/img/' + f + '.png'),
  //     ));
  //   });

  //   return selectedFruitsList;
  // }

  bool checkSelectedFruit(List<String> answer) {
    for (final f in selectedFruits) {
      if (!answer.contains(f)) {
        return false;
      }
    }
    return true;
  }

  Widget buildDraggableQuestion(int questionIndex) {
    switch (questionIndex) {
      case 0:
        if (questionIsCorrect) {
          return Image.asset('assets/img/monkey_success.png');
        } else {
          return Image.asset('assets/img/monkey_question.jpg');
        }
        break;

      case 1:
        return Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.width * 0.35,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                primary: false,
                shrinkWrap: true,
                itemCount: selectedFruits.length,
                itemBuilder: (context, index) {
                  return Draggable(
                    data: selectedFruits[index],
                    onDraggableCanceled: (velocity, offset) {
                      print("rejected");
                      selectedFruits.removeAt(index);
                      setState(() {
                        selectedFruits;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                          'assets/img/' + selectedFruits[index] + '.png'),
                    ),
                    feedback: Container(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                          'assets/img/' + selectedFruits[index] + '.png'),
                    ),
                    childWhenDragging: Container(),
                  );
                }));
        break;

      case 2:
        return Container(
          alignment: Alignment.topCenter,
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Text("whats to do here")
        );
        break;
      default:
        if (questionIsCorrect) {
          return Image.asset('assets/img/monkey_question.jpg');
        } else {
          return Image.asset('assets/img/monkey_success.png');
        }
    }
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
                            padding: const EdgeInsets.only(top: 10, bottom: 5),
                            child: Text(
                              question.instruction,
                              style: TextStyle(
                                  fontSize: 14, color: CustomColors.grey3),
                            ),
                          ),
                          DragTarget(
                            builder: (context, List<String> draggableData,
                                rejectedData) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: MediaQuery.of(context).size.width * 0.7,
                                child: buildDraggableQuestion(questionIndex),
                              );
                            },
                            onWillAccept: (data) {
                              if (!onPause && questionIndex == 0) {
                                if (question.answer.contains(data)) {
                                  return true;
                                } else {
                                  setState(() {
                                    showMsg = true;
                                  });
                                }
                              } else if (!onPause && questionIndex == 1) {
                                if (selectedFruits.length > 0) {
                                  if (!selectedFruits.contains(data)) {
                                    selectedFruits.add(data);
                                    return true;
                                  }
                                } else {
                                  selectedFruits.add(data);
                                }
                                setState(() {
                                  selectedFruits;
                                });
                              } else if (!onPause && questionIndex == 2) {}

                              return false;
                            },
                            onAccept: (data) {
                              // print(data);
                              if (!onPause && questionIndex == 0) {
                                if (question.answer.contains(data)) {
                                  setState(() {
                                    questionIsCorrect = true;
                                    onPause = true;
                                    showMsg = true;
                                    showButton = true;
                                  });
                                }
                              } else if (!onPause && questionIndex == 1) {
                                // setState(() {});
                              } else if (!onPause && questionIndex == 2) {}
                            },
                            onLeave: (data) {
                              print(data);
                            },
                          ),
                          showMsg
                              ? Padding(
                                  padding: EdgeInsets.only(top: 30, bottom: 30),
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
                          showButton
                              ? InkWell(
                                  onTap: () {
                                    print(questionIndex);
                                    questionIndex == 0
                                        ? setState(() {
                                            onPause = false;
                                            questionIsCorrect = false;
                                            showMsg = false;
                                            showButton = true;
                                            questionIndex = questionIndex + 1;
                                          })
                                        : questionIndex == 1 &&
                                                questionIsCorrect
                                            ? setState(() {
                                                onPause = false;
                                                questionIsCorrect = false;
                                                showMsg = false;
                                                showButton = true;
                                                questionIndex =
                                                    questionIndex + 1;
                                              })
                                            : questionIndex == 1 &&
                                                    !questionIsCorrect
                                                ? selectedFruits.forEach((f) {
                                                    if (!question.answer
                                                        .contains(f)) {
                                                      setState(() {
                                                        showMsg = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        onPause = true;
                                                        questionIsCorrect =
                                                            true;
                                                        showButton = true;
                                                        showMsg = true;
                                                      });
                                                    }
                                                  })
                                                // :questionIndex == 1 ?
                                                // questionIsCorrect ?
                                                // setState(() {
                                                //   onPause = false;
                                                //   questionIsCorrect = false;
                                                //   showMsg = false;
                                                //   questionIndex = questionIndex + 1;
                                                // })
                                                // :checkSelectedFruit(question.answer) ?

                                                : Navigator.of(context)
                                                    .pushNamed('/score',
                                                        arguments: "3");
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Text(!questionIsCorrect
                                          ? "Submit"
                                          : "Next")),
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
