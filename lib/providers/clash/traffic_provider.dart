import 'dart:convert';

import 'package:fclashv2/models/clash/traffic.dart';
import 'package:fclashv2/utils/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

part 'traffic_provider.g.dart';

@riverpod
Stream<ClashTraffic> clashTraffic(ClashTrafficRef ref) async* {
  final channel =
      WebSocketChannel.connect(Uri.parse("${Api.wsAddress}/traffic"));
  await for (var rowJson in channel.stream) {
    yield ClashTraffic.fromJson(jsonDecode(rowJson));
  }
}
