import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../component/key_search.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'training_course_list_vertical.dart';

class TrainingCourseList extends StatefulWidget {
  TrainingCourseList({
    super.key,
    this.title,
    this.code,
  });

  final String? title;
  final String? code;

  @override
  _TrainingCourseList createState() => _TrainingCourseList();
}

class _TrainingCourseList extends State<TrainingCourseList> {
  TrainingCourseListVertical? contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;
  dynamic _model = [];
  dynamic _tempModel = [
    {
      'code': '1',
      'title': 'หลักสูตรการปฐมพยาบาลเบื้องต้น',
      'titleEN': 'Elementary First Aid',
      'category': '1',
      'imageUrl' : 'https://lc.we-builds.com/lc-document/images/news/6c012ef7-5aea-407a-a6ba-fbe549d6226e/LINE_ALBUM_%E0%B8%9B%E0%B8%90%E0%B8%A1%E0%B8%9E%E0%B8%A2%E0%B8%B2%E0%B8%9A%E0%B8%B2%E0%B8%A5_%E0%B9%92%E0%B9%91%E0%B9%91%E0%B9%90%E0%B9%90%E0%B9%98_0.jpg',
      'qualifications': 'บุคคลทั่วไป ที่มีอายุตั้งแต่ 16 ปีบริบูรณ์ขึ้นไป',
      'fee': '1500',
      'number':'35',
      'day':'2',
      'hourDay':'16',
      'hourTheory':'14',
      'hourPractical':'2'
    },
    {
      'code': '2',
      'title': 'หลักสูตรดำรงชีพในทะเล',
      'titleEN': 'Personal Servival Techniques',
      'category': '1',
      'imageUrl' : 'https://lc.we-builds.com/lc-document/images/news/4861e7a1-eabf-4a8e-847b-30c97f14ba2a/LINE_ALBUM_%E0%B8%94%E0%B8%B3%E0%B8%A3%E0%B8%87%E0%B8%8A%E0%B8%B5%E0%B8%9E%E0%B9%83%E0%B8%99%E0%B8%97%E0%B8%B0%E0%B9%80%E0%B8%A5_%E0%B9%92%E0%B9%91%E0%B9%91%E0%B9%90%E0%B9%90%E0%B9%98_2.jpg',
      'qualifications': 'บุคคลทั่วไป ที่มีอายุตั้งแต่ 16 ปีบริบูรณ์ขึ้นไป',
      'fee': '1200',
      'number':'35',
      'day':'2',
      'hourDay':'14',
      'hourTheory':'12',
      'hourPractical':'2'
    },
    {
      'code': '3',
      'title': 'หลักสูตรการป้องกันและดับไฟ',
      'titleEN': 'Fire Prevention and Fire Fighting',
      'category': '1',
      'imageUrl' : '',
      'qualifications': 'บุคคลทั่วไป ที่มีอายุตั้งแต่ 16 ปีบริบูรณ์ขึ้นไป',
      'fee': '1500',
      'number':'35',
      'day':'2',
      'hourDay':'16',
      'hourTheory':'14',
      'hourPractical':'2'
    },
    {
      'code': '4',
      'title': 'หลักสูตรความเป็นผู้นำและการทำงานเป็นทีม',
      'titleEN': 'Leadership and Teamwork',
      'category': '2',
      'imageUrl' : '',
      'qualifications': '',
      'fee': '',
      'number':'',
      'day':'',
      'hourDay':'',
      'hourTheory':'',
      'hourPractical':''
    },
    {
      'code': '5',
      'title': 'หลักสูตรการเดินเรือด้วยเรดาร์ อาปา ระดับปฏิบัติการ',
      'titleEN':
          'Radar Navigation,Radar Plotting and Use of APRA-Radar Navigation at Operational Level',
      'category': '2',
      'imageUrl' : '',
      'qualifications': '',
      'fee': '',
      'number':'',
      'day':'',
      'hourDay':'',
      'hourTheory':'',
      'hourPractical':''
    },
    {
      'code': '6',
      'title': 'หลักสูตรการบริหารทรัพยากรในห้องเครื่อง',
      'titleEN': 'Engine-Room Resource Management',
      'category': '3',
      'imageUrl' : '',
      'qualifications': '',
      'fee': '',
      'number':'',
      'day':'',
      'hourDay':'',
      'hourTheory':'',
      'hourPractical':''
    },
    {
      'code': '7',
      'title': 'หลักสูตรลูกเรือเข้ายามฝ่ายช่างกล',
      'titleEN': 'Rating Forming Part a Engineering Watch III/4',
      'category': '3',
      'imageUrl' : '',
      'qualifications': '',
      'fee': '',
      'number':'',
      'day':'',
      'hourDay':'',
      'hourTheory':'',
      'hourPractical':''
    },
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<dynamic>? _futureContact;

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

    // _futureContact = post('${contactApi}read',
    //     {'skip': 0, 'limit': _limit, 'category': widget.code});

    _model = _tempModel.where((i) => i['category'] == widget.code).toList();

    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _model = _tempModel
          .where((i) =>
              i['category'] == widget.code &&
              (i['title']?.toString().toLowerCase() ?? "")
                  .contains(keySearch!.toLowerCase()))
          .toList();
      contact = new TrainingCourseListVertical(
        site: "DDPM",
        model: Future.value(_model),
        title: "",
        url: '${contactApi}read',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              // SubHeader(th: widget.title, en: ""),
              SizedBox(height: 10),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      _model = _tempModel
                          .where((i) =>
                              i['category'] == widget.code &&
                              (i['title']?.toString().toLowerCase() ?? "")
                                  .contains(keySearch!.toLowerCase()))
                          .toList();
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              // CategorySelector(
              //   model: service.post(
              //     '${service.contactCategoryApi}read',
              //     {'skip': 0, 'limit': 100},
              //   ),
              //   onChange: (String val) {
              //     setState(() => {
              //           contact = new TrainingCourseListCategoryVertical(
              //             site: 'DDPM',
              //             model: service.post(
              //                 '${service.contactCategoryApi}read',
              //                 {'skip': 0, 'limit': 10, "category": val}),
              //             title: '',
              //             url: '${service.contactCategoryApi}read',
              //             // urlGallery: '${service.contactGalleryApi}',
              //           ),
              //         });
              //   },
              // ),
              TrainingCourseListVertical(
                site: "DDPM",
                model: Future.value(_model),
                title: "",
                url: '${contactApi}read',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
