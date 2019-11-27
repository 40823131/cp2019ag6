// https://github.com/aab29/slithery
// https://www.dartographer.com/very-simple-web-animation-with-dart-slithery/

import "dart:html";
import "dart:math";

// 定義 SnakePoint 類別
class SnakePoint {
  final Point<double> oscillationRate;
  final double timeOffset;
  final double canvasSize;
  final double slitherRadius;

  double x;
  double y;
  // 建構子
  SnakePoint(this.oscillationRate, this.timeOffset, this.canvasSize,
      this.slitherRadius);

  void updateLocation(double time) {
    var adjustedTime = time + timeOffset;

    x = canvasSize *
        (0.5 + cos(oscillationRate.x * adjustedTime) * slitherRadius);
    y = canvasSize *
        (0.5 + sin(oscillationRate.y * adjustedTime) * slitherRadius);
  }
}

// 定義 Snake 類別
class Snake {
  static final Random randomGenerator = new Random();

  static const oscillationRate = const Point(0.0023, 0.0015);
  static const thicknessProportion = 0.022;
  static const randomizedTimeRange = 100000.0;
  static const slitherRadius = 0.35;
  static const pointTimeOffsets = [0, 120.0, 230.0, 300.0];

  double _canvasSize;
  double _thickness;

  List<SnakePoint> _points;
  SnakePoint _headPoint;
  SnakePoint _controlPointA;
  SnakePoint _controlPointB;
  SnakePoint _tailPoint;
  // 建構子
  Snake(this._canvasSize) {
    _thickness = _canvasSize * thicknessProportion;

    var leadingTimeOffset = randomGenerator.nextDouble() * randomizedTimeRange;

    _points = pointTimeOffsets
        .map((pointOffset) => new SnakePoint(oscillationRate,
            leadingTimeOffset - pointOffset, _canvasSize, slitherRadius))
        .toList(growable: false);

    _headPoint = _points[0];
    _controlPointA = _points[1];
    _controlPointB = _points[2];
    _tailPoint = _points[3];
  }
  // Sname 類別方法
  void draw(CanvasRenderingContext2D context, double time) {
    _points.forEach((point) => point.updateLocation(time));

    context.setStrokeColorRgb(0, 255, 120);
    context.lineWidth = _thickness;
    context.lineCap = "round";
    context.beginPath();
    context.moveTo(_headPoint.x, _headPoint.y);
    context.bezierCurveTo(_controlPointA.x, _controlPointA.y, _controlPointB.x,
        _controlPointB.y, _tailPoint.x, _tailPoint.y);
    context.stroke();
  }
}

// 定義 CanvasTools
class CanvasTools {
  static CanvasElement configureSquareCanvas(
      {String elementId = "canvas", num maxSizeProportion = 0.8}) {
    CanvasElement canvas = querySelector("#$elementId");

    var smallerDimension = min(window.innerWidth, window.innerHeight);
    var size = (smallerDimension * maxSizeProportion).round();

    canvas.width = size;
    canvas.height = size;

    return canvas;
  }
}

// 定義 Simulation 類別
class Simulation {
  CanvasElement _canvas;
  CanvasRenderingContext2D _context;

  double _canvasSize;

  Snake _snake;
  // 建構子
  Simulation(this._canvas, this._context) {
    _canvasSize = _canvas.width.toDouble();
    _snake = new Snake(_canvasSize);
    _startAnimating();
  }

  void _startAnimating() {
    window.requestAnimationFrame(_update);
  }

  void _update(num time) {
    _context.clearRect(0.0, 0.0, _canvasSize, _canvasSize);
    _snake.draw(_context, time);
    window.requestAnimationFrame(_update);
  }
}

// 主函式
void main() {
  var canvas = CanvasTools.configureSquareCanvas();
  var context = canvas.getContext("2d") as CanvasRenderingContext2D;

  new Simulation(canvas, context);
}
