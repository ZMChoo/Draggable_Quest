// To parse this JSON data, do
//
//     final questions = questionsFromJson(jsonString);

import 'dart:convert';

List<Fruits> welcomeFromJson(String str) => List<Fruits>.from(json.decode(str).map((x) => Fruits.fromJson(x)));

String welcomeToJson(List<Fruits> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Fruits {
    String name;
    String color;

    Fruits({
        this.name,
        this.color,
    });

    factory Fruits.fromJson(Map<String, dynamic> json) => Fruits(
        name: json["name"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "color": color,
    };
}