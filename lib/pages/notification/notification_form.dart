import 'package:flutter/material.dart';

import '../../component/button_close_back.dart';
import '../../component/comment.dart';
import '../../component/content.dart';
import '../../shared/api_provider.dart';

// ignore: must_be_immutable
class NotificationForm extends StatefulWidget {
  NotificationForm({
    super.key,
    this.url,
    this.code,
    this.model,
    this.urlComment,
    this.urlGallery,
  });

  final String? url;
  final String? code;
  final dynamic model;
  final String? urlComment;
  final String? urlGallery;

  @override
  _NotificationForm createState() => _NotificationForm();
}

class _NotificationForm extends State<NotificationForm> {
  Comment? comment;
  int? _limit;

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: widget.urlComment,
      model: post('${newsCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          shrinkWrap: true,
          children: [
            // Expanded(
            //   child:
            Stack(
              // fit: StackFit.expand,
              // alignment: AlignmentDirectional.bottomCenter,
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: [
                Content(
                  code: widget.code,
                  url: widget.url,
                  model: widget.model,
                  urlGallery: widget.urlGallery,
                ),
                Positioned(
                  right: 0,
                  top: (height * 0.5 / 100),
                  child: Container(
                    child: buttonCloseBack(context),
                  ),
                ),
              ],
              // overflow: Overflow.clip,
            ),
            SizedBox(
              height: 50,
            )
            // ),
            // widget.urlComment != '' ? comment : Container(),
          ],
        ),
      ),
    );
  }
}
