// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';

List<Questions> questionsFromJson(String str) => List<Questions>.from(json.decode(str).map((x) => Questions.fromJson(x)));

String questionsToJson(List<Questions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Questions {
    String questionId;
    String title;
    String instruction;
    String answer;

    Questions({
        this.questionId,
        this.title,
        this.instruction,
        this.answer,
    });

    factory Questions.fromJson(Map<String, dynamic> json) => Questions(
        questionId: json["questionId"],
        title: json["title"],
        instruction: json["instruction"],
        answer: json["answer"],
    );

    Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "title": title,
        "instruction": instruction,
        "answer": answer,
    };
}