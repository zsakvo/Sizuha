import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  int _page = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  @override
  void initState() {
    searchKey = widget.arguments['key'];
    LogUtil.v(searchKey);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    setState(() {});
  }

  void _onRefresh() async {
    _page = 1;
    books = await ApiSearch.fetch(searchKey, _page);
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _page++;
    try {
      await Future.delayed(Duration(milliseconds: 1000));
      var tmp = await ApiSearch.fetch(searchKey, _page);
      books.addAll(tmp);
      if (mounted) setState(() {});
    } catch (err) {
      _page--;
      LogUtil.v(err);
    }
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '搜索“$searchKey”',
            style: TextStyle(
                color: HexColor('#222222'), fontWeight: FontWeight.w500),
          ),
          centerTitle: false,
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
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: ClassicHeader(),
        footer: ClassicFooter(),
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: books[i]['cover'],
                    width: 72,
                    height: 96,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          books[i]['name'],
                          style: TextStyle(
                              color: HexColor('#222222'),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              height: 2.0),
                        ),
                        Text(
                          books[i]['author'],
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
                'url': books[i]['url'],
              });
            },
          ),
          itemExtent: 100.0,
          itemCount: books.length,
        ),
      ),
    );
  }
}
