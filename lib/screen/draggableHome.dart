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
  List<String> selectedFruits = [];
  bool onPause = false;
  bool showMsg = false;
  bool showButton = false;
  bool showReset = false;
  bool isDone = false;
  final correctMsg = "Congratulation!\nWell done";
  final wrongMsg = "Opss!\nThis is not the correct answer";

  String box1 = "";
  String box2 = "";
  String box3 = "";

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

  bool checkSelectedFruit(List<String> answer) {
    for (final f in selectedFruits) {
      if (!answer.contains(f)) {
        return false;
      }
    }
    return true;
  }

  Widget _buildField(int query, String fruit, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                title.toUpperCase(),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              )),
          DragTarget(
            builder: (context, List<String> draggableData, rejectedData) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Draggable(
                  data: fruit,
                  onDraggableCanceled: (velocity, offset) {
                    setState(() {
                      query == 1
                          ? box1 = ""
                          : query == 2 ? box2 = "" : box3 = "";
                    });
                  },
                  child: fruit == ""
                      ? Container()
                      : Container(
                          width: 50,
                          height: 50,
                          child: Image.asset('assets/img/' + fruit + '.png'),
                        ),
                  feedback: fruit == ""
                      ? Container()
                      : Container(
                          width: 80,
                          height: 80,
                          child: Image.asset('assets/img/' + fruit + '.png'),
                        ),
                  childWhenDragging: Container(),
                ),
              );
            },
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {
              print(data);
              if (!onPause) {
                setState(() {
                  query == 1
                      ? box1 = data
                      : query == 2 ? box2 = data : box3 = data;
                });
              }
            },
            onLeave: (data) {},
          ),
        ],
      ),
    );
  }

  Widget buildDraggableQuestion(int questionIndex, List<String> answers) {
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
            width: MediaQuery.of(context).size.width * 0.65,
            child: Column(
              children: <Widget>[
                _buildField(1, box1, answers[0]),
                _buildField(2, box2, answers[1]),
                _buildField(3, box3, answers[2]),
              ],
            ));
        break;
      default:
        if (questionIsCorrect) {
          return Image.asset('assets/img/monkey_question.jpg');
        } else {
          return Image.asset('assets/img/monkey_success.png');
        }
    }
  }

  bool validateAnswer(List<String> answers) {
    for (var i = 0; i < answers.length; i++) {
      if (i == 0) {
        if (answers[i] != box1) {
          return false;
        }
      } else if (i == 1) {
        if (answers[i] != box2) {
          return false;
        }
      } else if (i == 2) {
        if (answers[i] != box3) {
          return false;
        }
      }
    }
    return true;
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
                                  onDragCompleted: () {},
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
                    double width = MediaQuery.of(context).size.width;

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
                                    vertical: 5, horizontal: 5),
                                width: questionIndex == 2
                                    ? width * 0.7
                                    : width * 0.5,
                                height: questionIndex == 2
                                    ? width * 0.75
                                    : width * 0.7,
                                child: buildDraggableQuestion(questionIndex,
                                    questionIndex == 2 ? question.answer : []),
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
                                // setState(() {
                                //   selectedFruits;
                                // });
                              } else if (!onPause && questionIndex == 2) {}

                              return false;
                            },
                            onAccept: (data) {
                              if (!onPause && questionIndex == 0) {
                                if (question.answer.contains(data)) {
                                  setState(() {
                                    questionIsCorrect = true;
                                    onPause = true;
                                    showMsg = true;
                                    showButton = true;
                                  });
                                }
                              }
                            },
                            onLeave: (data) {
                              print("1");
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          showReset
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      onPause = false;
                                      box1 = "";
                                      box2 = "";
                                      box3 = "";
                                      showMsg = false;
                                      showButton = true;
                                      showReset = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),
                                    child: Text(
                                      "Reset",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              : Container(),
                          showMsg
                              ? Padding(
                                  padding: EdgeInsets.only(top: 20, bottom: 10),
                                  child: Text(
                                    questionIsCorrect ? correctMsg : wrongMsg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: CustomColors.veryOrange,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Container(),
                          showButton
                              ? InkWell(
                                  onTap: () {
                                    print(questionIndex);
                                    isDone
                                        ? Navigator.of(context)
                                            .pushNamed('/score')
                                        : questionIndex == 0
                                            ? setState(() {
                                                onPause = false;
                                                questionIsCorrect = false;
                                                showMsg = false;
                                                showButton = true;
                                                questionIndex =
                                                    questionIndex + 1;
                                              })
                                            : questionIndex == 1 &&
                                                    questionIsCorrect
                                                ? setState(() {
                                                    onPause = false;
                                                    questionIsCorrect = false;
                                                    showMsg = false;
                                                    showButton = true;
                                                    selectedFruits = [];
                                                    questionIndex =
                                                        questionIndex + 1;
                                                  })
                                                : questionIndex == 1 &&
                                                        !questionIsCorrect
                                                    ? selectedFruits.length ==
                                                            question
                                                                .answer.length
                                                        ? checkSelectedFruit(
                                                                question.answer)
                                                            ? setState(() {
                                                                onPause = true;
                                                                questionIsCorrect =
                                                                    true;
                                                                showButton =
                                                                    true;
                                                                showMsg = true;
                                                              })
                                                            : setState(() {
                                                                showMsg = true;
                                                              })
                                                        : setState(() {
                                                            showMsg = true;
                                                          })
                                                    : questionIndex == 2
                                                        ? box1 != "" &&
                                                                box2 != "" &&
                                                                box3 != ""
                                                            ? validateAnswer(
                                                                        question
                                                                            .answer) ==
                                                                    true
                                                                ? setQuestionDone()
                                                                : setState(() {
                                                                    onPause =
                                                                        true;
                                                                    showReset =
                                                                        true;
                                                                    showMsg =
                                                                        true;
                                                                    showButton =
                                                                        false;
                                                                  })
                                                            : null
                                                        : null;
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

  void setQuestionDone() {
    setState(() {
      questionIsCorrect = true;
      showMsg = true;
      showButton = true;
      onPause = true;
      isDone = true;
    });
  }
}
