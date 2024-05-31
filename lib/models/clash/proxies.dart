import 'package:freezed_annotation/freezed_annotation.dart';

part 'proxies.freezed.dart';
part 'proxies.g.dart';

const int delayInfinity = 2999;

enum DelayStatus {
  testing,
  failed,
  todo,
  ok,
}

class ProxyDelay {
  final DelayStatus status;
  final int? delay;
  final String? error;
  ProxyDelay({required this.status, this.delay, this.error});
}

@JsonEnum(valueField: "field")
enum ProxyType {
  selector("Selector", "selector"),
  vless("Vless", "vless"),
  ss("Shadowsocks", "ss"),
  vmess("Vmess", "vmess"),
  ssR("ShadowsocksR", "ssR"),
  reject("Reject", "reject"),
  pass("Pass", "pass"),
  direct("Direct", "direct"),
  rejectDrop("RejectDrop", "rejectDrop"),
  compatible("Compatible", "compatible"),
  urlTest("URLTest", "URLTest"),
  trojan("Trojan", "trojan"),
  hysteria("Hysteria2", "hysteria2"),
  unknown("unknown", "unknown");

  final String field;
  final String alias;

  const ProxyType(this.field, this.alias);

  bool isGroup() => this == selector || this == urlTest;
}

@Freezed(copyWith: true, fromJson: true, toJson: true)
class ClashProxies with _$ClashProxies {
  const factory ClashProxies({required Map<String, ClashProxyItem> proxies}) =
      _ClashProxies;

  factory ClashProxies.fromJson(Map<String, Object?> json) =>
      _$ClashProxiesFromJson(json);
}

@freezed
class ClashProxyItem with _$ClashProxyItem {
  const factory ClashProxyItem(
      {required bool alive,
      required ProxyType type,
      List<ClashProxyHistoryItem>? history,
      String? id,
      String? name,
      required bool udp,
      required bool xudp,
      String? now,
      bool? hidden,
      List<String>? all}) = _ClashProxyItem;

  factory ClashProxyItem.fromJson(Map<String, Object?> json) =>
      _$ClashProxyItemFromJson(json);
}

@freezed
class ClashProxyHistoryItem with _$ClashProxyHistoryItem {
  const factory ClashProxyHistoryItem({required DateTime time, int? delay}) =
      _ClashProxyHistoryItem;

  factory ClashProxyHistoryItem.fromJson(Map<String, Object?> json) =>
      _$$ClashProxyHistoryItemImplFromJson(json);
}
