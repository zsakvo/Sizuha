import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizuha/http/api/chapter.dart';
import 'package:sizuha/http/api/detail.dart';
import 'package:sizuha/util/render.dart';

class BookDetail extends StatefulWidget {
  final Map arguments;
  BookDetail({Key key, this.arguments});
  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  Future _future;

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
                                maxLines:
                                    ((ScreenUtil.getScreenH(context) - 400) /
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
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        height: 38,
                        width: ScreenUtil.getScreenW(context) - 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                width: (ScreenUtil.getInstance().screenWidth -
                                        40) *
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
                                    'TXT',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: HexColor('#222222')),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: () async {
                                    _fetchTXT(data['chapters']);
                                  },
                                )),
                            Container(
                                width: (ScreenUtil.getInstance().screenWidth -
                                        48) *
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
                                    'EPUB',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: HexColor('#ffffff')),
                                  ),
                                  minWidth: double.infinity,
                                  onPressed: () async {},
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

  _fetchTXT(chapters) async {
    chapters = List.from(chapters);
    LogUtil.v(chapters);
    var content = '';
    await Future.forEach(chapters, (item) async {
      var url = item['url'].toString();
      var res = await ApiChapter.fetch(url);
      content += (res + "\n\n\n");
    });
    LogUtil.v(content);
  }
}
