import 'package:draggable_project/common/customColors.dart';
import 'package:flutter/material.dart';

class DraggableHome extends StatefulWidget {
  @override
  _DraggableHomeState createState() => _DraggableHomeState();
}

class _DraggableHomeState extends State<DraggableHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        backgroundColor: CustomColors.grey3,
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
            ),
            Expanded(
              child: Container(
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
}
