import "package:freezed_annotation/freezed_annotation.dart";

part 'rules.freezed.dart';
part 'rules.g.dart';

@freezed
class ClashRules with _$ClashRules {
  factory ClashRules({
    required List<Rule> rules,
  }) = _ClashRules;

  factory ClashRules.fromJson(Map<String, dynamic> json) =>
      _$ClashRulesFromJson(json);
}

@freezed
class Rule with _$Rule {
  factory Rule({
    required RuleType type,
    required String payload,
    required String proxy,
    required int size,
  }) = _Rule;

  factory Rule.fromJson(Map<String, dynamic> json) => _$RuleFromJson(json);
}

@JsonEnum(valueField: "value")
enum RuleType {
  @JsonValue("Process")
  process,
  @JsonValue('Domain')
  domain,
  @JsonValue('DomainSuffix')
  domainSuffix,
  @JsonValue('DomainKeyword')
  domainKeyword,
  @JsonValue('DomainRegex')
  domainRegex,
  @JsonValue('GeoSite')
  geosite,
  @JsonValue('IPCIDR')
  ipCidr,
  @JsonValue('IPCIDR6')
  ipCidr6,
  @JsonValue('IPSuffix')
  ipSuffix,
  @JsonValue('ASN')
  ipAsn,
  @JsonValue('GeoIP')
  geoip,
  @JsonValue('SrcGeoip')
  srcGeoip,
  @JsonValue('SrcIpAsn')
  srcIpAsn,
  @JsonValue('SrcIpCidr')
  srcIpCidr,
  @JsonValue('SrcIpSuffix')
  srcIpSuffix,
  @JsonValue('DstPort')
  dstPort,
  @JsonValue('SrcPort')
  srcPort,
  @JsonValue('InPort')
  inPort,
  @JsonValue('InType')
  inType,
  @JsonValue('InUser')
  inUser,
  @JsonValue('InName')
  inName,
  @JsonValue('ProcessPath')
  processPath,
  @JsonValue('ProcessName')
  processName,
  @JsonValue('Uid')
  uid,
  @JsonValue('Network')
  network,
  @JsonValue('DSCP')
  dscp,
  @JsonValue('RuleSet')
  ruleSet,
  @JsonValue('And')
  andOperator,
  @JsonValue('Or')
  orOperator,
  @JsonValue('Not')
  notOperator,
  @JsonValue('SubRule')
  subRule,
  @JsonValue('Match')
  match,
}
