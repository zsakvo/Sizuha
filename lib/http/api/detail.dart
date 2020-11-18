import 'package:flustars/flustars.dart';
import 'package:html/dom.dart';

import '../dio.dart';

class ApiDetail {
  static Future<dynamic> fetch(url) async {
    List chapters = [];
    return DioUtil().get(url: url, tag: 'detail', params: {}).then((res) {
      Element body = res.body;
      Element bookInfo = body.querySelector('div#book_info');
      String name = bookInfo.getElementsByTagName('h2')[0].innerHtml;
      String cover = bookInfo.getElementsByTagName('img')[0].attributes['src'];
      String author =
          bookInfo.getElementsByTagName('h4')[0].text.replaceAll('作者:', '');
      String intro = bookInfo
          .getElementsByClassName('intro')[0]
          .getElementsByTagName('p')
          .map((e) => e.text)
          .join('\n\n');
      List<String> tags = bookInfo
          .getElementsByTagName('h4')[1]
          .getElementsByTagName('a')
          .map((e) => e.text)
          .toList();
      if (!cover.contains('http')) {
        if (cover.startsWith('//')) {
          cover = 'https:' + cover;
        } else {
          cover = 'https://book.99csw.com/' + cover;
        }
      }
      Element dir = body.querySelector('#dir');
      List children = dir.children;
      String prefix = '';
      children.forEach((element) {
        try {
          var name = element.text;
          var url = element.getElementsByTagName('a')[0].attributes['href'];
          chapters.add({
            'name': prefix.length == 0 ? name : prefix + ' ' + name,
            'url': url
          });
        } catch (err) {
          prefix = element.text.toString().replaceAll('&', '—');
          LogUtil.v(prefix);
        }
      });
      return {
        'name': name,
        'cover': cover,
        'author': author,
        'intro': intro,
        'tags': tags,
        'chapters': chapters
      };
    });
  }
}
