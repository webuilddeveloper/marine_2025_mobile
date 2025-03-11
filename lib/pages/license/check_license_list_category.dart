import 'package:flutter/material.dart';

import '../../shared/api_provider.dart';
import 'check_license_list_category_vertical.dart';

class CheckLicenseListCategory extends StatefulWidget {
  const CheckLicenseListCategory({super.key, this.title});
  final String? title;
  @override
  CheckLicenseListCategoryState createState() =>
      CheckLicenseListCategoryState();
}

class CheckLicenseListCategoryState extends State<CheckLicenseListCategory> {
  CheckLicenseListCategoryVertical? contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  final dynamic _model = [
    {
      'code': '1',
      'title': 'ใบรับรองด้านแรงงานทางทะเล (MLC)',
      'description': 'ตรวจสอบข้อมูลใบอนุญาต',
      'date': '06 ธันวาคม 2567',
      'view': '535',
      'staff': 'Marine Department Admin (S)'
    },
    {
      'code': '2',
      'title': 'ใบรับรองแรงงานประมง (C188)',
      'description': 'ตรวจสอบข้อมูลใบอนุญาต',
      'date': '06 ธันวาคม 2567',
      'view': '251',
      'staff': 'Marine Department Admin (C)'
    },
    {
      'code': '3',
      'title': 'ใบทะเบียนผู้ประกอบการขนส่งต่อเนื่องหลายรูปแบบ',
      'description': 'ตรวจสอบข้อมูลใบอนุญาต',
      'date': '06 ธันวาคม 2567',
      'view': '311',
      'staff': 'Marine Department Admin (S)'
    },
  ];

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    super.initState();
    // contact = new CheckLicenseListCategoryVertical(
    //   site: "DDPM",
    //   model: service
    //       .post('${service.contactCategoryApi}read', {'skip': 0, 'limit': 100}),
    //   title: "",
    //   url: '${service.contactCategoryApi}read',
    // );
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
              const Expanded(
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
              const SizedBox(width: 30),
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
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 50),
            CheckLicenseListCategoryVertical(
              site: "DDPM",
              model: Future.value(_model),
              title: "",
              url: '${contactCategoryApi}read',
            ),
            // Expanded(
            //   child: contact,
            // ),
          ],
        ),
      ),
    );
  }
}
