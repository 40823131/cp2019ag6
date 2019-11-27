import 'dart:html';
import 'dart:math' as math;

// 定義一個變數 cavas 設為 CanvasElement, 對應到 index.html 中 id=canvas 的畫布區
CanvasElement canvas = querySelector('#canvas');
// 將 canvas 畫布中的  2D 繪圖環境與 ctx 變數對應
CanvasRenderingContext2D ctx = canvas.getContext('2d');
int width = canvas.offsetWidth;
int height = canvas.offsetHeight;

plotData(arrX, arrY) {
  //ctx.setTransform(Horizontal scaling, Vertical skewing, Horizontal skewing, Vertical scaling, Horizontal translation, Vertical translation)
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.fillStyle = "rgb(255,255,237)";
  ctx.fillRect(0, 0, width, height);

  ctx.strokeStyle = 'black';
  ctx.beginPath();
  ctx.moveTo(0.1 * width, 0.05 * height);
  ctx.lineTo(0.08 * width, 0.08 * height);
  ctx.moveTo(0.1 * width, 0.05 * height);
  ctx.lineTo(0.12 * width, 0.08 * height);
  ctx.moveTo(0.1 * width, 0.05 * height);
  ctx.lineTo(0.1 * width, 0.9 * height);
  ctx.lineTo(0.95 * width, 0.9 * height);
  ctx.lineTo(0.92 * width, 0.88 * height);
  ctx.moveTo(0.95 * width, 0.9 * height);
  ctx.lineTo(0.92 * width, 0.92 * height);
  ctx.stroke();
  ctx.translate(0.1 * width, 0.9 * height);
  // x 座標向右為正, y 座標反向, 向上為正
  ctx.scale(1, -1);
  // 執行繪線
  ctx.stroke();
  
  // 利用 sort 取出數列中最大與最小值, 雖非最具效率, 但是較直覺簡單
  // 將數列元素值, 由小到大排序
  arrX.sort();
  arrY.sort();
  // 排序第一之數值為數列中最小值
  var minX = arrX[0];
  var minY = arrY[0];
  // 排序最後之數值為數列中最大值
  // 數列.length 屬性為該數列元素個數
  var maxX = arrX[arrX.length-1];
  var maxY = arrY[arrY.length-1];

  // 算出 x 與 y 座標最大與最小值之間的差距
  var xrange = maxX - minX;
  var yrange = maxY - minY;
  
  // 繪圖使用寬度與高度
  var gWidth = 0.95 * width - 0.1 * width;
  var gHeight = 0.9 * height - 0.05 * height;
  // x 與 y 數值轉為繪圖單位 factor
  var facX = gWidth / xrange;
  var facY = gHeight / yrange;

  ctx.beginPath();
  ctx.fillStyle = 'Blue';
  ctx.strokeStyle = 'brown';
  // 線寬
  ctx.lineWidth = 0.002 * (width + height);
  var newx, newy;
  // 根據座標點個數逐一連線
  for (int i = 0; i < arrX.length; i++) {
    newx = (arrX[i] - minX) * facX;
    newy = (arrY[i] - minY) * facY;
    // 第一點採 moveTo, 其餘 lineTo 繪圖
    if (i == 0)
      ctx.moveTo(newx, newy);
    else
      ctx.lineTo(newx, newy);
  }
  ctx.stroke();
  
  // 與座標線繪圖相同, 標示文字座標 x 向右為正, y 向上為正
  ctx.scale(1, -1);
  ctx.fillStyle = 'darkblue';
  ctx.textBaseline = 'middle';
  ctx.textAlign = 'center';
  // 座標上標示文字字型大小
  var fntSize = 0.02 * (width + height);
  ctx.font = "$fntSize" + "pt serif";
  // 列出最小 x 與 y 數值繪圖起點
  var txtB = " ($minX, $minY)";
  var txtBW = ctx.measureText(txtB).width;
  if (txtBW > 0.1 * width) txtBW = 0.1 * width;
  // 以 dartblue 繪製文字標示
  ctx.fillText(txtB, -txtBW / 2, 0.05 * gHeight, txtBW);
  ctx.beginPath();
  // 座標線上共列出 5 個數值標示
  int nTick = 5;
  for (int i = 1; i <= nTick; i++) {
    // 列出 x 軸上數值標示
    ctx.moveTo(i * gWidth / (nTick + 1), 0.02 * height);
    ctx.lineTo(i * gWidth / (nTick + 1), -0.02 * height);
    txtB = "${((i / (nTick + 1) * xrange + minX) * 100).round() / 100}";
    txtBW = ctx.measureText(txtB).width;
    if (txtBW > 0.06 * width) txtBW = 0.06 * width;
    ctx.fillText(txtB, i * gWidth / 6, 0.06 * height, txtBW);
    
    // 列出 y 軸上數值標示
    ctx.moveTo(0.02 * width, -i * gHeight / (nTick + 1));
    ctx.lineTo(-0.02 * width, -i * gHeight / (nTick + 1));
    txtB = "${((i / (nTick + 1) * yrange + minY) * 100).round() / 100}";
    txtBW = ctx.measureText(txtB).width;
    if (txtBW > 0.06 * width) txtBW = 0.06 * width;
    ctx.fillText(txtB, -0.06 * width, -i * gHeight / 6, txtBW);
  }
  // 以 magenta 繪製座標標示線段
  ctx.strokeStyle = 'magenta';
  // 完成上述所設定的繪圖內容
  ctx.stroke();
  // 結束座標點繪圖
}

// 下列 Dart 程式, 利用 Runge Kutta 迭代運算法, 解常微分方程式
// 設 t 為時間, x 則設為物體的位移
// dx / dt = (t - x)/2, 起始值 t0=0, x0=1, 求 t=2 時的 x 值
//
// 已知起始值 t0 與 x0 後, 可以利用下列 rungeKutta 函式, 以
// h 為每步階增量值, 求 dxdt 常微分方程式任一 t 的對應值 x
// 定義函式 rungeKutta, 共有四個輸入變數
rungeKutta(t0, x0, t, h) {
  List data=[];
  List arrayT=[];
  List arrayX=[];
  // 利用步階增量值 h 與 t 的起始及終點值
  // 計算需要迭代的次數 n
  int n = ((t - t0) / h).toInt();
  // 宣告 x 為雙浮點數, 且設為起始值 x0
  double x = x0;
  // 利用已知的 t0, x0, t 終點值與步階增量值 h, 迭代求 x 對應值
  // 索引值 i 將每次增量 1, 從 i=1 執行 for 環圈至 i=n
  for (int i = 1; i <= n; i++) {
    arrayT.add(t0);
    //print(arrayT);
    arrayX.add(x);
    //print(arrayX);
    // 將此階段的 t 與 x 值代入 dxdt 函式求下列四個浮點變數值
    double k1 = h * dxdt(t0, x);
    double k2 = h * dxdt(t0 + 0.5 * h, x + 0.5 * k1);
    double k3 = h * dxdt(t0 + 0.5 * h, x + 0.5 * k2);
    double k4 = h * dxdt(t0 + h, x + k3);
    // 利用上述四個變數值求此步階增量後的對應 x 值
    x = x + (1.0 / 6.0) * (k1 + 2 * k2 + 2 * k3 + k4);
    // 每次 for 迴圈執行最後, 準備計算下一個步階增量後的 x 對應值
    // t 起始值配合步階增量值 h, 進行增量
    t0 = t0 + h;
  }
  data = [arrayT, arrayX];
  // 完成 for 迴圈迭代後, 傳回與 t 終點值對應的 x 值
  return data;
}

// 將微分方程式 "dx / dt = v(x, t)" 定義為 dxdt 函式
dxdt(t, x) {
  return ((math.cos(x)+math.sin(x)) / 2);
}

// 定義 main() 主函式內容, 目的在利用 rungeKutta 函式
// 解常微分方程式
main() {
// Driver method
// num 資料型別可以是整數或雙浮點數
  num t0 = 0;
  num x = 1;
  num t = 10;
  double h = 0.1;
  List data;
  // 將 Runge-Kutta 法從 t0 至 t 的運算數值傳回, 與 data 數列對應
  data = rungeKutta(t0, x, t, h);
  // 所傳回的 data 第一元素為 x 座標數列, 第二元素為 y 座標數列
  // 將各座標點作為繪線輸入變數, 執行繪圖
  plotData(data[0], data[1]);
  //print('The value of x at t=$t is: ${rungeKutta(t0, x, t, h)}');
}


