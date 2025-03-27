import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../shared/api_provider.dart';
import 'event_calendar_list_vertical.dart';

class EventCalendarList extends StatefulWidget {
  EventCalendarList({super.key, this.title});
  final String? title;
  @override
  _EventCalendarList createState() => _EventCalendarList();
}

class _EventCalendarList extends State<EventCalendarList> {
  EventCalendarList? eventCalendarList;
  EventCalendarListVertical? gridView;

  bool hideSearch = true;
  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // _futureEventCalendarCategory =
    //     post('${eventCalendarCategoryApi}read', {'skip': 0, 'limit': 100});
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
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
            child: FutureBuilder<List<Map<String, String>>>(
              future: _fetchMockData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
                }

                final List<Map<String, String>> activities =
                    snapshot.data ?? [];

                return ListView(
                  children: [
                    const SizedBox(height: 5.0),
                    _buildCategory(),
                    const SizedBox(height: 10.0),
                    // KeySearch(
                    //   show: hideSearch,
                    //   onKeySearchChange: (String val) {
                    //     setState(() {
                    //       keySearch = val;
                    //     });
                    //   },
                    // ),
                    // const SizedBox(height: 10.0),
                    _buildList(activities, context),
                    const SizedBox(height: 30.0),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// จำลองข้อมูลกิจกรรมของกรมเจ้าท่า
  Future<List<Map<String, String>>> _fetchMockData() async {
    return Future.delayed(
      Duration(seconds: 2),
      () => [
        {
          "title": "โครงการอบรมกัปตันเรือ",
          "date": "10 มีนาคม 2567",
          "description":
              "หลักสูตรอบรมสำหรับผู้ที่ต้องการเป็นกัปตันเรือ โดยมีการฝึกปฏิบัติและเรียนรู้กฎหมายทางทะเล",
        },
        {
          "title": "กิจกรรมทำความสะอาดชายฝั่ง",
          "date": "15 มีนาคม 2567",
          "description":
              "ร่วมแรงร่วมใจกับกรมเจ้าท่าและอาสาสมัครเพื่อทำความสะอาดชายฝั่งและลดขยะในทะเล",
        },
        {
          "title": "สัมมนาความปลอดภัยทางน้ำ",
          "date": "20 มีนาคม 2567",
          "description":
              "สัมมนาให้ความรู้เกี่ยวกับความปลอดภัยในการเดินเรือและมาตรการป้องกันอุบัติเหตุทางน้ำ",
        },
        {
          "title": "วันอนุรักษ์ทะเลไทย",
          "date": "30 มีนาคม 2567",
          "description":
              "งานเฉลิมฉลองวันอนุรักษ์ทะเลไทย มีกิจกรรมปล่อยเต่าทะเลและบรรยายเกี่ยวกับการอนุรักษ์ทรัพยากรทางทะเล",
        },
      ],
    );
  }

  /// สร้าง Widget แสดงรายการกิจกรรม และเปิดหน้ารายละเอียดเมื่อกด
  Widget _buildList(
      List<Map<String, String>> activities, BuildContext context) {
    return Column(
      children: activities.map((activity) {
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: ListTile(
            leading: const Icon(Icons.event, color: Colors.blue),
            title: Text(
              activity["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(activity["date"]!),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
            onTap: () {
              // นำทางไปยังหน้ารายละเอียดกิจกรรม
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActivityDetailPage(activity: activity),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  _read() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999 // integer value type
    });
    var response = await http.post(Uri.parse('${eventCalendarCategoryApi}read'),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post('${eventCalendarApi}read', {
          'skip': 0,
          'limit': 100,
          'category': category[i]['code'],
          'keySearch': keySearch
        });
        listData.add(res);
      }
    }
  }

  // _buildList() {
  //   return gridView = new EventCalendarListVertical(
  //     site: 'DDPM',
  //     model: post('${eventCalendarApi}read', {
  //       'skip': 0,
  //       'limit': _limit,
  //       'keySearch': keySearch ?? '',
  //       'isHighlight': isHighlight ?? false,
  //       'category': categorySelected ?? ''
  //     }),
  //     urlGallery: eventCalendarGalleryApi,
  //     urlComment: eventCalendarCommentApi,
  //     url: '${eventCalendarApi}read',
  //   );
  // }

  _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new EventCalendarListVertical(
        site: 'CIO',
        model: post('${eventCalendarApi}read', {
          'skip': 0,
          'limit': _limit,
          'keySearch': keySearch,
          'isHighlight': isHighlight,
          'category': categorySelected
        }),
        urlGallery: eventCalendarGalleryApi,
        urlComment: eventCalendarCommentApi,
        url: '${eventCalendarApi}read',
      );
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  _buildCategory() {
    return FutureBuilder<dynamic>(
      future: postCategory(
        '${eventCalendarCategoryApi}read',
        {'skip': 0, 'limit': 100},
      ), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (snapshot.data[index]['code'] != '') {
                      setState(() {
                        // keySearch = '';
                        // isMain = false;
                        categorySelected = snapshot.data[index]['code'];
                      });
                    } else {
                      setState(() {
                        // isHighlight = true;
                        categorySelected = '';
                        isMain = true;
                      });
                    }
                    setState(() {
                      categorySelected = snapshot.data[index]['code'];
                      // selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: categorySelected == snapshot.data[index]['code']
                          ? Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor))
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: categorySelected == snapshot.data[index]['code']
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        // decoration:
                        //     categorySelected == snapshot.data[index]['code']
                        //         ? TextDecoration.underline
                        //         : null,
                        fontSize:
                            categorySelected == snapshot.data[index]['code']
                                ? 15.0
                                : 13.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class ActivityDetailPage extends StatelessWidget {
  final Map<String, String> activity;

  const ActivityDetailPage({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          activity["title"]!,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0C387D), // สีกรมเจ้าท่า
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // เพิ่มรูปภาพด้านบนของ Title
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // ทำให้รูปมีขอบโค้งมน
                child: Image.network(
                  "https://gateway.we-builds.com/wb-py-media/uploads/marine/20250310-144815-S__5251171.jpg",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                activity["title"]!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0C387D),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "วันที่จัดกิจกรรม: ${activity["date"]!}",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Text(
                activity["description"] ?? "ไม่มีรายละเอียดเพิ่มเติม",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
