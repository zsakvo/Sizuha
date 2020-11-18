import 'package:flustars/flustars.dart';
import 'package:html/dom.dart';

import '../dio.dart';

class ApiSearch {
  static Future<dynamic> fetch(String keyword, int page) async {
    List books = [];
    return DioUtil().get(
        url: '/book/search.php',
        tag: 'index',
        params: {'keyword': keyword, 'page': page}).then((res) {
      Element body = res.body;
      Element boxList = body.getElementsByClassName('list_box')[0];
      boxList.getElementsByTagName('li').forEach((element) {
        try {
          var name = element.querySelector('h2 > a').text;
          var author =
              element.getElementsByTagName('h4')[0].querySelector('a').text;
          var cover = element.getElementsByTagName('img')[0].attributes['src'];
          var url = element.querySelector('h2 > a').attributes['href'];
          var book = {
            'cover': cover.contains('http') ? cover : 'https:' + cover,
            'name': name,
            'author': author,
            'url': url
          };
          books.add(book);
        } catch (err) {
          LogUtil.v(err);
        }
      });
      return books;
    });
  }
}
