import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/button_close_back.dart';
import '../../component/comment.dart';
import '../../component/contentPoi.dart';
import '../../shared/api_provider.dart';

// ignore: must_be_immutable
class PoiForm extends StatefulWidget {
  PoiForm({
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
  _PoiForm createState() => _PoiForm();
}

class _PoiForm extends State<PoiForm> {
  Comment? comment;
  int? _limit;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = _limit! + 10;

      comment = Comment(
        code: widget.code,
        url: poiCommentApi,
        model: post('${poiCommentApi}read',
            {'skip': 0, 'limit': _limit, 'code': widget.code}),
        limit: _limit,
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: poiCommentApi,
      model: post('${poiCommentApi}read',
          {'skip': 0, 'limit': _limit, 'code': widget.code}),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
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
                  ContentPoi(
                    pathShare: 'content/poi/',
                    code: widget.code,
                    url: '${poiApi}read',
                    model: widget.model,
                    urlGallery: widget.urlGallery,
                  ),
                  Positioned(
                    right: 0,
                    top: statusBarHeight + 5,
                    child: Container(
                      child: buttonCloseBack(context),
                    ),
                  ),
                ],
              ),

              widget.urlComment != '' ? comment! : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
