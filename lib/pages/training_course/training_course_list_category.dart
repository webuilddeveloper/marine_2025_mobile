import 'package:flutter/material.dart';

import '../../component/carousel_banner.dart';
import '../../component/carousel_form.dart';
import '../../component/link_url_in.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'training_course_list_category_vertical.dart';

class TrainingCourseListCategory extends StatefulWidget {
  TrainingCourseListCategory({super.key, this.title});
  final String? title;
  @override
  _TrainingCourseListCategory createState() => _TrainingCourseListCategory();
}

class _TrainingCourseListCategory extends State<TrainingCourseListCategory> {
  TrainingCourseListCategoryVertical? contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  dynamic _model = [
    {'code': '1', 'title': 'กลุ่มหลักสูตรพื้นฐานคนประจำเรือ'},
    {
      'code': '2',
      'title': 'กลุ่มหลักสูตรด้านการเดินเรือและการเรือและภาวะความเป็นผู้นำ'
    },
    {'code': '3', 'title': 'กลุ่มหลักสูตรด้านช่างกล'},
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
    // contact = new TrainingCourseListCategoryVertical(
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
                  'หลักสูตรอบรม',
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
            TrainingCourseListCategoryVertical(
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
