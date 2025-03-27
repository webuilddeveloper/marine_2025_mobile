import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

// import '../component/material/check_avatar.dart';
// import '../shared/api_provider.dart';
// import 'blank_page/blank_loading.dart';

class MyQrCode extends StatefulWidget {
  MyQrCode({super.key, this.model, this.changePage});

  dynamic model;
  Function? changePage;

  @override
  _MyQrCode createState() => _MyQrCode();
}

class _MyQrCode extends State<MyQrCode> {
  bool showCalendar = false;
  final storage = const FlutterSecureStorage();

  // Future<dynamic>? _futureProfile;

  String profileCode = '';

  @override
  void initState() {
    super.initState();
  }

  // _callRead() async {
  //   profileCode = (await storage.read(key: 'profileCode2'))!;
  //   if (profileCode != '' && profileCode != null) {
  //     setState(() {
  //       _futureProfile = postDio(profileReadApi, {"code": profileCode});
  //     });
  //   }
  // }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.model;

    final queryParameters = item.map<String, String?>((key, value) {
      if (key is! String) return MapEntry(key.toString(), null);
      if (value == null) return MapEntry(key, null);
      return MapEntry(key, value.toString());
    })
      ..removeWhere((key, value) => value == null);

    final Uri qrUri = Uri(
      scheme: "http",
      host: "gateway.we-builds.com",
      path: "marine_information.html",
      queryParameters: queryParameters,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          titleSpacing: 5,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: const Color(0XFF213F91),
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
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.12,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0XFFF3F5F5),
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05,
                  ),
                  child: QrImageView(
                    data: qrUri.toString(),
                    size: 250,
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF0C387D),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Image.asset(
                "assets/images/bg_buttom_qr_code.png",
                height: MediaQuery.of(context).size.height * 0.47,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF0C387D),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.47,
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // รูปโปรไฟล์
                      Container(
                        height: 185,
                        width: 185,
                        padding: EdgeInsets.only(right: 10),
                        child: item["imageUrl"] != ''
                            ? CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    NetworkImage(item["imageUrl"] ?? ''),
                              )
                            : Container(
                                padding: EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/images/user_not_found.png',
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),

                      Text(
                        '${item['firstName'] ?? ''} ${item['lastName'] ?? ''}',
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color(0XFFF5F5F5),
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'สมรรถภาพทางกาย',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'ผ่านเกณฑ์',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'สถานะการอบรม',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: const Text(
                                'เข้ารับและผ่านการอบรม',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0XFF000000),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              'สถานะใบอนุญาต',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: const Text(
                                'มีใบอนุญาตเป็นพนักงาน',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Color(0XFF000000),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'วันออกใบอนุญาต',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
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
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      const Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'วันหมดอายุ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '01/11/2566',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Color(0XFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
