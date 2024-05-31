import 'package:fclashv2/models/clash/config.dart';
import 'package:fclashv2/providers/clash/config_provider.dart';
import 'package:fclashv2/providers/app/settings_provider.dart';
import 'package:fclashv2/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final clashConf = ref.watch(clashConfigNotifierProvider);
    final settings = ref.watch(appSettingsNotifierProvider);
    final clashConfViewsBgColor = colorScheme.primaryContainer;
    final clashConfViewBorderRadius = BorderRadius.circular(5);
    final appSettingsViewsBorderRadius = BorderRadius.circular(5);
    final appSettingsViewsBgColor = colorScheme.secondaryContainer;
    final appSettingsTiles = <(String, Widget Function())>[
      (
        "Theme Mode",
        () {
          final modes = ThemeMode.values;
          return ToggleButtons(
            onPressed: (idx) => ref
                .read(appSettingsNotifierProvider.notifier)
                .updateThemeMode(modes[idx]),
            isSelected:
                modes.map((mode) => mode == settings.themeMode).toList(),
            children: modes.map((mode) => Text(mode.name)).toList(),
          );
        }
      ),
      (
        "Theme Color",
        () {
          final themes = MyThemes.values;
          return ToggleButtons(
            onPressed: (idx) {
              ref
                  .read(appSettingsNotifierProvider.notifier)
                  .updateTheme(themes[idx]);
            },
            isSelected: themes.map((t) => t == settings.theme).toList(),
            children: themes
                .map((t) => Container(
                      padding: const EdgeInsets.all(2),
                      width: 15,
                      height: 15,
                      decoration:
                          BoxDecoration(color: t.color, shape: BoxShape.circle),
                    ))
                .toList(),
          );
        }
      ),
    ];
    final clashConfTiles = <(String, Widget Function(ClashConfig conf))>[
      (
        "Tun",
        (conf) => Switch(
              value: conf.tun?.enable ?? false,
              onChanged: (v) => ref
                  .read(clashConfigNotifierProvider.notifier)
                  .updateConfig((conf) => conf.tun?.enable = v),
            )
      ),
      (
        "TunStack",
        (conf) {
          final stacks = TunStack.values;
          return ToggleButtons(
              isSelected:
                  stacks.map((stack) => stack == conf.tun?.stack).toList(),
              children: stacks
                  .map((stack) => Text(
                        stack.info,
                      ))
                  .toList(),
              onPressed: (idx) {
                ref
                    .read(clashConfigNotifierProvider.notifier)
                    .updateConfig((conf) => conf.tun?.stack = stacks[idx]);
              });
        }
      ),
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              "app settings",
              style: textTheme.labelMedium,
            ),
          ),
          SliverList.builder(
              itemCount: appSettingsTiles.length,
              itemBuilder: (context, idx) {
                final tile = appSettingsTiles[idx];
                return Container(
                  margin: const EdgeInsets.all(3),
                  child: Material(
                      color: appSettingsViewsBgColor,
                      borderRadius: appSettingsViewsBorderRadius,
                      child: ListTile(
                        title: Text(tile.$1),
                        trailing: tile.$2(),
                      )),
                );
              }),
          SliverToBoxAdapter(
            child: Text(
              "clash config",
              style: textTheme.labelMedium,
            ),
          ),
          SliverList.builder(
              itemCount: clashConfTiles.length,
              itemBuilder: (context, idx) {
                final tile = clashConfTiles[idx];
                return Container(
                  margin: const EdgeInsets.all(3),
                  child: Material(
                    color: clashConfViewsBgColor,
                    borderRadius: clashConfViewBorderRadius,
                    child: ListTile(
                      title: Text(tile.$1),
                      trailing: tile.$2(clashConf.value!),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
