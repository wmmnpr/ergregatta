import 'package:flutter/material.dart';

extension PaintFactory on Paint {
  Paint configure({Color color = Colors.black, double strokeWidth = 1.0}) {
    return this
      ..color = color
      ..strokeWidth = strokeWidth;
  }
}

extension PathBuilder on Path {
  Path build(List<Offset> offsets) {
    addPolygon(offsets, true);
    return this;
  }
}

class SegmentDisplay {
  static const double strokeWidth = 1.0;
  Paint onPaint =
      Paint().configure(color: Colors.yellow, strokeWidth: strokeWidth);
  Paint offPaint =
      Paint().configure(color: Colors.lightBlue, strokeWidth: strokeWidth);

  Map<Characters, int> segments = initSegments();

  double x, y, w, h;
  Canvas canvas;
  String v;

  SegmentDisplay(this.canvas, this.x, this.y, this.w, this.h, this.v);

  static Map<Characters, int> initSegments() {
    ///             -  s1 -
    ///            s6       s2
    ///                 s7
    ///            s5       s3
    ///             -  s4 -
    ///  8   4   2   1  :  8   4   2   1
    ///  0, s1, s2, s3, : s4, s5, s6, s7
    ///0 0,  1,  1,  1, :  1,  1,  1,  0
    ///1 0,  0,  1,  1, :  0,  0,  0,  0
    ///2 0,  1,  1,  0, :  1,  1,  0,  1
    ///3 0,  1,  1,  1, :  1,  0,  0,  1
    ///4 0,  0,  1,  1, :  0,  0,  1,  1
    ///5 0,  1,  0,  1, :  1,  0,  1,  1
    ///6 0,  0,  0,  1, :  1,  1,  1,  1
    ///7 0,  1,  1,  1, :  0,  0,  0,  0
    ///8 0,  1,  1,  1, :  1,  1,  1,  1
    ///9 0,  1,  1,  1, :  0,  0,  1,  1
    Map<Characters, int> segments = {};
    segments.putIfAbsent(" ".characters, () => 0x00);
    segments.putIfAbsent("0".characters, () => 0x7E);
    segments.putIfAbsent("1".characters, () => 0x30);
    segments.putIfAbsent("2".characters, () => 0x6D);
    segments.putIfAbsent("3".characters, () => 0x79);
    segments.putIfAbsent("4".characters, () => 0x33);
    segments.putIfAbsent("5".characters, () => 0x5B);
    segments.putIfAbsent("6".characters, () => 0x1F);
    segments.putIfAbsent("7".characters, () => 0x70);
    segments.putIfAbsent("8".characters, () => 0xFF);
    segments.putIfAbsent("9".characters, () => 0xF3);

    return segments;
  }

  draw() {
    int size = v.length;
    double xm = w / size * 0.25; // x margin
    double dw = w / size - xm; // digit width
    double dh = h;

    for (int i = 0; i < size; i++) {
      var c = v.characters.characterAt(i);
      double xl = x + (i * dw) + (i * xm);
      drawDigit(xl, y, dw, dh, c);
    }
  }

  void drawDigit(double x, double y, double w, double h, Characters c) {
    const double STROKE_WIDTH = 3;
    const double SEGMENT_POINTEDNESS = 1.0;
    const double d = STROKE_WIDTH * SEGMENT_POINTEDNESS;

    int ss = segments[c]!;
    //s1
    Paint pt = (ss & 0x40 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x, y),
          Offset(x + d, y - d),
          Offset(x + w - d, y - d),
          Offset(x + w, y),
          Offset(x + w - d, y + d),
          Offset(x + d, y + d)
        ]),
        pt);

    //s2
    pt = (ss & 0x20 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x + w, y),
          Offset(x + w + d, y + d),
          Offset(x + w + d, y + h / 2 - d),
          Offset(x + w, y + h / 2),
          Offset(x + w - d, y + h / 2 - d),
          Offset(x + w - d, y + d)
        ]),
        pt);

    //s3
    pt = (ss & 0x10 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x + w, y + h / 2),
          Offset(x + w + d, y + h / 2 + d),
          Offset(x + w + d, y + h - d),
          Offset(x + w, y + h),
          Offset(x + w - d, y + h - d),
          Offset(x + w - d, y + h / 2 + d)
        ]),
        pt);

    //s4
    pt = (ss & 0x08 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x + w, y + h),
          Offset(x + w - d, y + h + d),
          Offset(x + d, y + h + d),
          Offset(x, y + h),
          Offset(x + d, y + h - d),
          Offset(x + w - d, y + h - d)
        ]),
        pt);

    //s5
    pt = (ss & 0x04 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x, y + h),
          Offset(x - d, y + h - d),
          Offset(x - d, y + h / 2 + d),
          Offset(x, y + h / 2),
          Offset(x + d, y + h / 2 + d),
          Offset(x + d, y + h - d)
        ]),
        pt);

    //s6
    pt = (ss & 0x02 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x, y + h / 2),
          Offset(x - d, y + h / 2 - d),
          Offset(x - d, y + d),
          Offset(x, y),
          Offset(x + d, y + d),
          Offset(x + d, y + h / 2 - d)
        ]),
        pt);

    //s6
    pt = (ss & 0x01 != 0x00) ? onPaint : offPaint;
    canvas.drawPath(
        Path().build([
          Offset(x, y + h / 2),
          Offset(x + d, y + h / 2 - d),
          Offset(x + w - d, y + h / 2 - d),
          Offset(x + w, y + h / 2),
          Offset(x + w - d, y + h / 2 + d),
          Offset(x + d, y + h / 2 + d)
        ]),
        pt);
  }
}
