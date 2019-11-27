import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      title: '歡迎使用 Flutter',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('歡迎使用 Flutter', style: TextStyle(fontSize: 30)),
        ),
        body: Center(
          child: Text('哈囉, Dart!', style: TextStyle(fontSize: 40)),
        ),
      ),
    ));