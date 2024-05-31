import 'package:fclashv2/providers/clash/rules_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(clashRulesProvider);
    return Scaffold(
      body: rules.when(
          data: (r) {
            return ListView.separated(
                itemBuilder: (context, idx) {
                  final rule = r.rules[idx];
                  return ListTile(
                    title: Text(rule.payload),
                    subtitle: Text(rule.proxy),
                    trailing: Text(rule.type.name),
                  );
                },
                separatorBuilder: (_, __) => Divider(),
                itemCount: r.rules.length);
          },
          error: (e, stack) => Center(
                child: Text("$e $stack"),
              ),
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
