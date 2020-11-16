import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:one_context/one_context.dart';

class RenderUtil {
  static Widget renderPlaceholder(
      {placeHolder = '正在加载数据……', alignment: MainAxisAlignment.end}) {
    return Container(
      width: ScreenUtil.getInstance().screenWidth,
      height: ScreenUtil.getInstance().screenHeight / 2,
      child: Column(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 142,
            child: LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            placeHolder,
            style: TextStyle(color: HexColor('#757575'), fontSize: 13),
          ),
        ],
      ),
    );
  }

  static Widget renderFindBookItem(book) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(bottom: 16, left: 16, right: 16, top: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: book['cover'],
              width: 72,
              height: 96,
            ),
            Container(
              height: 96,
              width: ScreenUtil.getInstance().screenWidth - 108,
              padding: EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    book['book_name'],
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    book['description'],
                    style: TextStyle(
                        fontSize: 13, height: 1.4, color: HexColor('#8c8c8c')),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        book['author_name'],
                        style:
                            TextStyle(color: HexColor('#8c8c8c'), fontSize: 12),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        OneContext().pushNamed('/bookDetail', arguments: {
          'bookName': book['book_name'],
          'bookId': book['book_id'],
        });
      },
    );
  }
}
