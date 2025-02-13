import 'package:flutter/material.dart';
// import 'package:weconnectsecurity/component/header.dart';
import '../../component/key_search.dart';
import '../../component/tab_category.dart';
import '../../widget/header.dart';
import 'knowledge_list_vertical.dart' as grid;
// import 'package:weconnectsecurity/component/key_search.dart';
// import 'package:weconnectsecurity/component/tab_category.dart';
// import 'package:weconnectsecurity/shared/api_provider.dart' as service;
import '../../shared/api_provider.dart'  as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'knowledge_list_vertical.dart';

class KnowledgeList extends StatefulWidget {
  KnowledgeList({super.key, this.title});
  final String? title;

  @override
  _KnowledgeList createState() => _KnowledgeList();
}

class _KnowledgeList extends State<KnowledgeList> {
  grid.KnowledgeListVertical? gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    gridView = new grid.KnowledgeListVertical(
      site: 'DDPM',
      model: service
          .post('${service.knowledgeApi}read', {'skip': 0, 'limit': _limit}),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new grid.KnowledgeListVertical(
        site: 'DDPM',
        model: service.post('${service.knowledgeApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch
        }),
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
      appBar: header(context, goBack, title: 'คลังความรู้'),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.knowledgeCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      gridView = new grid.KnowledgeListVertical(
                        site: 'DDPM',
                        model: service.post('${service.knowledgeApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          'category': category,
                          'keySearch': keySearch
                        }),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 5.0,
              ),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      gridView = new grid.KnowledgeListVertical(
                        site: 'DDPM',
                        model: service.post('${service.knowledgeApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          'keySearch': keySearch,
                          'category': category
                        }),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              gridView!,
              // Expanded(
              //   flex: 1,
              //   child: gridView,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
