import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

Future main() async {
  await ui.webOnlyInitializePlatform();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          BlueBox(),
        ]),
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(),
      ),
    );
  }
}