import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'config.freezed.dart';
part 'config.g.dart';

@JsonEnum(valueField: "info")
enum ProxyMode {
  rule("rule"),
  global("global"),
  direct("direct");

  final String info;

  const ProxyMode(this.info);
}

@JsonEnum(valueField: "info")
enum TunStack {
  gVisor("gVisor"),
  system("System"),
  mixed("Mixed");

  final String info;

  const TunStack(this.info);
}

@unfreezed
class ClashConfig with _$ClashConfig {
  static String configPath = "";
  factory ClashConfig({
    @JsonKey(name: "port") int? port,
    @JsonKey(name: "socks-port") int? socksPort,
    @JsonKey(name: "redir-port") int? redirPort,
    @JsonKey(name: "tproxy-port") int? tproxyPort,
    @JsonKey(name: "mixed-port") int? mixedPort,
    @JsonKey(name: "tun") Tun? tun,
    @JsonKey(name: "tuic-server") TuicServer? tuicServer,
    @JsonKey(name: "ss-config") String? ssConfig,
    @JsonKey(name: "vmess-config") String? vmessConfig,
    @JsonKey(name: "authentication") dynamic authentication,
    @JsonKey(name: "skip-auth-prefixes") dynamic skipAuthPrefixes,
    @JsonKey(name: "lan-allowed-ips") List<String>? lanAllowedIps,
    @JsonKey(name: "lan-disallowed-ips") dynamic lanDisallowedIps,
    @JsonKey(name: "allow-lan") bool? allowLan,
    @JsonKey(name: "bind-address") String? bindAddress,
    @JsonKey(name: "inbound-tfo") bool? inboundTfo,
    @JsonKey(name: "inbound-mptcp") bool? inboundMptcp,
    @JsonKey(name: "mode") ProxyMode? mode,
    @JsonKey(name: "UnifiedDelay") bool? unifiedDelay,
    @JsonKey(name: "log-level") String? logLevel,
    @JsonKey(name: "ipv6") bool? ipv6,
    @JsonKey(name: "interface-name") String? interfaceName,
    @JsonKey(name: "geox-url") GeoxUrl? geoxUrl,
    @JsonKey(name: "geo-auto-update") bool? geoAutoUpdate,
    @JsonKey(name: "geo-update-interval") int? geoUpdateInterval,
    @JsonKey(name: "geodata-mode") bool? geodataMode,
    @JsonKey(name: "geodata-loader") String? geodataLoader,
    @JsonKey(name: "geosite-matcher") String? geositeMatcher,
    @JsonKey(name: "tcp-concurrent") bool? tcpConcurrent,
    @JsonKey(name: "find-process-mode") String? findProcessMode,
    @JsonKey(name: "sniffing") bool? sniffing,
    @JsonKey(name: "global-client-fingerprint") String? globalClientFingerprint,
    @JsonKey(name: "global-ua") String? globalUa,
  }) = _ClashConfigs;

  factory ClashConfig.fromJson(Map<String, dynamic> json) =>
      _$ClashConfigFromJson(json);

  static bool get didFileExist => File(configPath).existsSync();
}

@unfreezed
class GeoxUrl with _$GeoxUrl {
  factory GeoxUrl({
    String? geoip,
    String? mmdb,
    String? asn,
    String? geosite,
  }) = _GeoxUrl;

  factory GeoxUrl.fromJson(Map<String, dynamic> json) =>
      _$GeoxUrlFromJson(json);
}

@unfreezed
class Tun with _$Tun {
  factory Tun({
    bool? enable,
    String? device,
    TunStack? stack,
    @JsonKey(name: "dns-hijack") List<String>? dnsHijack,
    @JsonKey(name: "auto-route") bool? autoRoute,
    @JsonKey(name: "auto-detect-interface") bool? autoDetectInterface,
    @JsonKey(name: "mtu") int? mtu,
    @JsonKey(name: "gso-max-size") int? gsoMaxSize,
    @JsonKey(name: "inet4-address") List<String>? inet4Address,
    @JsonKey(name: "file-descriptor") int? fileDescriptor,
    @JsonKey(name: "table-index") int? tableIndex,
  }) = _Tun;

  factory Tun.fromJson(Map<String, dynamic> json) => _$TunFromJson(json);
}

@unfreezed
class TuicServer with _$TuicServer {
  factory TuicServer({
    bool? enable,
    String? listen,
    String? certificate,
    @JsonKey(name: "private-key") String? privateKey,
    @JsonKey(name: "mux-option") MuxOption? muxOption,
  }) = _TuicServer;

  factory TuicServer.fromJson(Map<String, dynamic> json) =>
      _$TuicServerFromJson(json);
}

@unfreezed
class MuxOption with _$MuxOption {
  factory MuxOption({
    Brutal? brutal,
  }) = _MuxOption;

  factory MuxOption.fromJson(Map<String, dynamic> json) =>
      _$MuxOptionFromJson(json);
}

@unfreezed
class Brutal with _$Brutal {
  factory Brutal({
    bool? enabled,
  }) = _Brutal;
  factory Brutal.fromJson(Map<String, dynamic> json) => _$BrutalFromJson(json);
}
