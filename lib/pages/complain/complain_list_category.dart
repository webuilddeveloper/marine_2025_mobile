import 'package:flutter/material.dart';

import '../../component/carousel_banner.dart';
import '../../component/carousel_form.dart';
import '../../component/link_url_in.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'complain_list_category_vertical.dart';

class ComplainListCategory extends StatefulWidget {
  ComplainListCategory({super.key, this.title});
  final String? title;
  @override
  _ComplainListCategory createState() => _ComplainListCategory();
}

class _ComplainListCategory extends State<ComplainListCategory> {
  ComplainListCategoryVertical? contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  dynamic _model = [
    {
      'code': '1',
      'title': 'E-mail : marine@md.go.th ; mdlibrary2020@gmail.com'
    },
    {'code': '2', 'title': 'จดหมาย : ถึงสำนัก/ศูนย์/กอง/สาขา/ ของกรม'},
    {
      'code': '3',
      'title': 'ศูนย์รับเรื่องราวร้องทุกข์ของรัฐบาล 1111 (สำนักนายกรัฐมนตรี)',
      'url': 'https://www.traffy.in.th/?page_id=3321'
    },
    {
      'code': '4',
      'title': 'ศูนย์ประสานงานเรื่องราวร้องทุกข์ คมนาคม (กระทรวงคมนาคม)',
      'url': 'http://olap.mot.go.th/webboard/create_question.jsp'
    },
    {
      'code': '5',
      'title': 'การติดต่อด้วยตนเอง : ที่สำนัก/ศูนย์/กอง/สาขา ของกรม',
      'url': ''
    },
    {'code': '6', 'title': 'สายด่วน 1199', 'url': ''},
    {'code': '7', 'title': 'การสำรวจรายกลุ่ม', 'url': ''},
    {
      'code': '8',
      'title': 'สื่อต่างๆ : หนังสือพิมพ์ และสื่อออนไลน์',
      'url': ''
    },
    {
      'code': '9',
      'title':
          'Facebook : กรมเจ้าท่า Marine department , ประชาสัมพันธ์เจ้าท่า กรมเจ้าท่า ,   ข่าวกรมเจ้าท่า (News clippings) สื่อออนไลน์',
      'url': 'https://www.facebook.com/marinesmartmd/'
    },
    {'code': '10', 'title': 'โทรศัพท์หน่วยงาน หมายเลข 0-22331311-8', 'url': ''},
  ];

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureCategoryContact;
  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureCategoryContact =
        post('${contactCategoryApi}read', {'skip': 0, 'limit': 999});

    _futureBanner = post('${contactBannerApi}read', {'skip': 0, 'limit': 50});

    // _controller.addListener(_scrollListener);
    super.initState();
    // contact = new ComplainListCategoryVertical(
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
                  'ร้องเรียน',
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
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'ช่องทาง ศูนย์เครือข่ายประสานและแก้ไขปัญหาตามข้อร้องเรียนของประชาชนฯ',
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                ),
                textAlign: TextAlign.left,
              ),
            ),

            ComplainListCategoryVertical(
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
