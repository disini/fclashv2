import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'connections.freezed.dart';
part 'connections.g.dart';

@freezed
class ClashConnections with _$ClashConnections {
  const factory ClashConnections({
    @JsonKey(name: 'downloadTotal') int? downloadTotal,
    @JsonKey(name: 'uploadTotal') int? uploadTotal,
    @JsonKey(name: 'connections') List<ClashConnection>? connections,
    @JsonKey(name: 'memory') int? memory,
  }) = _ClashConnections;

  factory ClashConnections.fromJson(Map<String, Object?> json) =>
      _$ClashConnectionsFromJson(json);
}

@freezed
class ClashConnection with _$ClashConnection {
  const factory ClashConnection({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'metadata') Metadata? metadata,
    @JsonKey(name: 'upload') int? upload,
    @JsonKey(name: 'download') int? download,
    @JsonKey(name: 'start') DateTime? start,
    @JsonKey(name: 'chains') List<String>? chains,
    @JsonKey(name: 'rule') String? rule,
    @JsonKey(name: 'rulePayload') String? rulePayload,
  }) = _ClashConnection;

  factory ClashConnection.fromJson(Map<String, Object?> json) =>
      _$ClashConnectionFromJson(json);
}

@freezed
class Metadata with _$Metadata {
  const factory Metadata({
    @JsonKey(name: 'network') String? network,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'sourceIP') String? sourceIP,
    @JsonKey(name: 'destinationIP') String? destinationIP,
    @JsonKey(name: 'sourcePort') String? sourcePort,
    @JsonKey(name: 'destinationPort') String? destinationPort,
    @JsonKey(name: 'inboundIP') String? inboundIP,
    @JsonKey(name: 'inboundPort') String? inboundPort,
    @JsonKey(name: 'inboundName') String? inboundName,
    @JsonKey(name: 'inboundUser') String? inboundUser,
    @JsonKey(name: 'host') String? host,
    @JsonKey(name: 'dnsMode') String? dnsMode,
    @JsonKey(name: 'uid') int? uid,
    @JsonKey(name: 'process') String? process,
    @JsonKey(name: 'processPath') String? processPath,
    @JsonKey(name: 'specialProxy') String? specialProxy,
    @JsonKey(name: 'specialRules') String? specialRules,
    @JsonKey(name: 'remoteDestination') String? remoteDestination,
    @JsonKey(name: 'sniffHost') String? sniffHost,
  }) = _Metadata;

  factory Metadata.fromJson(Map<String, Object?> json) =>
      _$MetadataFromJson(json);
}
