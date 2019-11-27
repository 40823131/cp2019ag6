import 'dart:html';

CanvasElement canvas = querySelector('#canvas');
CanvasRenderingContext2D ctx = canvas.getContext('2d');
int w = canvas.width;
int h = canvas.height;
const int s = 15;
const int pL = s;
const int pT = s;
const int pR = s;
const int pB = s;

drawBoard() {
  ctx.strokeStyle = 'lightgrey';
  ctx.beginPath();
  for (var x = pL; x <= w - pR; x += s) {
    ctx.moveTo(x, pT);
    ctx.lineTo(x, h - pB);
  }
  for (var y = pT; y <= h - pB; y += s) {
    ctx.moveTo(pL, y);
    ctx.lineTo(w - pR, y);
  }
  ctx.stroke();

  ctx.strokeStyle = "black";
  ctx.stroke();
}

void main() {
  drawBoard();
}
