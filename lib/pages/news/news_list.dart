import 'package:flutter/material.dart';
import 'package:marine_mobile/shared/api_provider.dart';
import '../../component/key_search.dart';
import '../../component/tab_category.dart';
import '../../shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'news_list_vertical.dart';

class NewsList extends StatefulWidget {
  NewsList({super.key, this.title});

  final String? title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  NewsListVertical? news;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    news = new NewsListVertical(
      site: "DDPM",
      model: postDio(
          '${newsApi}read', {'skip': 0, 'limit': _limit, 'app': 'marine'}),
      url: '${service.newsApi}read',
      urlComment: '${service.newsCommentApi}read',
      urlGallery: '${service.newsGalleryApi}',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      news = new NewsListVertical(
        site: 'DDPM',
        model: postDio('${newsApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          // 'category': category,
          'app': 'marine',
        }),
        url: '${service.newsApi}read',
        urlGallery: '${service.newsGalleryApi}',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.center,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Color(0XFF213F91),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'ข่าวประชาสัมพันธ์',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: const ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "News"),
              SizedBox(height: 30),
              CategorySelector(
                model: service.postCategory(
                  '${service.newsCategoryApi}read',
                  {'skip': 0, 'limit': 100, 'code': '20241028102515-482-400'},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      // category = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          // "category": category,
                          'app': 'marine',
                          "keySearch": keySearch
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  // newsList(context, service.post('${service.newsApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'app': 'marine'
                          // 'category': category
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              news!,
              // newsList(context, service.post('${service.newsApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: news,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
