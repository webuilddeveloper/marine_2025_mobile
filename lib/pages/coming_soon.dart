import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../menu.dart';

class ComingSoon extends StatefulWidget {
  ComingSoon({super.key, this.model});

  dynamic model;

  @override
  _ComingSoon createState() => _ComingSoon();
}

class _ComingSoon extends State<ComingSoon> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  String profileCode = '';

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    // profileCode = await storage.read(key: 'profileCode2');
    // if (profileCode != '' && profileCode != null) {
    //   setState(() {
    //     _futureProfile = postDio(profileReadApi, {"code": profileCode});
    //   });
    // }
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
                    color: Color(0XFF0C387D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              // Expanded(
              //   child: Text(
              //     'Coming Soon',
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.w500,
              //       fontFamily: 'Kanit',
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          // overScroll.disallowGlow();
          overScroll.disallowIndicator();
          return false;
        },
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/time_icon.png',
                height: 180, fit: BoxFit.contain, width: 180),
            Text(
              'เตรียมพบกันเร็วๆ นี้',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Menu(
                      pageIndex: 0,
                    ),
                  ),
                  (Route<dynamic> route) => false,
                ),
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFF213F91),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Text(
                    'กลับหน้าหลัก',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
