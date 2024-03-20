import 'dart:ui';

import 'package:draw_text/string_ext.dart';
import 'package:flutter/material.dart';

/// 绘制坐标系
class CoordinateSystem {
  /// 绘制网格间隔
  final double step;

  /// 刻度线长度
  final double tailLineW;

  CoordinateSystem({this.step = 20, this.tailLineW = 6});

  /// 通过`Canvas`形变后可以简化同种图案、有规律变化的图形的坐标系运算，从而快速实现绘制
  ///
  /// 如果是相同或者对称的对象，可以通过缩放进行对称变化。
  /// 沿x轴镜像，就相当于canvas.scale(1, -1)；
  /// 沿y轴镜像，就相当于canvas.scale(-1, 1)；
  /// 沿原点镜像，就相当于canvas.scale(-1, -1)；
  draw(Canvas canvas, Size size) {
    canvas.save();
    // 画布起点移动屏幕中心
    canvas.translate(size.width / 2, size.height / 2);

    _botRightGridding(canvas, size);

    canvas.save();
    canvas.scale(1, -1);
    _botRightGridding(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, 1);
    _botRightGridding(canvas, size);
    canvas.restore();

    canvas.save();
    canvas.scale(-1, -1);
    _botRightGridding(canvas, size);
    canvas.restore();

    _drawCoorLine(canvas, size);
    _drawCoorText(canvas, size);

    canvas.restore();
  }

  _botRightGridding(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..color = const Color.fromARGB(255, 231, 216, 216);

    // 保存当前画布状态
    canvas.save();
    for (var i = 0; i < size.width / step / 2; i++) {
      canvas.drawLine(
        Offset.zero,
        Offset(0, size.height / 2),
        paint,
      );
      canvas.translate(step, 0);
    }
    // 恢复到上次保存前的状态
    canvas.restore();

    // 保存当前画布状态
    canvas.save();
    for (var i = 0; i < size.height / step / 2; i++) {
      canvas.drawLine(
        Offset.zero,
        Offset(size.width / 2, 0),
        paint,
      );
      canvas.translate(0, step);
    }
    // 恢复到上次保存前的状态
    canvas.restore();
  }

  /// 坐标轴数值
  _drawCoorText(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    '0'.draw(canvas, Offset(-10, tailLineW), alignment: Alignment.bottomCenter);

    for (var i = 0; i < size.width / 2 / step; i++) {
      if (i.isEven && i != 0) {
        final dx = step * i;
        dx.toString().draw(canvas, Offset(dx, tailLineW),
            alignment: Alignment.bottomCenter);
        canvas.drawLine(Offset(dx, 0), Offset(dx, 5), paint);

        (-dx).toString().draw(canvas, Offset(-dx, tailLineW),
            alignment: Alignment.bottomCenter);
        canvas.drawLine(Offset(-dx, 0), Offset(-dx, 5), paint);
      }
    }

    for (var i = 0; i < size.height / 2 / step; i++) {
      if (i.isEven && i != 0) {
        final dy = step * i;

        dy.toString().draw(canvas, Offset(-tailLineW, dy),
            alignment: Alignment.centerLeft);
        canvas.drawLine(Offset(0, dy), Offset(-5, dy), paint);

        (-dy).toString().draw(canvas, Offset(-tailLineW, -dy),
            alignment: Alignment.centerLeft);
        canvas.drawLine(Offset(0, -dy), Offset(-5, -dy), paint);
      }
    }
  }

  /// 坐标轴 x，y 线
  _drawCoorLine(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.blue
      ..style = PaintingStyle.stroke;

    // x
    canvas.drawLine(Offset(-size.width, 0), Offset(size.width, 0), paint);
    canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(size.width / 2 - 10, -8),
          Offset(size.width / 2, 0),
          Offset(size.width / 2 - 10, 8),
        ],
        paint);
    // y
    canvas.drawLine(Offset(0, -size.height), Offset(0, size.height), paint);
    canvas.drawPoints(
        PointMode.polygon,
        [
          Offset(-8, size.height / 2 - 10),
          Offset(0, size.height / 2),
          Offset(8, size.height / 2 - 10),
        ],
        paint);
  }

  // void drawGridLine(Canvas canvas, Size size) {
  //   final paint = Paint()
  //     ..style = PaintingStyle.stroke
  //     ..strokeWidth = 1
  //     ..color = const Color.fromARGB(255, 236, 227, 227);
  //   final Path path = Path();

  //   // 网格先必须从中心往外开始绘制，否则左边系线 无法对齐
  //   // 或者使用轴对称方式渲染镜像

  //   canvas.translate(size.width / 2, size.height / 2);

  //   // y
  //   for (int i = 0; i < size.width / step; i++) {
  //     // ←
  //     path.moveTo(step * i, 0);
  //     path.relativeLineTo(0, size.height);
  //     // path.moveTo(-step * i, 0);
  //     // path.relativeLineTo(0, -size.height);
  //     // // →
  //     // path.moveTo(step * i, 0);
  //     // path.relativeLineTo(0, size.height);
  //     // path.moveTo(step * i, 0);
  //     // path.relativeLineTo(0, -size.height);
  //   }

  //   // x
  //   for (int i = 0; i < size.height / 2 / step; i++) {
  //     // ↑
  //     path.moveTo(0, step * i);
  //     path.relativeLineTo(size.width, 0);
  //     // path.moveTo(0, -step * i);
  //     // path.relativeLineTo(size.width, 0);
  //     // // ↓
  //     // path.moveTo(0, step * i);
  //     // path.relativeLineTo(size.width, 0);
  //     // path.moveTo(0, step * i);
  //     // path.relativeLineTo(-size.width, 0);
  //   }
  //   canvas.drawPath(path, paint);

  //   canvas.save();
  //   canvas.scale(1, -1);
  //   canvas.drawPath(path, paint);
  //   canvas.restore();

  //   canvas.save();
  //   canvas.scale(-1, -1);
  //   canvas.drawPath(path, paint);
  //   canvas.restore();

  //   canvas.save();
  //   canvas.scale(-1, 1);
  //   canvas.drawPath(path, paint);
  //   canvas.restore();

  //   drawCoordinate(canvas, size);
  // }
}
