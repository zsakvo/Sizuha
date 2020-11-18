import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizuha/http/api/chapter.dart';
import 'package:sizuha/http/api/detail.dart';
import 'package:sizuha/util/epub.dart';
import 'package:sizuha/util/render.dart';

class BookDetailPage extends StatefulWidget {
  final Map arguments;
  BookDetailPage({Key key, this.arguments});
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetailPage> {
  Future _future;
  bool _isDownloading = false;
  String _downloadHint = '正在读取数据……';

  @override
  void initState() {
    super.initState();
    _future = ApiDetail.fetch(widget.arguments['url']);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            brightness: Brightness.light,
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            leading: InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
              },
            )),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(fontSize: 13, color: HexColor('#757575')),
                  ),
                );
              } else {
                var data = snapshot.data;
                return Stack(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: data['cover'],
                                width: 96,
                                height: 128,
                              ),
                              Container(
                                height: 128,
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['name'],
                                          style: TextStyle(
                                              color: HexColor('#222222'),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '${data['author']}  /  ${data['tags'].last}',
                                          style: TextStyle(
                                              color: HexColor('#8c8c8c'),
                                              fontSize: 14,
                                              height: 1.6),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          '共 ${data['chapters'].length} 章',
                                          style: TextStyle(
                                              color: HexColor('#8c8c8c'),
                                              fontSize: 14,
                                              height: 1.6),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 14),
                          child: Divider(height: 12, thickness: 0.5),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '简介',
                                style: TextStyle(
                                    color: HexColor('#222222'), fontSize: 15),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                data['intro'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: ((ScreenUtil.getScreenH(context) -
                                            ScreenUtil.getStatusBarH(context) -
                                            400) /
                                        15 /
                                        1.3)
                                    .floor(),
                                style: TextStyle(
                                    color: HexColor('8c8c8c'), fontSize: 14),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        height: 38,
                        width: ScreenUtil.getScreenW(context) - 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: _isDownloading
                                    ? 0
                                    : (ScreenUtil.getInstance().screenWidth -
                                            80) *
                                        0.45,
                                height: 38,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: HexColor('#8c8c8c')
                                            .withOpacity(0.1),
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Text(
                                    "TXT",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: HexColor('#222222')),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    _fetchTXT(data);
                                  },
                                )),
                            Container(
                                width: _isDownloading
                                    ? (ScreenUtil.getInstance().screenWidth -
                                        80)
                                    : 0,
                                height: 38,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: HexColor('#8c8c8c')
                                            .withOpacity(0.1),
                                        width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor
                                      .withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Text(
                                    _downloadHint,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: HexColor('#2196f3')),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    setState(() {
                                      _isDownloading = false;
                                    });
                                  },
                                )),
                            Container(
                                width: _isDownloading
                                    ? 0
                                    : (ScreenUtil.getInstance().screenWidth -
                                            80) *
                                        0.45,
                                height: 38,
                                decoration: BoxDecoration(
                                    color: HexColor('#ffffff'),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50))),
                                child: FlatButton(
                                  color: HexColor('#2196f3'),
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: Text(
                                    "EPUB",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: HexColor('#ffffff')),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    _fetchEPUB(data);
                                  },
                                )),
                          ],
                        ),
                      ))
                ]);
              }
            } else {
              return RenderUtil.renderPlaceholder(placeHolder: '正在获取书籍……');
            }
          },
        ));
  }

  _permissionRequest() async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Easy Permission Validator',
    );
    var result = await permissionValidator.storage();
    if (result) {
      // Do something;
    }
  }

  _fetchTXT(data) async {
    _permissionRequest();
    setState(() {
      _isDownloading = true;
    });
    List chapters = [];
    List tmp = List.from(data['chapters']);
    for (int i = 0; i < tmp.length; i++) {
      var t = tmp[i];
      t['index'] = i.toString();
      chapters.add(t);
    }
    int perChapter = (chapters.length / 5).floor();
    List chapterList = [];
    for (int i = 0; i < chapters.length; i += perChapter) {
      chapterList.add(chapters
          .getRange(
              i,
              i + perChapter <= chapters.length - 1
                  ? i + perChapter
                  : chapters.length)
          .toList());
    }
    int t = 0;
    LogUtil.v(chapterList);
    List content = List(tmp.length);
    chapterList.forEach((list) {
      Future.forEach(list, (item) async {
        var url = item['url'].toString();
        var name = item['name'].toString();
        var index = item['index'];
        var res = await ApiChapter.fetch(url);
        var c = (name + '\n\n' + res + "\n\n\n");
        content[int.parse(index)] = c;
        t++;
        setState(() {
          _downloadHint = '正在下载 $t / ${tmp.length}';
        });
        if (t >= tmp.length) {
          setState(() {
            _downloadHint = '正在写出数据……';
          });
          String dir;
          File file;
          if (Platform.isAndroid) {
            dir = await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_DOCUMENTS);
            LogUtil.v(dir);
            file = new File(
                '$dir/${data['name'].trim()}-${data['author'].trim()}.txt');
          } else if (Platform.isMacOS) {
            dir = (await getDownloadsDirectory()).path;
            file = new File(
                '$dir/${data['name'].trim()}-${data['author'].trim()}.txt');
          }
          file.writeAsString(content.join());
          setState(() {
            _downloadHint = '下载成功！';
          });
        }
      });
    });
  }

  _fetchEPUB(data) async {
    _permissionRequest();
    setState(() {
      _isDownloading = true;
    });
    List chapters = [];
    List tmp = List.from(data['chapters']);
    for (int i = 0; i < tmp.length; i++) {
      var t = tmp[i];
      t['index'] = i.toString();
      chapters.add(t);
    }
    //开始准备环境
    String opfHrefs = '';
    String opfIdrefs = '';
    String tocNcxNavs = '';
    String catalogLis = '';
    int it = 1;
    tmp.forEach((t) {
      String url = t['url'];
      String u = url.split('/')[3];
      u = u.substring(0, u.length - 4);
      opfHrefs +=
          '''<item href="chapter_$u.xhtml" id="id$u" media-type="application/xhtml+xml"/>''';
      opfIdrefs += '''<itemref idref="id$u"/>''';
      tocNcxNavs +=
          '''<navPoint id="chapter_$u" playOrder="$it"><navLabel><text>${t['name']}</text></navLabel><content src="chapter_$u.xhtml"/></navPoint>''';
      catalogLis +=
          '''<li class="catalog"><a href="chapter_$u.xhtml">${t['name']}</a></li>''';
      it++;
    });
    String contentOpf = EpubUtil.contentOpf
        .replaceAll('&title', data['name'])
        .replaceAll('&creator', data['author'])
        .replaceAll('&description', data['name'])
        .replaceAll('&contributor', 'Sizuha')
        .replaceAll('&publisher', '99csw.com')
        .replaceAll('&contributor', '99藏书网')
        .replaceAll('&subject', 'Sizuha')
        .replaceAll('&hrefs', opfHrefs)
        .replaceAll('&ids', opfIdrefs);
    String tocNcx = EpubUtil.tocNcx
        .replaceAll('&title', data['name'])
        .replaceAll('&author', data['author'])
        .replaceAll('&generator', 'Sizuha')
        .replaceAll('&navs', tocNcxNavs);
    String catalog = EpubUtil.catalog
        .replaceAll('&hrefs', opfHrefs)
        .replaceAll('&title', data['name'])
        .replaceAll('&lis', catalogLis);
    String page = EpubUtil.page
        .replaceAll('&title', data['name'])
        .replaceAll('&author', data['author'])
        .replaceAll('&intro', data['intro']);

    //准备文件

    String dir = (await getApplicationSupportDirectory()).path;
    Directory tmpDir = new Directory('$dir/${data['name'].trim()}');
    if (await tmpDir.exists()) tmpDir.deleteSync(recursive: true);
    tmpDir.createSync(recursive: true);
    String tmpDirPath = tmpDir.path;
    LogUtil.v(tmpDirPath);
    File('$tmpDirPath/content.opf').writeAsString(contentOpf);
    File('$tmpDirPath/catalog.xhtml').writeAsString(catalog);
    File('$tmpDirPath/mimetype').writeAsString(EpubUtil.mimetype);
    File('$tmpDirPath/stylesheet.css').writeAsString(EpubUtil.style);
    File('$tmpDirPath/toc.ncx').writeAsString(tocNcx);
    File('$tmpDirPath/page.xhtml').writeAsString(page);
    await Directory('$tmpDirPath/META-INF').exists()
        ? Directory('$tmpDirPath/META-INF').deleteSync(recursive: true)
        : Directory('$tmpDirPath/META-INF').createSync(recursive: true);
    File('$tmpDirPath/META-INF/container.xml')
        .writeAsString(EpubUtil.container);

    int perChapter = (chapters.length / 5).floor();
    List chapterList = [];
    for (int i = 0; i < chapters.length; i += perChapter) {
      chapterList.add(chapters
          .getRange(
              i,
              i + perChapter <= chapters.length - 1
                  ? i + perChapter
                  : chapters.length)
          .toList());
    }
    int t = 0;
    chapterList.forEach((list) {
      Future.forEach(list, (item) async {
        var url = item['url'].toString();
        String u = url.split('/')[3];
        u = u.substring(0, u.length - 4);
        var name = item['name'].toString();
        // var index = item['index'];
        var res = await ApiChapter.fetch(url);
        var c = '''<p>$res</p>''';
        // content[int.parse(index)] = c;
        var cList = c.split('\n');
        var str = '';
        cList.forEach((element) {
          str += '''<p>$element</p>''';
        });
        String content =
            EpubUtil.chapter.replaceAll('&title', name).replaceAll('&ps', str);
        File('$tmpDirPath/chapter_$u.xhtml').writeAsString(content);
        t++;
        setState(() {
          _downloadHint = '正在下载 $t / ${tmp.length}';
        });
        if (t >= tmp.length) {
          setState(() {
            _downloadHint = '正在写出数据……';
          });
          String dir;
          String file;
          if (Platform.isAndroid) {
            dir = await ExtStorage.getExternalStoragePublicDirectory(
                ExtStorage.DIRECTORY_DOCUMENTS);
            LogUtil.v(dir);
            file = '$dir/${data['name'].trim()}-${data['author'].trim()}.epub';
          } else if (Platform.isMacOS) {
            dir = (await getDownloadsDirectory()).path;
            file = '$dir/${data['name'].trim()}-${data['author'].trim()}.epub';
          }
          final dataDir = Directory('$tmpDirPath');

          // Manually create a zip of a directory and individual files.
          var encoder = ZipFileEncoder();
          encoder.zipDirectory(dataDir, filename: file);
          setState(() {
            _downloadHint = '下载成功！';
          });
        }
      });
    });
  }
}
