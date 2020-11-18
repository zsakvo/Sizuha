import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizuha/http/api/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List lists = [];

  @override
  void didChangeDependencies() async {
    if (Platform.isAndroid) {
      await FlutterStatusbarManager.setColor(
          Theme.of(context).scaffoldBackgroundColor,
          animated: true);
      await FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
      await FlutterStatusbarManager.setNavigationBarColor(
          Theme.of(context).scaffoldBackgroundColor,
          animated: true);
      await FlutterStatusbarManager.setNavigationBarStyle(
          NavigationBarStyle.LIGHT);
    }
    super.didChangeDependencies();
    lists = await ApiIndex.fetch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Sizuha',
            style: TextStyle(color: HexColor('#222222')),
          ),
          centerTitle: false,
          brightness: Brightness.light,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
        ),
        body: Column(
          children: [_buildSearchBar(), _buildRankList()],
        ));
  }

  Widget _buildSearchBar() {
    return Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 4, bottom: 20),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Container(
          decoration: BoxDecoration(
              color: HexColor('#F4F4F5'),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              )),
          // width: ScreenUtil.getInstance().screenWidth - 68,
          child: TextField(
            cursorColor: HexColor('#222222'),
            style: TextStyle(
              fontSize: 14,
              color: HexColor('#222222'),
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '搜索书名或作者',
              hintStyle: TextStyle(fontSize: 14, color: HexColor('#C5C5C6')),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            ),
            onSubmitted: (String str) {
              Navigator.of(context).pushNamed('/search', arguments: {
                'key': str,
              });
            },
          ),
        ));
  }

  Widget _buildRankList() {
    return Container(
        height: ScreenUtil.getScreenH(context) -
            ScreenUtil.getStatusBarH(context) -
            180,
        child: ListView(
          children: lists.map((list) {
            return Column(
              children: [
                // Container(
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Text(
                //         list['title'],
                //         style: TextStyle(
                //             color: HexColor('#222222'),
                //             fontSize: 14,
                //             fontWeight: FontWeight.bold),
                //       ),
                //       ColorFiltered(
                //           colorFilter: ColorFilter.mode(
                //               HexColor('#8c8c8c'), BlendMode.srcIn),
                //           child: Image.asset(
                //             'assets/img/arrow-right.png',
                //             width: 24,
                //           ))
                //     ],
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   ),
                //   padding:
                //       EdgeInsets.only(top: 0, bottom: 10, left: 12, right: 12),
                // ),
                Column(
                  children: [
                    ...List.from(list['books']).map((book) {
                      return InkWell(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CachedNetworkImage(
                                imageUrl: book['cover'],
                                width: 72,
                                height: 96,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book['name'],
                                      style: TextStyle(
                                          color: HexColor('#222222'),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          height: 2.0),
                                    ),
                                    Text(
                                      book['author'],
                                      style: TextStyle(
                                        color: HexColor('#8c8c8c'),
                                        fontSize: 14,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/detail', arguments: {
                            'url': book['url'],
                          });
                        },
                      );
                    }).toList(),
                    SizedBox(height: 10),
                  ],
                )
              ],
            );
          }).toList(),
        ));
  }
}
