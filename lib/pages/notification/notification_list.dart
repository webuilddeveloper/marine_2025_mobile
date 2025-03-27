import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:marine_mobile/component/header.dart';

import '../../home_v2.dart';
import '../../shared/api_provider.dart';
import '../../shared/extension.dart';
import '../blank_page/toast_fail.dart';
import '../event_calendar/event_calendar_form.dart';
import '../knowledge/knowledge_form.dart';
import '../news/news_form.dart';
import '../poi/poi_form.dart';
import '../poll/poll_form.dart';
import '../privilege/privilege_form.dart';
import '../warning/warning_form.dart';
import '../welfare/welfare_form.dart';

class NotificationList extends StatefulWidget {
  NotificationList({super.key, this.title});

  final String? title;

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  checkNavigationPage(String page, dynamic model) {
    switch (page) {
      case 'newsPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsForm(
                url: newsApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: newsCommentApi,
                urlGallery: newsGalleryApi,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'eventPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarForm(
                url: eventCalendarApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: eventCalendarCommentApi,
                urlGallery: eventCalendarGalleryApi,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'privilegePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'knowledgePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'poiPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                url: poiApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: poiCommentApi,
                urlGallery: poiGalleryApi,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'pollPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'warningPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarningForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'welfarePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WelfareForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      case 'mainPage':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageV2(),
            ),
          ).then((value) => {setState(() {})});
        }
        break;

      default:
        {
          return toastFail(context, text: 'เกิดข้อผิดพลาด');
        }
        break;
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: header(
        context,
        () => goBack(),
        title: widget.title!,
        isButtonLeft: false,
        isButtonRight: true,
        rightButton: () => _handleClickMe(),
        imageRightButton: 'assets/images/task_list.png',
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        margin: EdgeInsets.only(top: 10), // ปรับตำแหน่งให้เหมาะสม
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            _buildNotificationCard(
              title: "คุณได้ต่ออายุใบอนุญาตขับขี่เรือแล้ว",
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            _buildNotificationCard(
              title: "ใบอนุญาตขับขี่เรือของคุณใกล้จะหมดอายุ",
              icon: Icons.warning,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

// ฟังก์ชันสร้างการ์ดแจ้งเตือน
  Widget _buildNotificationCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      margin: EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon, color: color, size: 32.0),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => {
        postAny('${notificationApi}update', {
          'category': '${model['category']}',
          "code": '${model['code']}'
        }).then((response) {
          if (response == 'S') {
            checkNavigationPage(model['category'], model);
          }
        })
      },
      child: Slidable(
        // fixflutter2 actionPane: SlidableDrawerActionPane(),
        // fixflutter2 actionExtentRatio: 0.25,

        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.2 / 100),
          height: (height * 15) / 100,
          width: width,
          decoration: BoxDecoration(
            color:
                model['status'] == 'A' ? Colors.white : const Color(0xFFE7E7EE),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 1 / 100, vertical: height * 1.2 / 100),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.7 / 100, right: width * 1 / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 1 / 100),
                        color:
                            model['status'] == 'A' ? Colors.white : Colors.red,
                      ),
                      height: height * 2 / 100,
                      width: height * 2 / 100,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontSize: (height * 2) / 100,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.normal,
                            color: const Color(0xFFFF7514),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 5 / 100, vertical: height * 1.5 / 100),
                child: Text(
                  '${dateStringToDate(model['createDate'])}',
                  style: TextStyle(
                    fontSize: (height * 1.7) / 100,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // fixflutter2 secondaryActions: <Widget>[
        //   IconSlideAction(
        //     caption: 'Delete',
        //     color: Colors.red,
        //     icon: Icons.delete,
        //     onTap: () => {
        //       setState(() {
        //         postAny('${notificationApi}delete', {
        //           'category': '${model['category']}',
        //           "code": '${model['code']}'
        //         }).then((response) {
        //           if (response == 'S') {
        //             setState(() {
        //               _futureModel = postDio(
        //                   '${notificationApi}read', {'skip': 0, 'limit': 999});
        //             });
        //           }
        //         });
        //       })
        //     },
        //   ),
        // ],
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('ตัวเลือก'),
          // message: Text(''),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}update', {}).then((response) {
                    if (response == 'S') {
                      setState(() {});
                    }
                  });
                });
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'ลบทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}delete', {}).then((response) {
                    if (response == 'S') {
                      setState(() {});
                    }
                  });
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('ยกเลิก',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
