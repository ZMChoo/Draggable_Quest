import 'package:draggable_project/screen/draggableHome.dart';
import 'package:draggable_project/screen/home.dart';
import 'package:draggable_project/screen/score.dart';
import 'package:flutter/material.dart';
import 'package:draggable_project/main.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Home());
      case '/draggableHome':
        return MaterialPageRoute(
            builder: (_) => DraggableHome(
                // data: args
                ));
      case '/score':
        return MaterialPageRoute(
            builder: (_) => ScorePage(
                // score: args,
                ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text("Page not found"),
        ),
      );
    });
  }
}
