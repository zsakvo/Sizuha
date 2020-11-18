import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:one_context/one_context.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    return RefreshConfiguration(
        headerBuilder: () => ClassicHeader(),
        footerBuilder: () => ClassicFooter(), // 配置默认底部指示器
        headerTriggerDistance: 80.0, // 头部触发刷新的越界距离
        springDescription: SpringDescription(
            stiffness: 170,
            damping: 16,
            mass: 1.9), // 自定义回弹动画,三个属性值意义请查询 flutter api
        maxOverScrollExtent: 100, //头部最大可以拖动的范围,如果发生冲出视图范围区域,请设置这个属性
        maxUnderScrollExtent: 30, // 底部最大可以拖动的范围
        enableScrollWhenRefreshCompleted:
            true, //这个属性不兼容 PageView 和 TabBarView,如果你特别需要 TabBarView 左右滑动,你需要把它设置为 true
        enableLoadingWhenFailed: true, //在加载失败的状态下,用户仍然可以通过手势上拉来触发加载更多
        hideFooterWhenNotFull: true, // Viewport 不满一屏时,禁用上拉加载更多功能
        enableBallisticLoad: false, // 可以通过惯性滑动触发加载更多
        child: MaterialApp(
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
        ));
  }
}
