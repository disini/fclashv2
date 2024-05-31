import 'package:dio/dio.dart';

late final Api = ClashApi.instance;

class ClashApi {
  ClashApi._();

  String get externalApiAddress => "127.0.0.1:$externalApiPort";
  int externalApiPort = 9090;
  late final Dio _dio = Dio(BaseOptions(baseUrl: httpAddress))
    ..interceptors.add(InterceptorsWrapper(
      onResponse: (resp, handler) {
        print("onResponse: ${resp.data}");
        handler.next(resp);
      },
    ));
  static late final ClashApi _instance = ClashApi._();

  Dio get req => _dio;

  String get wsAddress => "ws://$externalApiAddress";

  String get httpAddress => "http://$externalApiAddress";

  static ClashApi get instance => _instance;
}
