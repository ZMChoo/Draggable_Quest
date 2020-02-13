import 'package:draggable_project/screen/draggableHome.dart';
import 'package:flutter/material.dart';

class Routes {
  static String draggableHome = "/draggableHome";


  static Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    draggableHome: (context) => generateRoute(DraggableHome()),

  };

  static Widget generateRoute(Widget page) {
    return page;
  }

  static Widget getRoute(BuildContext context, String route) {
    return routes[route](context);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Map<String, dynamic> args = settings.arguments;
    // if (settings.name == ritualDetail) {
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       return generateRoute(RitualDetail(
    //           ritualInfo: args["ritualInfo"],
    //           onSlidingButtonPress: args["onSlidingButtonPress"]));
    //     },
    //   );
    // } 
    // else if (settings.name == myOrderSummary) {
    //   return MaterialPageRoute(
    //     builder: (context) {
    //       return generateRoute(MyOrderSummary(args["order"]));
    //     },
    //   );
    // }
    return MaterialPageRoute(builder: routes[settings.name]);
  }
}