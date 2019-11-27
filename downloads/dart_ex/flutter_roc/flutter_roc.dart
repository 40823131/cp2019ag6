import 'package:flutter/material.dart';
import 'dart:math' as math;

class DrawingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ROC 國旗", style: TextStyle(fontSize: 30)),
          backgroundColor: Colors.green[600],
          centerTitle: true
        ),
        body: CustomPaint(
          painter: ROCPainter(),
          // 將圖顯示在正中央
          child: Center(
            /*
            child: Text(
              "Blade Runner",
              style: TextStyle(fontSize: 30, fontStyle: FontStyle.italic),
            ),*/
          ),
        ));
  }
}

class ROCPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    int flagW = size.width.toInt();
    int flagH = size.height.toInt();
    num circleX = flagW / 4;
    num circleY = flagH / 4;
    // 填入滿地紅
    paint.color = Color(0xFFFF0000);
    var redPath = Path();
    redPath.moveTo(0, 0);
    redPath.lineTo(size.width, 0);
    redPath.lineTo(size.width, size.height);
    redPath.lineTo(0, size.height);
    redPath.close();
    paint.style = PaintingStyle.fill;
    canvas.drawPath(redPath, paint);
    // 填入青天
    paint.color = Color(0xFF0000FF);
    var bluePath = Path();
    bluePath.moveTo(0, 0);
    bluePath.lineTo(size.width/2, 0);
    bluePath.lineTo(size.width/2, size.height/2);
    bluePath.lineTo(0, size.height/2);
    bluePath.close();
    paint.style = PaintingStyle.fill;
    canvas.drawPath(bluePath, paint);
    // 畫十二道光芒白日
    var twelveWhite  = Path();
    num starRadius = flagW / 8;
    num angle = 0;
    for (int i = 0; i < 25; i++) {
        angle += 5 * math.pi * 2 / 12;
        num toX = circleX + math.cos(angle) * starRadius;
        num toY = circleY + math.sin(angle) * starRadius;
        // 只有 i 為 0 時移動到 toX, toY, 其餘都進行 lineTo
        if (i != 0)
            twelveWhite.lineTo(toX, toY);
        else
            twelveWhite.moveTo(toX, toY);
    }
    twelveWhite.close();
    // 將填色設為白色
    paint.color = Color(0xFFFFFFFF);
    paint.style = PaintingStyle.fill;
    canvas.drawPath(twelveWhite, paint);
    // 小白日與大藍圓形填色, 製作藍色光環
    // 藍色大圓
    paint.color = Color(0xFF0000FF);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(circleX, circleY), flagW * 17 / 240, paint);
    // 白色小圓
    paint.color = Color(0xFFFFFFFF);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(circleX, circleY), flagW / 16, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "畫青天白日滿地紅國旗",
      debugShowCheckedModeBanner: false,
      home: DrawingPage(),
    );
  }
}