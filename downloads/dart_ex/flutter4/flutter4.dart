// 導入 Material Components Widget 程式庫
// 目前針對 flutter web 與 mobile 的程式庫已經整合為一
import 'package:flutter/material.dart';

// Dart 程式必須從 main() 函式啟動執行
void main() {
// main() 函式中只實現一個 runApp() 案例, 其中的輸入為 MaterialApp 物件
// 且 MaterialApp 中, 帶有兩個屬性的設定, 包括 debugShowCheckedModeBanner 與 home 欄位中的資料設定
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

// 延伸 StatelessWidget 定義 ExampleScreen 類別
// StatelessWidget 是一種不需要狀態更改的使用者介面部件
// StatelessWidget 無需管理內部狀態與可變狀態的 StatefulWidget 相對照
class MyApp extends StatelessWidget {
  MyApp();

  Widget build(BuildContext context) {
    return MaterialApp(
    // 以訂製的 Scaffold() 布局架構物件設定 home 屬性
    // https://api.flutter.dev/flutter/material/Scaffold-class.html
    // Scaffold() 是一個基本視覺布局架構部件, 提供 drawers, snack bars, and bottom sheets 等部件的架構設定
      home: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          BlueBox(),
          BlueBox(),
          BlueBox(),
        ]),
      ),
    );
  }
}

class BlueBox extends StatelessWidget {
/*
延伸自其他物件的類別定義時, 若要改寫在父類別已經存在的同名方法或實現一個 abstract method 時, 可以選擇冠上 @override 標示
abstract methods 只能存在 abstract class 中.
建立 abstract method 時隨後必須直接加上分號 (;) 而無方法內容定義.
而 abstract class 則是一種無法直接產生案例的類別, 但可以用於 sub-classed.
定義 abstract class 時必須使用 abstract 關鍵字.
https://medium.com/jay-tillu/abstract-class-and-abstract-methods-in-dart-4630f1e39f64
*/
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
