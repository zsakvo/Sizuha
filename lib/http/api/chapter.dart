import 'package:sizuha/util/decrypt.dart';

import '../dio.dart';

class ApiChapter {
  static Future<dynamic> fetch(url) async {
    return DioUtil().get(url: url, tag: 'detail', params: {}).then((res) {
      Decrypt.handle(res);
    });
  }
}
