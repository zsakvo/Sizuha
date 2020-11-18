import 'package:flutter/material.dart';
import 'package:sizuha/page/detail.dart';
import 'package:sizuha/page/home.dart';
import 'package:sizuha/page/index.dart';
import 'package:sizuha/page/search.dart';

final routes = {
  '/': (context, {arguments}) => IndexPage(),
  '/index': (context, {arguments}) => HomePage(),
  '/detail': (context, {arguments}) => BookDetailPage(arguments: arguments),
  '/search': (context, {arguments}) => SearchResultPage(arguments: arguments),
};

// 处理参数传递
// ignore: top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  // 获取声明的路由页面函数
  var pageBuilder = routes[settings.name];
  if (pageBuilder != null) {
    if (settings.arguments != null) {
      // 创建路由页面并携带参数
      return MaterialPageRoute(
          builder: (context) =>
              pageBuilder(context, arguments: settings.arguments));
    } else {
      return MaterialPageRoute(builder: (context) => pageBuilder(context));
    }
  }
  return MaterialPageRoute(builder: (context) => HomePage());
};
