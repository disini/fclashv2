import 'dart:async';

import 'package:fclashv2/models/clash/proxies.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'proxies_provider.g.dart';

@riverpod
class ProxiesNotifier extends _$ProxiesNotifier {
  @override
  Future<ClashProxies> build() async {
    final resp = await Api.req.get("/proxies");
    return ClashProxies.fromJson(resp.data);
  }

  Future<void> changeNodeForSelector(String selector, String target) async {
    await Api.req.put("/proxies/$selector", data: "{\"name\": \"$target\"}");
    ref.invalidateSelf();
  }
}

@riverpod
class DelayStatusNotifier extends _$DelayStatusNotifier {
  @override
  Map<String, ProxyDelay> build() {
    final resp = ref.read(proxiesNotifierProvider);
    return resp.when(
      data: (data) => {
        for (var node in data.proxies.keys)
          node: ProxyDelay(status: DelayStatus.todo)
      },
      error: (Object error, StackTrace stackTrace) => {},
      loading: () => {},
    );
  }

  Future<void> updateSingleNodeDelay(String target) async {
    // 开始时通知状态正在测试中
    state = {...state, target: ProxyDelay(status: DelayStatus.testing)};

    late final Map<String, dynamic> obj;
    try {
      obj = (await Api.req.get("/proxies/$target/delay", queryParameters: {
        "url": "http://www.gstatic.com/generate_204",
        "timeout": 1000,
      }))
          .data;
      // 根据获取的结果更新状态
      if (obj.containsKey("message")) {
        throw Exception(obj["message"]);
      }
      final newStateValue =
          ProxyDelay(status: DelayStatus.ok, delay: obj["delay"]);
      // 更新最终的状态
      state = {...state, target: newStateValue};
    } catch (e) {
      // 发生异常时通知状态失败
      state = {
        ...state,
        target: ProxyDelay(status: DelayStatus.failed, error: e.toString())
      };
    }
  }

  Future<void> updateGroupDelay(String target, List<String>? subNodes) async {
    // 开始时通知状态正在测试中
    state = {
      ...state,
      ...{
        for (var node in subNodes ?? [])
          node: ProxyDelay(status: DelayStatus.testing)
      }
    };

    late final Map<String, dynamic> obj;
    try {
      obj = (await Api.req.get("/group/$target/delay", queryParameters: {
        "url": "http://www.gstatic.com/generate_204",
        "timeout": 1000,
      }))
          .data;
      if (obj.containsKey("message")) {
        throw Exception(obj["message"]);
      }
      // 根据获取的结果更新状态
      final newStateValue = {
        for (var node in subNodes ?? [])
          node: obj.containsKey(node)
              ? ProxyDelay(status: DelayStatus.ok, delay: obj[node])
              : ProxyDelay(status: DelayStatus.failed, error: "failed")
      };
      // 更新最终的状态
      state = {...state, ...newStateValue};
    } catch (e) {
      // 发生异常时通知状态失败
      state = {
        ...state,
        ...{
          for (var node in subNodes ?? [])
            node: ProxyDelay(status: DelayStatus.failed)
        }
      };
    }
  }
}

@riverpod
List<ClashProxyItem> proxyGroups(ProxyGroupsRef ref) {
  final proxies = ref.watch(proxiesNotifierProvider);
  return proxies.when(
    data: (d) => d.proxies.values
        .where((node) => node.type.isGroup() && node.name != "GLOBAL")
        .toList(),
    loading: () => [],
    error: (_, __) => [],
  );
}
