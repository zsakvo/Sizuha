import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizuha/page/home.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() async {
    if (Platform.isAndroid) {
      FlutterStatusbarManager.setColor(Colors.grey[50], animated: true);
      FlutterStatusbarManager.setNavigationBarColor(Colors.grey[50],
          animated: true);
      FlutterStatusbarManager.setNavigationBarStyle(NavigationBarStyle.DARK);
      FlutterStatusbarManager.setStyle(StatusBarStyle.DARK_CONTENT);
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: PageView(
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            HomePage(),
            Container(
              child: Center(
                child: Text(
                  '这里应该放一个排行榜，但我还没写好 :)',
                  style: TextStyle(color: HexColor('#595959'), fontSize: 13),
                ),
              ),
            ),
            Container(
              child: Center(
                child: Text(
                  '这里应该放一些文库内容，但我依旧还没写好 :)',
                  style: TextStyle(color: HexColor('#595959'), fontSize: 13),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        unselectedItemColor: HexColor('#717171'),
        selectedItemColor: HexColor('#1890ff'),
        items: [
          BottomNavigationBarItem(
            icon: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(HexColor('#717171'), BlendMode.srcIn),
                child: SizedBox(
                  child: Image.asset(
                    'assets/img/home.png',
                    width: 24,
                  ),
                )),
            activeIcon: ColorFiltered(
                colorFilter:
                    ColorFilter.mode(HexColor('#1890ff'), BlendMode.srcIn),
                child: SizedBox(
                  child: Image.asset(
                    'assets/img/home.png',
                    width: 24,
                  ),
                )),
            label: '推荐',
          ),
          BottomNavigationBarItem(
              icon: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(HexColor('#717171'), BlendMode.srcIn),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/img/artboard.png',
                      width: 24,
                    ),
                  )),
              activeIcon: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(HexColor('#1890ff'), BlendMode.srcIn),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/img/artboard.png',
                      width: 24,
                    ),
                  )),
              label: '排行'),
          BottomNavigationBarItem(
              icon: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(HexColor('#717171'), BlendMode.srcIn),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/img/bill.png',
                      width: 24,
                    ),
                  )),
              activeIcon: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(HexColor('#1890ff'), BlendMode.srcIn),
                  child: SizedBox(
                    child: Image.asset(
                      'assets/img/bill.png',
                      width: 24,
                    ),
                  )),
              label: '文库')
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }
}
