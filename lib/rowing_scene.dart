import 'dart:async';
import 'dart:ui';

import 'package:ergregatta/session_context.dart';
import 'package:ergregatta/segment_display.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class RowingScene extends CustomPainter {
  final log = Logger('PmBleWrapper');
  SessionContext boatManager = SessionContext();

  Paint bgPaint = Paint().configure(color: Colors.lightBlue);

  Paint linePaint = Paint().configure(color: Colors.yellow, strokeWidth: 4.0);
  Paint endLine = Paint().configure(color: Colors.white, strokeWidth: 4.0);

  @override
  void paint(Canvas canvas, Size size) {
    Rect rectSize =
        Rect.fromPoints(const Offset(0, 0), Offset(size.width, size.height));
    canvas.drawRect(rectSize, bgPaint);

    List<Boat> boats = SessionContext().boats;

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

      SegmentDisplay sg3 = SegmentDisplay(canvas, lw - 200, lh * i + lh / 4.0,
          125, 50, b.rowed.toInt().toString().padLeft(4, "0"));
      sg3.draw();

      Rect r = Rect.fromLTWH(b.rowed - 50, lh * i + lh / 2.0 - 25, 100, 25);

      canvas.drawOval(r, linePaint);
    }
    Offset p1 = Offset(0, size.height); //top
    Offset p2 = Offset(size.width, size.height); //bottom
    canvas.drawLine(p1, p2, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    log.info("shouldRepaint RowingScene ***********************");
    return true;
  }
}
