import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizuha/http/api/search.dart';

class SearchResultPage extends StatefulWidget {
  final Map arguments;
  SearchResultPage({Key key, this.arguments});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String searchKey = '';
  List books = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  searchBook(searchKey) async {
    books = await ApiSearch.fetch(searchKey, 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil.getScreenH(context) - ScreenUtil().appBarHeight,
        child: ListView(
          children: books.map((e) {
            return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: e['cover'],
                      width: 72,
                      height: 96,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e['name'],
                            style: TextStyle(
                                color: HexColor('#222222'),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                height: 2.0),
                          ),
                          Text(
                            e['author'],
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
                Navigator.of(context).pushNamed('/detail', arguments: {
                  'url': e['url'],
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
