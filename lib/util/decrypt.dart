import 'package:html/dom.dart';

class Decrypt {
  static int star = 0;
  static var key;
  static handle(Document html) {
    var client = html.getElementsByTagName('meta')[4].attributes['content'];
    var removes = [
      "abbr",
      "bdi",
      "command",
      "footer",
      "keygen",
      "mark",
      "strike",
      "acronym",
      "bdo",
      "big",
      "site",
      "code",
      "dfn",
      "kbd",
      "q",
      "s",
      "samp",
      "tt",
      "u",
      "var",
      "cite",
      "details",
      "figure"
    ];
    removes.forEach((element) {
      html.getElementsByTagName(element).forEach((element) {
        element.remove();
      });
    });
    key = _base64(client).split(RegExp('[A-Z]+%'));
    var content = html.getElementById('content');
    var decodeStr = _init(content).toString();
    // LogUtil.v(decodeStr.substring(0, 200));
    return decodeStr;
  }

  static _base64(str) {
    String map =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var b = "";
    var d = "";
    for (var i = 0; i < str.length; i++) {
      if (str.substring(i, i + 1) == "=") {
        break;
      }
      var c = map.indexOf(str[i]).toRadixString(2);
      d += {1: "00000", 2: "0000", 3: "000", 4: "00", 5: "0", 6: ""}[c.length] +
          c;
    }
    var reg = RegExp('[0-1]{8}');
    var e = reg.allMatches(d).toList();
    for (var i = 0; i < e.length; i++) {
      b += String.fromCharCode(int.parse(e[i].group(0), radix: 2));
    }
    return b;
  }

  static _init(Element content) {
    for (var i = 0; i < content.children.length; i++) {
      if (content.children[i].localName == "h2") {
        star = i + 1;
      }
      if (content.children[i].localName == "div" &&
          content.children[i].attributes['class'] != "chapter") {
        break;
      }
    }
    return _load(content);
  }

  static _load(Element content) {
    var nodes = {};
    var e = key;
    var j = 0;
    for (var i = 0; i < e.length; i++) {
      if (int.parse(e[i]) < 3) {
        nodes[int.parse(e[i])] = content.children[i + star].text;
        j++;
      } else {
        nodes[int.parse(e[i]) - j] = content.children[i + star].text;
        j = j + 2;
      }
    }
    var result = "";
    for (var s = 0; s < nodes.length; s++) {
      result += nodes[s] + "\n";
    }
    return result;
  }
}
