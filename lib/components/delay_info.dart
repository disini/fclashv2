import 'package:fclashv2/models/clash/proxies.dart';
import 'package:fclashv2/utils/utils.dart';
import 'package:flutter/material.dart';

class DelayInfo extends StatelessWidget {
  const DelayInfo({super.key, required this.delay, this.onTap, this.radius});
  final ProxyDelay delay;
  final double? radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context)
        .textTheme
        .labelMedium
        ?.copyWith(color: Theme.of(context).colorScheme.onPrimary);
    late final Widget child;
    switch (delay.status) {
      case DelayStatus.todo:
        child = Icon(
          Icons.speed_rounded,
          color: Theme.of(context).colorScheme.onPrimary,
        );
        break;
      case DelayStatus.failed:
        child = Text(
          "Error",
          style: style?.copyWith(color: Colors.red),
        );
        break;
      case DelayStatus.testing:
        child = Text(
          "testing",
          style: style,
        );
      case DelayStatus.ok:
        child = Text(
          delay.delay!.toString(),
          style: style?.copyWith(color: Utils.parseDelay(delay.delay!)),
        );
        break;
    }
    return Material(
      borderRadius: BorderRadius.circular(radius ?? 0),
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: InkWell(
        onTap: onTap,
        radius: radius,
        child: Align(alignment: Alignment.center, child: child),
      ),
    );
  }
}
