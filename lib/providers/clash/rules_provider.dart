import 'package:fclashv2/models/clash/rules.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rules_provider.g.dart';

@riverpod
Future<ClashRules> clashRules(ClashRulesRef ref) async {
  final resp = await Api.req.get("/rules");
  return ClashRules.fromJson(resp.data);
}
