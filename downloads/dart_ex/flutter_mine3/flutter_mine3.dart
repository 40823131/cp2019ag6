// https://github.com/tensor-programming/flutter_mine_sweeper_tutorial
import 'package:flutter/material.dart';
import 'dart:math';

enum TileState { covered, blown, open, flagged, revealed }

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MineSweeper(),
    ),
  );
}

class MineSweeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "3 佈雷雷",
      home: Board(),
    );
  }
}

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  final int rows = 9;
  final int cols = 9;
  final int numOfMines = 11;

  List<List<TileState>> uiState;
  List<List<bool>> tiles;

  void resetBoard() {
    uiState = new List<List<TileState>>.generate(rows, (row) {
      return new List<TileState>.filled(cols, TileState.covered);
    });

    tiles = new List<List<bool>>.generate(rows, (row) {
      return new List<bool>.filled(cols, false);
    });

    Random random = Random();
    int remainingMines = numOfMines;
    while (remainingMines > 0) {
      int pos = random.nextInt(rows * cols);
      int row = pos ~/ rows;
      int col = pos % cols;
      if (!tiles[row][col]) {
        tiles[row][col] = true;
        remainingMines--;
      }
    }
  }

  @override
  void initState() {
    resetBoard();
    super.initState();
  }

  Widget buildBoard() {
    List<Row> boardRow = <Row>[];
    for (int y = 0; y < rows; y++) {
      List<Widget> rowChildren = <Widget>[];
      for (int x = 0; x < cols; x++) {
        TileState state = uiState[y][x];
        int count = mineCount(x, y);
        if (state == TileState.covered || state == TileState.flagged) {
          rowChildren.add(GestureDetector(
            onLongPress: () {
              flag(x, y);
            },
            onTap: () {
              probe(x, y);
            },
            child: Listener(
                child: CoveredMineTile(
              flagged: state == TileState.flagged,
              posX: x,
              posY: y,
            )),
          ));
        } else {
          rowChildren.add(OpenMineTile(
            state: state,
            count: count,
          ));
        }
      }
      boardRow.add(Row(
        children: rowChildren,
        mainAxisAlignment: MainAxisAlignment.center,
        key: ValueKey<int>(y),
      ));
    }
    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: boardRow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mine Sweeper'),
      ),
      body: Container(
        color: Colors.grey[50],
        child: Center(
          child: buildBoard(),
        ),
      ),
    );
  }

  void probe(int x, int y) {
    if (uiState[y][x] == TileState.flagged) return;
    setState(() {
      if (tiles[y][x]) {
        uiState[y][x] = TileState.blown;
      } else {
        open(x, y);
      }
    });
  }

  void open(int x, int y) {
    if (!inBoard(x, y)) return;
    if (uiState[y][x] == TileState.open) return;
    uiState[y][x] = TileState.open;

    if (mineCount(x, y) > 0) return;

    open(x - 1, y);
    open(x + 1, y);
    open(x, y - 1);
    open(x, y + 1);
    open(x - 1, y - 1);
    open(x + 1, y + 1);
    open(x + 1, y - 1);
    open(x - 1, y + 1);
  }

  void flag(int x, int y) {
    setState(() {
      if (uiState[y][x] == TileState.flagged) {
        uiState[y][x] = TileState.covered;
      } else {
        uiState[y][x] = TileState.flagged;
      }
    });
  }

  int mineCount(int x, int y) {
    int count = 0;
    count += bombs(x - 1, y);
    count += bombs(x + 1, y);
    count += bombs(x, y - 1);
    count += bombs(x, y + 1);
    count += bombs(x - 1, y - 1);
    count += bombs(x + 1, y + 1);
    count += bombs(x + 1, y - 1);
    count += bombs(x - 1, y + 1);
    return count;
  }

  int bombs(int x, int y) => inBoard(x, y) && tiles[y][x] ? 1 : 0;
  bool inBoard(int x, int y) => x >= 0 && x < cols && y >= 0 && y < rows;
}

Widget buildTile(Widget child) {
  return Container(
    padding: EdgeInsets.all(1.0),
    height: 30.0,
    width: 30.0,
    color: Colors.grey[400],
    margin: EdgeInsets.all(2.0),
    child: child,
  );
}

Widget buildInnerTile(Widget child) {
  return Container(
    padding: EdgeInsets.all(1.0),
    margin: EdgeInsets.all(2.0),
    height: 20.0,
    width: 20.0,
    child: child,
  );
}

class CoveredMineTile extends StatelessWidget {
  final bool flagged;
  final int posX;
  final int posY;

  CoveredMineTile({this.flagged, this.posX, this.posY});

  @override
  Widget build(BuildContext context) {
    Widget text;
    if (flagged) {
      text = buildInnerTile(RichText(
        text: TextSpan(
          text: "\u2691",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        textAlign: TextAlign.center,
      ));
    }
    Widget innerTile = Container(
      padding: EdgeInsets.all(1.0),
      margin: EdgeInsets.all(2.0),
      height: 20.0,
      width: 20.0,
      color: Colors.grey[350],
      child: text,
    );

    return buildTile(innerTile);
  }
}

class OpenMineTile extends StatelessWidget {
  final TileState state;
  final int count;
  OpenMineTile({this.state, this.count});

  final List textColor = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.cyan,
    Colors.amber,
    Colors.brown,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    Widget text;

    if (state == TileState.open) {
      if (count != 0) {
        text = RichText(
          text: TextSpan(
            text: '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor[count - 1],
            ),
          ),
          textAlign: TextAlign.center,
        );
      }
    } else {
      text = RichText(
        text: TextSpan(
          text: '\u2739',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        textAlign: TextAlign.center,
      );
    }
    return buildTile(buildInnerTile(text));
  }
}