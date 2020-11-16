import 'package:html/dom.dart';

import '../dio.dart';

class ApiIndex {
  static Future<dynamic> fetch() async {
    List list = [];
    List titles = [];
    return DioUtil()
        .get(url: '/index.php', tag: 'index', params: {}).then((res) {
      Element body = res.body;
      Element right = body.querySelector('dl#right');
      List<Element> titleList = right.getElementsByClassName('title99');
      titleList = titleList.getRange(0, 4).toList();
      titleList.removeAt(1);
      titleList.forEach((e) {
        var title = e.innerHtml.replaceAll(new RegExp("(:.*)"), '');
        titles.add(title);
      });
      List<Element> boxList = right.getElementsByClassName('list_box');
      boxList.removeAt(1);
      int i = 0;
      boxList.forEach((e) {
        List books = [];
        List<Element> lis =
            e.getElementsByTagName('ul')[0].getElementsByTagName('li');
        lis.forEach((li) {
          var url = li.getElementsByTagName('a')[0].attributes['href'];
          var note = li.getElementsByClassName('note')[0];
          var cover = li
              .getElementsByTagName('a')[0]
              .getElementsByTagName('img')[0]
              .attributes['src'];
          var name = note.getElementsByTagName('h4')[0].innerHtml;
          var author = note
              .getElementsByTagName('span')[0]
              .innerHtml
              .replaceAll('作者:', '')
              .replaceAll(new RegExp("\\(.*?\\)"), '');
          var book = {
            'cover': cover.contains('http') ? cover : 'https:' + cover,
            'name': name,
            'author': author,
            'url': url
          };
          books.add(book);
        });
        list.add({'title': titles[i], 'books': books});
        i++;
      });
      return list;
    });
  }
}
