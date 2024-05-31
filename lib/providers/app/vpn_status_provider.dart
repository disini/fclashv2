import 'package:fclashv2/core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vpn_status_provider.g.dart';

@riverpod
class VpnStatusNotifier extends _$VpnStatusNotifier {
  bool build() => false;

  Future<void> toggle(bool status) async {
    if (status) {
      await CoreController.startVpn();
    } else {
      await CoreController.stopVpn();
    }
    state = status;
  }
}
