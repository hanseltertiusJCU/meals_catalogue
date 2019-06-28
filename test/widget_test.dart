// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  testWidgets('Widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      title: "Meals Catalogue",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Meals Catalogue"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/empty-box.png'),
                      fit: BoxFit.contain
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 4.0),
              child: Text('There is no data'),
            ),
          ],
        ),
      ),
    ));


  });
}
