import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../component/gallery_view.dart';
import '../component/material/custom_alert_dialog.dart';
import '../shared/api_provider.dart';
import '../shared/extension.dart';
import '../widget/header.dart';
import 'appeal.dart';
import 'blank_page/toast_fail.dart';
import 'qr_payment.dart';

class TrafficTicketDetail extends StatefulWidget {
  TrafficTicketDetail({
    super.key,
    this.cardID,
    this.ticketID,
  });

  final String? cardID;
  final String? ticketID;

  @override
  _TrafficTicketDetailPageState createState() =>
      _TrafficTicketDetailPageState();
}

class _TrafficTicketDetailPageState extends State<TrafficTicketDetail> {
  Future<dynamic>? futureModel;
  String imageTemp =
      'https://instagram.fbkk5-6.fna.fbcdn.net/v/t51.2885-15/sh0.08/e35/c0.180.1440.1440a/s640x640/133851894_231577355006812_2104786467046058604_n.jpg?_nc_ht=instagram.fbkk5-6.fna.fbcdn.net&_nc_cat=1&_nc_ohc=t-y0eYG-FkYAX8VbpYj&tp=1&oh=d5fed0e8846f1056c70836b6fce223eb&oe=601E2B77';

  @override
  void initState() {
    super.initState();

    read();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, () {
        Navigator.pop(context);
      }, title: 'รายละเอียดใบสั่ง'),
      backgroundColor: const Color(0xFFF5F8FB),
      body: _futureBuilder(),
    );
  }

  _futureBuilder() {
    return FutureBuilder<dynamic>(
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return _screen(snapshot.data[0]);
          } else {
            return Container();
          }
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _screen(dynamic model) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: const Color(0xFFEDF0F3),
            child: const Text(
              'รายละเอียดใบสั่ง',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 15,
              ),
            ),
          ),
          _textRow(
            title: 'วันที่กระทำความผิด',
            value: dateStringToDate(model['ticket_DATE']),
          ),
          _textRow(
            title: 'เลขที่ใบสั่ง',
            value: model['org_CODE'],
          ),
          _textRow(
            title: 'หมายเลขหนังสือ',
            value: 'xxxxxxxxxxxxxxx',
          ),
          _textRow(
            title: 'ชนิดยานภาหนะ',
            value: 'รถยนต์ส่วนบุคคล',
          ),
          _textRow(
            title: 'หมายเลขทะเบียน',
            value: model['plate'],
          ),
          Container(height: 5, color: Colors.white),
          _textRow(
            title: 'ข้อหา',
            value: ' - ' + model['accuse1_CODE'],
            maxLine: 10,
            spaceBetween: 30,
          ),
          if (model['accuse2_CODE'] != null)
            _textRow(
              title: '',
              value: ' - ' + model['accuse2_CODE'],
              maxLine: 10,
              spaceBetween: 30,
            ),
          if (model['accuse3_CODE'] != null)
            _textRow(
              title: '',
              value: ' - ' + model['accuse3_CODE'],
              maxLine: 10,
              spaceBetween: 30,
            ),
          if (model['accuse4_CODE'] != null)
            _textRow(
              title: '',
              value: ' - ' + model['accuse4_CODE'],
              maxLine: 10,
              spaceBetween: 30,
            ),
          if (model['accuse5_CODE'] != null)
            _textRow(
              title: '',
              value: ' - ' + model['accuse5_CODE'],
              maxLine: 10,
              spaceBetween: 30,
            ),
          Container(height: 5, color: Colors.white),
          _textRow(
            title: 'หน่วยงานที่ออกใบสั่ง',
            value: model['org_ABBR'],
          ),
          _textRow(
            title: 'ชื่อผู้ขับขี่',
            value: model['fullname'],
          ),
          _textRow(
            title: 'เลขที่ใบอนุญาตขับขี่',
            value: model['card_ID'],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  List<ImageProvider> photos = [];
                  if (model['pic1'] != null && model['pic1'] != '') {
                    photos.add(NetworkImage(model['pic1']));
                  }
                  if (model['pic2'] != null && model['pic2'] != '') {
                    photos.add(NetworkImage(model['pic2']));
                  }
                  if (model['pic3'] != null && model['pic3'] != '') {
                    photos.add(NetworkImage(model['pic3']));
                  }
                  if (photos.isNotEmpty) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return ImageViewer(
                          initialIndex: 0,
                          imageProviders: photos,
                        );
                      },
                    );
                  } else {
                    toastFail(context, text: 'ไม่พบรูปภาพ');
                  }
                },
                child: Container(
                  width: 168,
                  height: 40,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: const Text(
                    'ดูรูปการกระทำความผิด',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          QRPayment(code: model['code'], back: false),
                    ),
                  );
                },
                child: Container(
                  width: 168,
                  height: 40,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEBC22B),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 2,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: const Text(
                    'ชำระค่าปรับ',
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontSize: 13,
                      color: Color(0xFF4E2B68),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 80),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialogVerification(model);
                },
              );
            },
            child: const Text(
              'ยื่นอุทธรณ์',
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: 13,
                color: Color(0xFF9C0000),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  _textRow({
    String title = '',
    String value = '',
    Color titleColor = const Color(0xFF9E9E9E),
    Color valueColor = const Color(0xFF000000),
    double valueSize = 13,
    int maxLine = 1,
    double spaceBetween = 15,
  }) {
    return Container(
      constraints: const BoxConstraints(minHeight: 35),
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Sarabun',
              fontSize: 13,
              color: titleColor,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(width: spaceBetween),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Sarabun',
                fontSize: valueSize,
                color: valueColor,
              ),
              maxLines: maxLine,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  dialogVerification(dynamic model) {
    return CustomAlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: 345,
        height: 280,
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(0x00ffffff),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'การยื่นเรื่องยื่นอุทธรณ์',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F267B),
                ),
              ),
              const Text(
                '(กรุณาเลือกเรื่องยื่นอุทธรณ์)',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 11,
                  color: Color(0xFF414141),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Appeal(
                              title: 'ทะเบียนรถในใบสั่งไม่ตรงกับรถของท่าน',
                              ticketId: model['ticket_ID'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 169,
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F267B),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/card_id.png',
                              width: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'ทะเบียนรถในใบสั่งไม่ตรงกับรถของท่าน',
                              style: TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Appeal(
                                title: 'รถที่ปรากฏตามใบสั่งไม่ใช่รถของท่าน',
                                ticketId: model['ticket_ID']),
                          ),
                        );
                      },
                      child: Container(
                        height: 169,
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF707070),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/car_front.png',
                              width: 40,
                              color: Colors.white,
                            ),
                            const Text(
                              'รถที่ปรากฏตามใบสั่งไม่ใช่รถของท่าน',
                              style: TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        // child: //Contents here
      ),
    );
  }

  // function
  read() async {
    futureModel = postDio(getTicketDetailApi, {
      "createBy": "createBy",
      "updateBy": "updateBy",
      "card_id": widget.cardID,
      "ticket_id": widget.ticketID,
    });
  }
}
