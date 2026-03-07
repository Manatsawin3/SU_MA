import 'package:flutter/material.dart';

/// สัญญาณไฟจราจร 3 ดวง (แดง, เหลือง, เขียว) ใช้ AnimatedOpacity เปลี่ยนแบบนุ่มนวล
class TrafficLights extends StatelessWidget {
  /// ดัชนีไฟที่สว่าง: 0 = แดง, 1 = เหลือง, 2 = เขียว
  final int activeIndex;

  const TrafficLights({super.key, required this.activeIndex});

  static const double _dimOpacity = 0.3;
  static const double _brightOpacity = 1.0;
  static const Duration _duration = Duration(milliseconds: 400);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LightCircle(
          color: Colors.red,
          opacity: activeIndex == 0 ? _brightOpacity : _dimOpacity,
          duration: _duration,
        ),
        const SizedBox(height: 16),
        _LightCircle(
          color: Colors.amber,
          opacity: activeIndex == 1 ? _brightOpacity : _dimOpacity,
          duration: _duration,
        ),
        const SizedBox(height: 16),
        _LightCircle(
          color: Colors.green,
          opacity: activeIndex == 2 ? _brightOpacity : _dimOpacity,
          duration: _duration,
        ),
      ],
    );
  }
}

class _LightCircle extends StatelessWidget {
  final Color color;
  final double opacity;
  final Duration duration;

  const _LightCircle({
    required this.color,
    required this.opacity,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: duration,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: opacity > 0.5 ? 12 : 4,
              spreadRadius: opacity > 0.5 ? 2 : 0,
            ),
          ],
        ),
      ),
    );
  }
}
