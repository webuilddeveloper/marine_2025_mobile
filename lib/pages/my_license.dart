import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../shared/api_provider.dart';
import 'blank_page/blank_loading.dart';

class MyLicense extends StatefulWidget {
  MyLicense({super.key, this.model, this.changePage});

  dynamic model;
  Function? changePage;

  @override
  _MyLicense createState() => _MyLicense();
}

class _MyLicense extends State<MyLicense> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  String profileCode = '';
  int? selectedButtonIndex = 1;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode2'))!;
    if (profileCode != '' && profileCode != null) {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F5),
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
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
                  widget.changePage!(0);
                  // Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.center,
                  width: 35,
                  decoration: BoxDecoration(
                    color: Color(0XFF213F91),
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
              Expanded(
                child: Text(
                  'ใบอนุญาตของฉัน',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
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
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                // height: 226,
                width: MediaQuery.of(context).size.width,
                child: Container(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: FutureBuilder<dynamic>(
                future: _futureProfile,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    if (profileCode == snapshot.data['code']) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).padding.top + 20,
                            ),
                            SingleChildScrollView(
                              scrollDirection:
                                  Axis.horizontal, // กำหนดการเลื่อนเป็นแนวนอน
                              child: Row(
                                children: [
                                  // ปุ่มแบบทึบ
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedButtonIndex = 1;
                                        });
                                      },
                                      style: selectedButtonIndex == 1
                                          ? ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0C387D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            )
                                          : OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Color(0xFF0C387D),
                                                  width: 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                      child: Text(
                                        'ประกาศนียบัตรฝ่ายนายท้ายเรือ',
                                        style: TextStyle(
                                            color: selectedButtonIndex == 1
                                                ? Colors.white
                                                : Color(0xFF0C387D),
                                            fontFamily: 'Kanit',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  // ปุ่มแบบเส้นขอบ
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedButtonIndex = 2;
                                        });
                                      },
                                      style: selectedButtonIndex == 2
                                          ? ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0C387D),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            )
                                          : OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: Color(0xFF0C387D),
                                                  width: 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                      child: Text(
                                        'ประกาศนียบัตรฝ่ายช่างกลเรือ',
                                        style: TextStyle(
                                            color: selectedButtonIndex == 2
                                                ? Colors.white
                                                : Color(0xFF0C387D),
                                            fontFamily: 'Kanit',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              // height: MediaQuery.of(context).size.height,
                              // height: 226,
                              width: MediaQuery.of(context).size.width > 336
                                  ? 336
                                  : MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  Container(
                                    // alignment: Alignment.topCenter,
                                    // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                    child: Image.asset(
                                      'assets/mock_license_cardv2.png',
                                      // color: Color(0xFF224B45),
                                      width: MediaQuery.of(context).size.width,
                                      // height: MediaQuery.of(context).size.height,
                                      fit: BoxFit.contain,
                                      height: 200,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.top - 50,
                            ),
                            // Container(
                            //   height: 80,
                            //   width: 80,
                            //   child: checkAvatar(
                            //       context, '${snapshot.data['imageUrl']}'),
                            // ),
                            Container(
                              padding: EdgeInsets.all(20),
                              height: 500,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, -20),
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'ประกาศนียบัตร',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color(0xFF213F91),
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'นายท้ายเรือกลเดินทะเลชั้นสอง',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Color(0xFF213F91),
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'สถานะใบอนุญาตใช้เรือ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Color(0xFF0C7D30),
                                            ),
                                            child: Text(
                                              'ปรกติ',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 15,
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'วันออกใบอนุญาต',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '01/11/2563',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.only(left: 30),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'วันหมดอายุ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '01/11/2568',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // SizedBox(height: 10),
                          ],
                        ),
                      );
                    } else {
                      return BlankLoading(
                        height: 80,
                        width: 80,
                      );
                    }
                  } else if (snapshot.hasError) {
                    return BlankLoading(
                      height: 80,
                      width: 80,
                    );
                  } else {
                    return BlankLoading(
                      height: 80,
                      width: 80,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
