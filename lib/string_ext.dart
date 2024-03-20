import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 文字绘制
extension StringCanvasExt on String {
  /// 文本绘制
  ///
  /// ```
  /// [offset]: 文字对齐点
  /// [alignment]: 文字相对 点[offset] 对齐的方式， 默认居中（文字中心与offset重叠）
  ///              eg: Alignment.bottomCenter 位于点offset中下方
  /// [maxLength]: 文字最大宽度
  /// [isDebugColor]: 是否显示背景色块
  /// ```
  draw(
    Canvas canvas,
    Offset offset, {
    TextStyle style = const TextStyle(fontSize: 12, color: Colors.black),
    Alignment alignment = Alignment.center,
    double? maxWidth,
    bool isDebugColor = false,
  }) {
    final text = TextPainter(
      text: TextSpan(
        text: this,
        style: style,
      ),
      // strutStyle: const StrutStyle(forceStrutHeight: true),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    text.layout(maxWidth: maxWidth ?? double.infinity);
    final textSize = text.size;

    // 对文字本身做偏移
    final alignOffset = Offset(
            textSize.width / 2 * alignment.x, textSize.height / 2 * alignment.y)
        .translate(-textSize.width / 2, -textSize.height / 2);
    // 下面对位置偏移的操作，更容易理解
    // final alignOffset = Offset.zero
    //     .translate(-textSize.width / 2, -textSize.height / 2)
    //     .translate(textSize.width / 2 * alignment.x,
    //         textSize.height / 2 * alignment.y);

    // 绘制色块，方便调试
    if (!kReleaseMode && isDebugColor) {
      canvas.drawRect(
        (alignOffset + offset) & textSize,
        Paint()
          ..style = PaintingStyle.fill
          ..color = Colors.red.withOpacity(0.8),
      );
    }

    text.paint(canvas, alignOffset + offset);
  }
}
