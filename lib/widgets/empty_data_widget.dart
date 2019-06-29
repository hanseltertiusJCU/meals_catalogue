import 'package:flutter/material.dart';

class EmptyDataWidget extends StatefulWidget {

  @override
  _EmptyDataWidgetScreen createState() => _EmptyDataWidgetScreen();

}

class _EmptyDataWidgetScreen extends State<EmptyDataWidget> {

  getEmptyDataContent() => [
    SizedBox(
      height: 60.0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/empty-box.png'),
              fit: BoxFit.contain),
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.only(top: 4.0),
      child: Text('There is no data'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: getEmptyDataContent(),
    );
  }

}