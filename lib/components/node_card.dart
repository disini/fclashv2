import 'package:fclashv2/models/clash/proxies.dart';
import 'package:flutter/material.dart';

class NodeCard extends StatelessWidget {
  const NodeCard({
    super.key,
    this.nodeName,
    this.onPressed,
    this.onDelayTest,
    this.backgroundColor,
    this.titleStyle,
    this.subTitleStyle,
    this.buttonStyle,
    this.isUdp,
    this.type = ProxyType.unknown,
    this.delayStyle,
    this.delay,
  });
  final String? nodeName;
  final VoidCallback? onPressed;
  final VoidCallback? onDelayTest;
  final Color? backgroundColor;
  final bool? isUdp;
  final ProxyType type;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final TextStyle? delayStyle;
  final String? delay;
  final ButtonStyle? buttonStyle;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: nodeName,
      showDuration: const Duration(seconds: 1),
      exitDuration: const Duration(),
      waitDuration: const Duration(seconds: 1),
      child: ElevatedButton(
        onPressed: onPressed,
        style: (buttonStyle ?? ButtonStyle()).copyWith(
            backgroundColor: WidgetStatePropertyAll(backgroundColor),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ))),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        nodeName ?? "-",
                        maxLines: 2,
                        style: titleStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                            "${type.alias}::${isUdp ?? false ? 'UDP' : '-'}",
                            maxLines: 1,
                            style: subTitleStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    child: IconButton(
                      onPressed: onDelayTest,
                      icon: Icon(Icons.speed),
                    ),
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    delay ?? "-",
                    maxLines: 1,
                    style: delayStyle,
                  ),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> executeFunction(Function fun) async =>
      await Future.sync(() => fun);
}

//class ShimmerBorderPainter extends CustomPainter {
//  final Color color;
//
//  ShimmerBorderPainter({required this.animation, required this.color})
//      : super(repaint: animation);
//
//  @override
//  void paint(Canvas canvas, Size size) {
//    final paint = Paint()
//      ..shader = _createShimmerEffect(size)
//      ..style = PaintingStyle.stroke
//      ..strokeWidth = 2;
//
//    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
//
//    canvas.drawPath(path, paint);
//  }
//
//  Shader _createShimmerEffect(Size size) {
//    final gradient = SweepGradient(
//      colors: [
//        color.withOpacity(0.0), // Transparent white
//        color, // Opaque white
//        color.withOpacity(0.0), // Transparent white
//      ],
//      stops: [
//        0.0,
//        0.5,
//        1.0,
//      ],
//      startAngle: 0,
//      endAngle: 2 * math.pi,
//      transform: GradientRotation(animation.value * 2 * math.pi),
//    );
//
//    return gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//  }
//
//  @override
//  bool shouldRepaint(covariant CustomPainter oldDelegate) {
//    return oldDelegate != this || animation.isAnimating;
//  }
//}
