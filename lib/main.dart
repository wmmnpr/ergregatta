import 'package:flutter/material.dart';

import 'segment_display.dart';

class RegattaManager {
  static final List<Boat> _boats = initBoats();

  static List<Boat> initBoats() {
    List<Boat> list = [];
    list.add(Boat(" 900", 0));
    list.add(Boat("1000", 200));
    list.add(Boat("1000", 210));
    return list;
  }
}

class Boat {
  String distance;
  double rowed = 0;

  Boat(this.distance, this.rowed);
}

class RowingScene extends CustomPainter {
  RegattaManager boatManager = RegattaManager();

  Paint bgPaint = Paint().configure(color: Colors.lightBlue);

  Paint linePaint = Paint().configure(color: Colors.yellow, strokeWidth: 4.0);
  Paint endLine = Paint().configure(color: Colors.white, strokeWidth: 4.0);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectSize =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    canvas.drawRect(rectSize, bgPaint);

    List<Boat> boats = RegattaManager._boats;

    int laneCount = boats.length;
    double lh = size.height / laneCount;
    double lw = size.width;
    for (int i = 0; i < laneCount; i++) {
      Boat b = boats[i];
      Offset p1 = Offset(0, lh * i); //top
      Offset p2 = Offset(lw, lh * i); //bottom
      canvas.drawLine(p1, p2, linePaint);

      p1 = Offset(lw / 100, lh * i + 50); //start
      p2 = Offset(lw / 100, lh * (i + 1) - 50);
      canvas.drawLine(p1, p2, endLine);

      p1 = Offset(lw - lw / 100, lh * i + 50); //end
      p2 = Offset(lw - lw / 100, lh * (i + 1) - 50);
      canvas.drawLine(p1, p2, endLine);

      SegmentDisplay sg2 = SegmentDisplay(
          canvas, lw / 2.0 - 200 / 2.0, lh * i + lh / 4.0, 125, 50, b.distance);
      sg2.draw();

      SegmentDisplay sg3 = SegmentDisplay(
          canvas, lw  - 200, lh * i + lh / 4.0, 125, 50, b.rowed.toInt().toString().padLeft(4, "0"));
      sg3.draw();

      Rect r = Rect.fromLTWH(b.rowed - 50, lh * i + lh / 2.0 - 25, 100, 40);

      canvas.drawRect(r, linePaint);
    }
    Offset p1 = Offset(0, size.height); //top
    Offset p2 = Offset(size.width, size.height); //bottom
    canvas.drawLine(p1, p2, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    print("shouldRepaint RowingScene ***********************");
    return true;
  }
}

class RowingSceneWidget extends StatefulWidget {
  const RowingSceneWidget({super.key});

  @override
  _RowingSceneWidgetState createState() => _RowingSceneWidgetState();
}

class _RowingSceneWidgetState extends State<RowingSceneWidget> {
  int pushCount = 0;

  void _updateBoats() {
    pushCount++;
    for (var b in RegattaManager._boats) {
      b.rowed = b.rowed + 10;
    }
    setState(() {
      // Trigger a repaint by updating the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: RowingScene(),
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateBoats,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RowingSceneWidget(),
  ));
}
