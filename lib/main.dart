import 'dart:ui';

import 'package:draw_text/coordinate_system.dart';
import 'package:draw_text/string_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  SystemChrome.setPreferredOrientations(// 使设备横屏显示
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []); // 全屏显示
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: CustomPaint(
          painter: TextPainter(),
        ),
      ),
    );
  }
}

class TextPainter extends CustomPainter {
  final coor = CoordinateSystem();

  final style = const TextStyle(
    fontSize: 18,
    color: Color.fromARGB(255, 237, 237, 241),
  );

  /// 文字相对点的位置
  final alignments = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight
  ];

  @override
  void paint(Canvas canvas, Size size) {
    coor.draw(canvas, size);

    canvas.translate(size.width / 2, size.height / 2);

    final List<Offset> points = [];

    for (var alignment in alignments) {
      final offset = Offset(alignment.x, alignment.y) * 160;
      points.add(offset);
      '$alignment \n $offset'.draw(canvas, offset,
          alignment: alignment, style: style, isDebugColor: true);
    }

    canvas.drawPoints(
      PointMode.points,
      points,
      Paint()
        ..style = PaintingStyle.fill
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..color = const Color.fromARGB(255, 27, 27, 22),
    );
  }

  @override
  bool shouldRepaint(TextPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TextPainter oldDelegate) => false;
}
