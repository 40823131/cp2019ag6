import 'package:flutter_web/material.dart';
import 'package:flutter_web_ui/ui.dart' as ui;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi Reddit',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hi Reddit'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.network(
                'https://i.imgur.com/GL9Z17t.png',
              ),
              Text('Pretty cool.'),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> main() async {
  await ui.webOnlyInitializePlatform();

  runApp(MyApp());
}