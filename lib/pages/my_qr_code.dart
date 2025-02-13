import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../component/material/check_avatar.dart';
import '../shared/api_provider.dart';
import 'blank_page/blank_loading.dart';

class MyQrCode extends StatefulWidget {
  MyQrCode({super.key, this.model, this.changePage});

  dynamic model;
  Function? changePage;

  @override
  _MyQrCode createState() => _MyQrCode();
}

class _MyQrCode extends State<MyQrCode> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  String profileCode = '';

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
      backgroundColor: Colors.white,
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
                  'คิวอาโค้ดของฉัน',
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
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
          child: FutureBuilder<dynamic>(
            future: _futureProfile,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (profileCode == snapshot.data['code']) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 60,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width > 336
                              ? 336
                              : MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Container(
                                child: Image.asset(
                                  'assets/profile_qr.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: 220,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.top - 80,
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Image.asset(
                                "assets/bg_bottom_profile.png",
                                // height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width / 2 - 40,
                              child: Container(
                                height: 80,
                                width: 80,
                                // padding: EdgeInsets.only(right: 10),
                                child: checkAvatar(
                                  context, '${snapshot.data['imageUrl']}'),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: MediaQuery.of(context).size.width / 2 - 150,
                              child: Container(
                                width: 300,
                                alignment: Alignment.center,
                                child: Text(
                                  '${snapshot.data['firstName'] ?? ''} ${snapshot.data['lastName'] ?? ''}',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top:
                                  150, // Distance from top (including the profile)
                              left: 20, // Add padding from the left side
                              right: 20, // Add padding from the right side
                              child: Column(
                                children: [
                                  LicenseInfoRow(
                                    'สถานะใบอนุญาตใช้เรือ',
                                    'เข้ารับและผ่านการอบรม',
                                    isStatus: true,
                                  ),
                                  LicenseInfoRow(
                                    'เลขที่ใบอนุญาต',
                                    '012-21313446',
                                  ),
                                  LicenseInfoRow(
                                    'วันออกใบอนุญาต',
                                    '01/11/2563',
                                  ),
                                  LicenseInfoRow(
                                    'วันหมดอายุ',
                                    '01/11/2566',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
      ),
    );
  }

  LicenseInfoRow(
    String title,
    String value, {
    bool isStatus = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.w400,
              fontSize: 16,
              fontFamily: 'Kanit',
            ),
          ),
          isStatus
              ? Container(
                  width: 100,
                  height: 35,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Text(
                    'มีใบอนุญาต',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    fontFamily: 'Kanit',
                  ),
                ),
        ],
      ),
    );
  }
}
