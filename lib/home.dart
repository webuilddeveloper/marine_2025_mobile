import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_mobile/pages/about_us/about_us_form.dart';
import 'package:marine_mobile/pages/complain/complain_list_category.dart';
import 'package:marine_mobile/pages/license/check_license_list_category.dart';
import 'package:marine_mobile/pages/my_qr_code.dart';
import 'package:marine_mobile/pages/question/question_list.dart';
import 'package:marine_mobile/pages/training_course/training_course_list_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:marine_mobile/component/material/check_avatar.dart';
import 'package:marine_mobile/pages/license/renew_license.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'component/carousel_banner.dart';
import 'component/carousel_form.dart';
import 'component/link_url_in.dart';
import 'login.dart';
import 'pages/blank_page/blank_loading.dart';
import 'pages/blank_page/toast_fail.dart';
import 'pages/knowledge/knowledge_list.dart';
import 'pages/main_popup/dialog_main_popup.dart';
import 'pages/news/news_form.dart';
import 'pages/news/news_list.dart';
import 'shared/api_provider.dart';
import 'package:intl/intl.dart';
// import 'component/carousel_rotation.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, this.changePage});

  Function? changePage;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final storage = const FlutterSecureStorage();
  DateTime? currentBackPressTime;

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureProfile;
  Future<dynamic>? _futureNews;
  Future<dynamic>? _futureMainPopUp;

  String profileCode = '';
  String currentLocation = '-';
  final seen = <String>{};
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false,
      initialRefreshStatus: RefreshStatus.idle,
      initialLoadStatus: LoadStatus.idle);

  LatLng latLng = const LatLng(13.743989326935178, 100.53754006134743);

  int _currentNewsPage = 0;
  final int _newsLimit = 4;
  List<dynamic> _newsList = [];
  bool _hasMoreNews = true;

  @override
  void initState() {
    _newsList = [];
    _read();
    currentBackPressTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Colors.transparent,
      // appBar: _buildHeader(),
      body: WillPopScope(
        child: _buildBackground(),
        onWillPop: confirmExit,
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _buildBackground() {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Color(0xFFFF7900),
      //       Color(0xFFFF7900),
      //       Color(0xFFFFFFFF),
      //     ],
      //     begin: Alignment.topCenter,
      //     // end: new Alignment(1, 0.0),
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        // overScroll.disallowGlow();
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildSmartRefresher(),
    );
  }

  _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      physics: const BouncingScrollPhysics(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView(
        padding: EdgeInsets.zero, // ลบ padding ที่อาจทำให้เกิดช่องว่าง
        children: [
          _buildProfile(),
          const SizedBox(height: 20),
          _buildBanner(),
          _buildService(),
          _buildNews(),
        ],
      ),
    );
  }

  _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CarouselBanner(
        model: _futureBanner!,
        nav: (String path, String action, dynamic model, String code,
            String urlGallery) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
            // launchURL(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarouselForm(
                  code: code,
                  model: model,
                  url: mainBannerApi,
                  urlGallery: bannerGalleryApi,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _buildProfile() {
    return SizedBox(
      height: 310,
      child: Stack(
        children: [
          SizedBox(
            height: 240,
            child: Image.asset(
              'assets/background/bg_home_marine.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            top: 150,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 150,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: FutureBuilder<dynamic>(
                  future: _futureProfile,
                  builder: (context, snapshot) {
                    return _buildProfileContent(snapshot);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return _buildProfileLoading();
    }

    if (snapshot.hasError || snapshot.data == null) {
      return _buildProfileNotFound();
    }

    final data = snapshot.data!;
    final Uri qrUri = Uri(
      scheme: "http",
      host: "gateway.we-builds.com",
      path: "security_information.html",
      queryParameters: data
          .map<String, String?>((k, v) => MapEntry(k.toString(), v?.toString()))
        ..removeWhere((_, v) => v == null),
    );

    return profileCode == data['code']
        ? _buildProfileDetails(data, qrUri)
        : _buildProfileNotFound();
  }

  Widget _buildProfileDetails(dynamic data, Uri qrUri) {
    return Row(
      children: [
        SizedBox(
            height: 60,
            width: 60,
            child: checkAvatar(context, data['imageUrl'])),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
                style: const TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF0C387D),
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C387D), // พื้นหลังสีน้ำเงินเข้ม
                  borderRadius: BorderRadius.circular(50), // มุมโค้งมน
                ),
                child: const Text(
                  'ใบอนุญาตกัปตันเรือ',
                  style: TextStyle(
                    fontSize: 14.0, // ลดขนาดลงเล็กน้อยให้พอดีกรอบ
                    color: Colors
                        .white, // เปลี่ยนสีตัวอักษรเป็นขาวให้ตัดกับพื้นหลัง
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(width: 10),
        const VerticalDivider(thickness: 1, color: Color(0xFFD5E7D7)),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => MyQrCode(model: data))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: qrUri.toString(),
                size: 55,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0C387D),
              ),
              const Text(
                'My QR',
                style: TextStyle(
                    fontSize: 11.0,
                    color: Color(0xFF0C387D),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileNotFound() {
    return _buildProfileMessage('ไม่พบข้อมูล',
        'assets/images/user_not_found.png', const Color(0XFF0C387D));
  }

  Widget _buildProfileLoading() {
    return _buildProfileMessage('กำลังโหลด', 'assets/images/user_not_found.png',
        const Color(0XFF0C387D));
  }

  Widget _buildProfileMessage(String text, String imagePath, Color color) {
    return Row(
      children: [
        Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(imagePath, color: color)),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0XFFD5E7D7)))),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 16.0, color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('assets/icons/qr_code.png', height: 33)),
            const Text('my qrcode',
                style: TextStyle(
                    fontSize: 11.0,
                    color: Color(0XFF59ACD4),
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  _buildService() {
    final List<Map<String, dynamic>> serviceItems = [
      {
        'path': 'assets/icons/icon_menu2.png',
        'title': 'ข่าวสาร',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsList(title: 'ข่าวสาร'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu3.png',
        'title': 'ต่อใบอนุญาต',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RenewLicensePage(),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu4.png',
        'title': 'ตรวจสอบใบอนุญาต',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CheckLicenseListCategory(title: 'ตรวจสอบใบอนุญาต'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu5.png',
        'title': 'คลังความรู้',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const KnowledgeList(title: 'คลังความรู้'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu6.png',
        'title': 'ถามตอบ',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionList(title: 'ถามตอบ'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu7.png',
        'title': 'หลักสูตรอบรม',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TrainingCourseListCategory(title: 'หลักสูตรอบรม'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu8.png',
        'title': 'ร้องเรียน',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComplainListCategory(title: 'ร้องเรียน'),
            ),
          );
        },
      },
      {
        'path': 'assets/icons/icon_menu1.png',
        'title': 'เกี่ยวกับเรา',
        'callBack': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutUsForm(title: 'ติดต่อเรา'),
            ),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Text(
            'บริการสมาชิก',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: (serviceItems.length / 4).ceil() *
              130, // คำนวณความสูงให้พอดีกับจำนวนแถว
          width: MediaQuery.of(context).size.width,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const NeverScrollableScrollPhysics(), // ปิดการ scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 คอลัมน์
              crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
              mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
              childAspectRatio: 1 / 1.2, // ปรับให้พอดีกับข้อความ
            ),
            itemCount: serviceItems.length,
            itemBuilder: (context, index) {
              return _buildServiceIcon(
                path: serviceItems[index]['path'],
                title: serviceItems[index]['title'],
                callBack: serviceItems[index]['callBack'],
              );
            },
          ),
        ),
      ],
    );
  }

  _buildServiceIcon({path, title, callBack}) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: callBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0C387D),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                path,
                height: 40,
                fit: BoxFit.contain,
                width: 40,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 90,
            alignment: Alignment.topCenter,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.95,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
                color: Color(0xFF0C387D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildNews() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'ข่าวประชาสัมพันธ์',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsList(
                        title: 'ข่าวประชาสัมพันธ์',
                      ),
                    ),
                  );
                },
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ดูทั้งหมด',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF27544F),
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 17,
                      color: Color(0XFF27544F),
                    ),
                  ],
                ),
              ),
            ],
          ),
          FutureBuilder<dynamic>(
            future: _futureNews,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                // ลบเงื่อนไขการเช็ค _newsList.isEmpty เพื่อให้ข้อมูลอัพเดทเสมอ
                if (snapshot.data != null && snapshot.data.length > 0) {
                  _newsList = snapshot.data;
                }
                return Center(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: _newsList.length,
                    itemBuilder: (context, index) {
                      var data = _newsList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsForm(
                                url: data['url'] ?? '',
                                code: data['code'] ?? '',
                                model: data ?? '',
                                urlComment: newsApi,
                                urlGallery: newsGalleryApi,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.transparent,
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 4,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(14),
                                      ),
                                      child: data['imageUrl'] != null &&
                                              data['imageUrl']
                                                  .toString()
                                                  .isNotEmpty
                                          ? Image.network(
                                              data['imageUrl'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : BlankLoading(
                                              height: double.infinity,
                                              width: double.infinity,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                    ),
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${data['title']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sarabun',
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return BlankLoading(
                  width: null,
                  height: null,
                );
              } else {
                return const Center(
                  child: Text(
                    'ไม่พบข้อมูล',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  detailNews({icon, value}) {
    return Row(
      children: [
        Image.asset(
          icon,
          fit: BoxFit.contain,
          width: 18,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          value,
          style: const TextStyle(
              fontSize: 12.0,
              fontFamily: 'Kanit',
              // fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ],
    );
  }

  _read() async {
    _getLocation();

    //read profile
    profileCode = (await storage.read(key: 'profileCode2'))!;
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });

      _futureBanner =
          postDio('${mainBannerApi}read', {'limit': 10, 'app': 'marine'});
      _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
      // _futureNews = postDio('${newsApi}read',
      //     {'skip': 0, 'limit': 2, 'category': '20241028102720-101-712'});
      _currentNewsPage = 0;
      _futureNews = postDio('${newsApi}read', {
        'skip': _currentNewsPage * _newsLimit,
        'limit': _newsLimit,
        'app': 'marine',
      });

      // getMainPopUp();
      // _getLocation();
      // print('-------------end response------------');
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _onLoading() async {
    if (!_hasMoreNews) {
      _refreshController.loadComplete();
      return;
    }
    _currentNewsPage++;
    final moreNews = await postDio('${newsApi}read', {
      'skip': _currentNewsPage * _newsLimit,
      'limit': _newsLimit,
      'app': 'marine',
    });
    if (moreNews != null && moreNews.length < _newsLimit) {
      _hasMoreNews = false;
    }
    if (moreNews == null || moreNews.isEmpty) {
      _hasMoreNews = false;
      _refreshController.loadNoData();
      return;
    }
    setState(() {
      if (_newsList.isEmpty) {
        _newsList = moreNews;
      } else {
        _newsList.addAll(moreNews);
      }
    });
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    _currentNewsPage = 0;
    _hasMoreNews = true; // รีเซ็ตค่านี้เพื่อให้สามารถโหลดเพิ่มได้

    try {
      var newsData = await postDio('${newsApi}read', {
        'skip': 0,
        'limit': _newsLimit,
        'app': 'marine',
      });

      setState(() {
        _newsList = newsData ?? []; // ป้องกันกรณี null
        print("รีเฟรชข้อมูลเสร็จสิ้น: ${_newsList.length} รายการ");
      });

      // ตรวจสอบว่ายังมีข้อมูลเพิ่มเติมหรือไม่
      if (newsData == null || newsData.length < _newsLimit) {
        _hasMoreNews = false;
      }
    } catch (e) {
      print("เกิดข้อผิดพลาดในการรีเฟรช: $e");
    }

    _refreshController.refreshCompleted();
  }

  getMainPopUp() async {
    var result =
        await post('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          this.setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp!,
                  type: 'mainPopup',
                ),
              );
            },
          );
        } else {
          this.setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        this.setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp!,
                type: 'mainPopup',
              ),
            );
          },
        );
      }
    }
  }

  _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    // print('------ Position -----' + position.toString());

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude,
      // localeIdentifier: 'th'
    );
    // print('----------' + placemarks.toString());

    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      currentLocation = placemarks.first.administrativeArea!;
    });
  }
}
