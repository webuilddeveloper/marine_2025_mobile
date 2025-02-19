import 'package:flutter/material.dart';
import 'package:marine_mobile/pages/license/check_license_detail.dart';
import 'package:marine_mobile/widget/text_form_field.dart';

import '../../component/carousel_banner.dart';
import '../../component/carousel_form.dart';
import '../../component/link_url_in.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'check_license_list_category_vertical.dart';

class CheckLicense extends StatefulWidget {
  CheckLicense({super.key, this.title, this.code});
  final String? title;
  final String? code;
  @override
  _CheckLicense createState() => _CheckLicense();
}

class _CheckLicense extends State<CheckLicense> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureCategoryContact;
  final txtLicense = TextEditingController();
  dynamic _model = {};
  dynamic _tempModel = [
    {
      'code': '1',
      'boatName': 'Uniwise A1',
      'license': '1',
      'category': '1',
      'status': 'ใช้งาน',
      'description': '-',
      'expDate': '14/05/2025',
    },
    {
      'code': '2',
      'boatName': 'Uniwise A2',
      'license': '2',
      'category': '1',
      'status': 'หมดอายุ',
      'description': '-',
      'expDate': '14/05/2022',
    },
    {
      'code': '3',
      'boatName': 'Uniwise A3',
      'license': '3',
      'category': '1',
      'status': 'ยกเลิก',
      'description': 'เรือถูกยกเลิก',
      'expDate': '14/05/2022',
    },
    {
      'code': '4',
      'boatName': 'ยอดรัก B1',
      'license': '1',
      'category': '2',
      'status': 'ใช้งาน',
      'description': '-',
      'expDate': '14/05/2025',
    },
    {
      'code': '5',
      'boatName': 'ยอดรัก B2',
      'license': '2',
      'category': '2',
      'status': 'หมดอายุ',
      'description': '-',
      'expDate': '14/05/2022',
    },
    {
      'code': '6',
      'boatName': 'ยอดรัก B3',
      'license': '3',
      'category': '2',
      'status': 'ยกเลิก',
      'description': 'เรือถูกยกเลิก',
      'expDate': '14/05/2022',
    },
  ];

  @override
  void dispose() {
    txtLicense.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, true);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'ตรวจสอบข้อมูลใบอนุญาต',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 30),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                  ),
                ],
                // color: Color.fromRGBO(0, 0, 2, 1),
              ),
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.circular(15.0),
                      color: Color(0xFFFFFFFF),
                    ),
                    padding: EdgeInsets.all(15.0),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            'ตรวจสอบเลขที่ใบอนุญาต',
                            style: new TextStyle(
                              fontSize: 22.0,
                              color: Color(0XFF213F91),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          child: Text(
                            '${widget.title}',
                            style: new TextStyle(
                              fontSize: 22.0,
                              color: Color(0XFF213F91),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: textFormFieldNoValidator(
                            txtLicense,
                            '',
                            true,
                            false,
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          width: 200,
                          // margin: EdgeInsets.symmetric(
                          //     vertical: 10.0, horizontal: 40),
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).primaryColor,
                            child: MaterialButton(
                              // minWidth: MediaQuery.of(context).size.width,
                              height: 40,
                              onPressed: () {
                                checkLicense();
                              },
                              child: new Text(
                                'ตรวจสอบ',
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  checkLicense() {
    setState(() {
      _model = _tempModel
          .where((c) =>
              c['category'] == widget.code && c['license'] == txtLicense.text)
          .toList();
    });
    if (txtLicense.text.isNotEmpty) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckLicenseDetail(
            model: _model,
          ),
        ),
      );
    }
  }
}
