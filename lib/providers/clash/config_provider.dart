import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:fclashv2/models/clash/config.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:settings_yaml/settings_yaml.dart';

part 'config_provider.g.dart';

@riverpod
class ClashConfigNotifier extends _$ClashConfigNotifier {
  @override
  Future<ClashConfig> build() async {
    final resp = await Api.req.get("/configs");
    return ClashConfig.fromJson(resp.data);
  }

  Future<void> updateConfig(Function(ClashConfig conf) updateCallback,
      [bool refreshCache = false]) async {
    final prev = await future;
    final conf = prev.copyWith();
    updateCallback(conf);
    await Api.req.patch("/configs", data: jsonEncode(conf.toJson()));
    state = AsyncValue.data(conf);
    _save();
  }

  Future<void> updateProxyMode(ProxyMode mode) async {
    updateConfig((conf) => conf.mode = mode);
  }

  Future<void> updateTunSettings(Tun tun) async {
    updateConfig((conf) => conf.tun = tun);
  }

  Future<void> _save() async {
    await saveToStorage();
  }

  Future<void> saveToStorage() async {
    final yaml = SettingsYaml.load(pathToSettings: ClashConfig.configPath);
    final local = yaml.valueMap;
    final prev = await future;
    final cache = prev.toJson();
    for (var entry in cache.entries) {
      final k = entry.key;
      final v = entry.value;
      if (v == null) {
        continue;
      }
      if (v is Map<String, Object?> &&
          !DeepCollectionEquality().equals(v, local[k])) {
        yaml[k] = v;
        continue;
      }
      if (local[k] != v) {
        yaml[k] = v;
      }
    }
  }
}
