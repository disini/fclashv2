//import 'package:fclashv2/models/clash/traffic.dart';
import 'package:fclashv2/pages/connections_page.dart';
//import 'package:fclashv2/pages/logs_page.dart';
import 'package:fclashv2/pages/proxies_page.dart';
import 'package:fclashv2/pages/rules_page.dart';
import 'package:fclashv2/pages/settings_page.dart';
import 'package:fclashv2/providers/app/settings_provider.dart';
import 'package:fclashv2/providers/app/vpn_status_provider.dart';
//import 'package:fclashv2/providers/clash/traffic_provider.dart';
//import 'package:fclashv2/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootPage extends ConsumerStatefulWidget {
  const RootPage({super.key});

  @override
  ConsumerState<RootPage> createState() => _RootPageState();
}

class _RootPageState extends ConsumerState<RootPage> {
  int _selectedPageIdx = 0;
  late final List<(IconData icon, String label, Widget page)> _phoneViewPages =
      [
    (Icons.center_focus_strong, "Proxies", ProxiesPage()),
    (Icons.file_present_rounded, "logs", Placeholder()),
    (Icons.link_rounded, "connections", connectionsPage()),
    (Icons.router_rounded, "rules", RulesPage()),
  ];
  late final List<(IconData icon, String label, Widget page)> _tabletViewPages =
      [
    (Icons.center_focus_strong, "Proxies", ProxiesPage()),
    (Icons.file_present_rounded, "logs", Placeholder()),
    (Icons.link_rounded, "connections", connectionsPage()),
    (Icons.router_rounded, "rules", RulesPage()),
    (Icons.settings, "settings", SettingsPage()),
  ];
  double ratio = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = View.of(context).display.size.width;
    final height = View.of(context).display.size.height;
    ratio = width / height;
    final vpnStatus = ref.watch(vpnStatusNotifierProvider);
    final themeMode = ref.watch(
        appSettingsNotifierProvider.select((settings) => settings.themeMode));
    //final traffic =
    //    ref.watch(clashTrafficProvider).value ?? ClashTraffic(up: 0, down: 0);
    if (ratio <= 1 && _selectedPageIdx == 4) _selectedPageIdx = 3;
    return ratio > 1
        ? _buildTabletView()
        : _buildPhoneView(themeMode, vpnStatus);
  }

  Scaffold _buildPhoneView(ThemeMode themeMode, bool vpnStatus) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (idx) => setState(() {
          _selectedPageIdx = idx;
        }),
        selectedIndex: _selectedPageIdx,
        destinations: _phoneViewPages
            .map(
              (v) => NavigationDestination(
                icon: Icon(v.$1),
                label: v.$2,
              ),
            )
            .toList(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.menu_rounded),
          onPressed: Scaffold.of(context).openDrawer,
        );
      }),
      drawer: Drawer(
        width: 300,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(
                    "assets/Meta.png",
                    fit: BoxFit.cover,
                  ),
                ),
                themeMode == ThemeMode.system
                    ? IconButton(
                        icon: Icon(Icons.auto_mode_rounded),
                        onPressed: () => ref
                            .read(appSettingsNotifierProvider.notifier)
                            .updateThemeMode(ThemeMode.light),
                      )
                    : themeMode == ThemeMode.light
                        ? IconButton(
                            icon: Icon(Icons.light_mode_rounded),
                            onPressed: () => ref
                                .read(appSettingsNotifierProvider.notifier)
                                .updateThemeMode(ThemeMode.dark),
                          )
                        : IconButton(
                            icon: Icon(Icons.dark_mode_rounded),
                            onPressed: () => ref
                                .read(appSettingsNotifierProvider.notifier)
                                .updateThemeMode(ThemeMode.system),
                          )
              ],
            )),
            ListTile(
              leading: Icon(Icons.rocket_launch_rounded),
              title: Text("Vpn"),
              trailing: Switch(
                value: vpnStatus,
                onChanged: ref.read(vpnStatusNotifierProvider.notifier).toggle,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings_rounded),
              title: Text("Settings"),
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
          ],
        ),
      ),
      body: _phoneViewPages[_selectedPageIdx].$3,
    );
  }

  Row _buildTabletView() {
    return Row(
      children: [
        NavigationRail(
          minExtendedWidth: 170,
          selectedIndex: _selectedPageIdx,
          onDestinationSelected: (idx) => setState(() {
            _selectedPageIdx = idx;
          }),
          extended: true,
          //trailing: Align(
          //  alignment: Alignment.bottomCenter,
          //  child: Text.rich(
          //    TextSpan(children: [
          //      TextSpan(
          //          text:
          //              "up:   ${Utils.parseByte(traffic.up.toDouble(), suffix: "/s")}\n"),
          //      TextSpan(
          //          text:
          //              "down: ${Utils.parseByte(traffic.down.toDouble(), suffix: "/s")}")
          //    ]),
          //  ),
          //),
          destinations: _tabletViewPages
              .map(
                (v) => NavigationRailDestination(
                  icon: Icon(v.$1),
                  label: Text(v.$2),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: ratio > 1
              ? _tabletViewPages[_selectedPageIdx].$3
              : _phoneViewPages[_selectedPageIdx].$3,
        ),
      ],
    );
  }
}
