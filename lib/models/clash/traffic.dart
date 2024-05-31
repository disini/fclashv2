import 'package:freezed_annotation/freezed_annotation.dart';

part 'traffic.freezed.dart';
part 'traffic.g.dart';

@freezed
class ClashTraffic with _$ClashTraffic {
  factory ClashTraffic({required int up, required int down}) = _ClashTraffic;

  factory ClashTraffic.fromJson(Map<String, dynamic> json) =>
      _$ClashTrafficFromJson(json);
}
