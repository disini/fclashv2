import 'package:fclashv2/models/clash/config.dart';
import 'package:fclashv2/providers/clash/config_provider.dart';
import 'package:fclashv2/providers/clash/proxies_provider.dart';
import 'package:fclashv2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProxiesPage extends ConsumerStatefulWidget {
  const ProxiesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProxiesPageState();
}

class _ProxiesPageState extends ConsumerState<ProxiesPage>
    with SingleTickerProviderStateMixin {
  final _proxyModes = {for (var mode in ProxyMode.values) mode.name: mode};
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final groups = ref.watch(proxyGroupsProvider);
    final proxies = ref.watch(proxiesNotifierProvider);
    final delays = ref.watch(delayStatusNotifierProvider);
    final proxyMode = ref.watch(
            clashConfigNotifierProvider.select((conf) => conf.value?.mode)) ??
        ProxyMode.rule;
    return proxies.when(
      data: (proxies) {
        if (_tabController == null) {
          _tabController = TabController(length: groups.length, vsync: this);
        }
        return Scaffold(
          appBar: AppBar(
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => _proxyModes.values
                    .map(
                      (mode) => CheckedPopupMenuItem(
                        checked: mode == proxyMode,
                        child: Text(mode.name),
                        onTap: () => ref
                            .read(clashConfigNotifierProvider.notifier)
                            .updateProxyMode(mode),
                      ),
                    )
                    .toList(),
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: groups.map((group) => Tab(text: group.name ?? "")).toList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            backgroundColor: colorScheme.secondaryContainer,
            child: SizedBox(
                width: 40, height: 40, child: Icon(Icons.flash_on_rounded)),
            onPressed: () {
              final group = groups[_tabController!.index];
              ref
                  .read(delayStatusNotifierProvider.notifier)
                  .updateGroupDelay(group.name ?? "", group.all ?? []);
            },
          ),
          body: Padding(
            padding: const EdgeInsets.all(5),
            child: TabBarView(
              controller: _tabController,
              children: groups.map<Widget>((group) {
                final subNodes = [
                  for (var subNode in group.all ?? <String>[])
                    proxies.proxies[subNode]!
                ];
                final now = group.now ?? "";
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisExtent: 80,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: subNodes.length,
                    itemBuilder: (context, idx) {
                      final node = subNodes[idx];
                      final delay = delays[node.name];
                      return Material(
                        color: now == node.name
                            ? colorScheme.tertiaryContainer
                            : colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: colorScheme.tertiaryContainer),
                          ),
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            titleTextStyle: textTheme.labelMedium,
                            subtitleTextStyle: textTheme.labelMedium,
                            title: Text(node.name ?? ""),
                            subtitle: Text(node.type.alias),
                            trailing: delay?.delay != null
                                ? Text(
                                    delay!.delay.toString(),
                                    style: textTheme.labelMedium?.copyWith(
                                      color: Utils.parseDelay(delay.delay),
                                    ),
                                  )
                                : null,
                            onTap: () => ref
                                .read(proxiesNotifierProvider.notifier)
                                .changeNodeForSelector(
                                    group.name ?? "", node.name ?? ""),
                          ),
                        ),
                      );
                    });
              }).toList(),
            ),
          ),
        );
      },
      error: (e, stack) => Center(
        child: Text("$e $stack"),
      ),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
