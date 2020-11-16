import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

import 'http/dio.dart';
import 'router.dart';

void main() {
  LogUtil.init(isDebug: true);
  DioUtil().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      builder: (BuildContext context, Widget child) {
        return OneContext().builder(context, child, initialRoute: '/');
      },
      navigatorKey: OneContext().key,
      // 通过 PageConstants 引入
      onGenerateRoute: onGenerateRoute,
    );
  }
}
