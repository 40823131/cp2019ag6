// 導入 Material Components Widget 程式庫
// 目前針對 flutter web 與 mobile 的程式庫已經整合為一
import 'package:flutter/material.dart';

// Dart 程式必須從 main() 函式啟動執行
void main() {
// main() 函式中只實現一個 runApp() 案例, 其中的輸入為 MaterialApp 物件
// 且 MaterialApp 中, 帶有四個屬性的設定, 包括 title, theme, debugShowCheckedModeBanner 與 home 欄位中的資料設定
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is setting the primary color of the app to Blue.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(title: 'Flutter Home Demo Page'),
    ),
  );
}

// This Widget is Stateful,
// because it's managing the state of the counter.
class MyHomePage extends StatefulWidget {
  /* 
      與類別同名的方法為此類別的建構子 (constructor), 利用此類別建立案例時
      建構子中的內容會同時被執行
  */
  // this 指利用此類別實現的案例物件, 直接在建構子中導入 this.title 為 syntactic sugar
  // 表示 title 變數為類別變數, 透過語法糖可自動起始, 並可在案例物件中的各方法中引用
  // 在輸入區中的參數宣告以大括號圈起, 表示 key 與 title 為選項輸入的命名參數, 可有可無
  // 參數 key 的資料型別為 Key
  // 從 : 符號開始, 則宣告所啟動的內容, 可以執行案例物件建構子內容之前, 先行執行
  // 此一建構子沒有執行內容, 而只是將其父類別中的 key 變數直接傳遞給此類別的建構子
  MyHomePage({Key key, this.title}) : super(key: key);
  // It's being passed in title, you can see above.
  
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title; // => Flutter Home Demo Page

   // Stateful Widgets don't have build methods.
   // They have createState() methods.
   // Create State returns a class that extends Flutters State class.
  @override
  _MyHomePageState createState() => new _MyHomePageState();

  // Stateful Widgets are rarely more complicated than this.
}

// This is the state that MyHomePage created.
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // I've left in the comments from the sample app
  // because they say it better than I could:
  void _incrementCounter() {
    // Built in Flutter Method.
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    // for instance as done by the _incrementCounter method above.

    // Scaffold is another build in app that gives us a standard
    // mobile app layout. You'll most likely use this on every page
    // of your app
    return new Scaffold(
      // the bar accross the top of the app
      appBar: new AppBar(
        // State classes access properties on their
        // parent by calling widget.someProperty
        //  It's easier to think of StatefulWidgets and their corresponding
        // StateClasses as a single Widget.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child
        // and positions it in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a List of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // mainAxisAlignment and crossAxisAlignment should feel very familiar
          // if you're used to using CSS's Flexbox or Grid.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              // Text takes a String as it's first argument.
              // We're passing in the value of the counter
              // as an interpolated String.
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      // Floating action buttons are special button
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}