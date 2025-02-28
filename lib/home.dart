import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marine_mobile/pages/about_us/about_us_form.dart';
import 'package:marine_mobile/pages/about_us/about_us_form_bk.dart';
import 'package:marine_mobile/pages/complain/complain_list_category.dart';
import 'package:marine_mobile/pages/license/check_license_list_category.dart';
import 'package:marine_mobile/pages/my_qr_code.dart';
import 'package:marine_mobile/pages/question/question_list.dart';
import 'package:marine_mobile/pages/training_course/training_course_list.dart';
import 'package:marine_mobile/pages/training_course/training_course_list_category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:marine_mobile/component/material/check_avatar.dart';
import 'package:marine_mobile/pages/license/renew_license.dart';

import 'component/button_menu_full.dart';
import 'component/carousel_banner.dart';
import 'component/carousel_form.dart';
import 'component/carousel_rotation.dart';
import 'component/link_url_in.dart';
import 'login.dart';
import 'pages/blank_page/blank_loading.dart';
import 'pages/blank_page/toast_fail.dart';
import 'pages/coming_soon.dart';
import 'pages/contact/contact_list_category.dart';
import 'pages/event_calendar/event_calendar_main.dart';
import 'pages/knowledge/knowledge_list.dart';
import 'pages/main_popup/dialog_main_popup.dart';
import 'pages/news/news_form.dart';
import 'pages/news/news_list.dart';
import 'pages/poi/poi_list.dart';
import 'pages/poll/poll_list.dart';
import 'pages/privilege/privilege_main.dart';
import 'shared/api_provider.dart';
import 'package:intl/intl.dart';
import 'component/carousel_rotation.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.changePage});

  Function? changePage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = new FlutterSecureStorage();
  DateTime? currentBackPressTime;

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureProfile;
  Future<dynamic>? _futureNews;
  Future<dynamic>? _futureMenu;
  Future<dynamic>? _futureRotation;
  Future<dynamic>? _futureAboutUs;
  Future<dynamic>? _futureMainPopUp;
  Future<dynamic>? _futureVerifyTicket;

  String profileCode = '';
  String currentLocation = '-';
  final seen = Set<String>();
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  List<dynamic> _dataPolicy = [];
  bool checkDirection = false;

  final RefreshController _refreshController = RefreshController(
      initialRefresh: false,
      initialRefreshStatus: RefreshStatus.idle,
      initialLoadStatus: LoadStatus.idle);

  LatLng latLng = const LatLng(13.743989326935178, 100.53754006134743);

  int _currentNewsPage = 0;
  int _newsLimit = 4;
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

  _buildBackgroundNew() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: const Color(0XFFF3F5F5),
        ),
        Image.asset(
          "assets/images/bg_top.png",
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          // child: _buildMenu(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: _buildNotificationListener(),
          ),
        ),
      ],
    );
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
      // header: WaterDropHeader(
      //   complete: Container(
      //     child: const Text(''),
      //   ),
      //   completeDuration: const Duration(milliseconds: 0),
      // ),
      // footer: CustomFooter(
      //   builder: (context, mode) {
      //     Widget body;
      //     if (mode == LoadStatus.idle) {
      //       body = const Text("pull up load");
      //     } else if (mode == LoadStatus.loading) {
      //       body = const Text("loading");
      //     } else if (mode == LoadStatus.failed) {
      //       body = const Text("Load Failed!Click retry!");
      //     } else if (mode == LoadStatus.canLoading) {
      //       body = const Text("release to load more");
      //     } else {
      //       body = const Text("No more Data");
      //     }
      //     return Container(
      //       height: 55.0,
      //       child: Center(child: body),
      //     );
      //   },
      // ),
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      physics: const BouncingScrollPhysics(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildMenu(context),

      // Column(
      //   children: [
      //     // Container(
      //     //   height: (height * 25) / 100,
      //     //   child:

      //     SizedBox(
      //       height: 1.0,
      //     ),

      //     SizedBox(
      //       height: 1.0,
      //     ),

      // Container(
      //   height: 70.0,
      //   child: CardHorizontal(
      //     title: model[11]['title'] != '' ? model[11]['title'] : '',
      //     imageUrl: model[11]['imageUrl'],
      //     model: _futureMenu,
      //     userData: userData,
      //     subTitle: 'สำหรับสมาชิก',
      //     nav: () {
      //       // Navigator.push(
      //       //   context,
      //       //   MaterialPageRoute(
      //       //     builder: (context) => PrivilegeMain(
      //       //       title: model[11]['title'],
      //       //     ),
      //       //   ),
      //       // );
      //     },
      //   ),
      // ),
      //   ],
      // ),
      // ),
    );
  }

  _buildMenu(context) {
    // return Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   color: Colors.white,
    //   // padding: EdgeInsets.all(15),
    //   padding: EdgeInsets.zero,
    //   child: SingleChildScrollView(
    //     child: ListView(
    //       padding: EdgeInsets.zero,
    //       children: [
    //         _buildProfile(),
    //         _buildService(),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         _buildNews(),
    //         const SizedBox(
    //           height: 100,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return SingleChildScrollView(
      child: Container(
        // color: Color(0XFFF3F5F5),
        color: Colors.white,
        child: Column(
          children: [
            _buildProfile(),
            const SizedBox(height: 20),
            _buildBanner(),
            _buildService(),
            _buildNews(),
          ],
        ),
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
    return Container(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 240,
            child: Image.asset(
              'assets/background/bg_home_marine.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            top: 290,
            // top: 190,
            bottom: 20,
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
            bottom: 20,
            // child: _buildMenu(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                height: 40,
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
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      if (profileCode == snapshot.data['code']) {
                        return Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              // padding: EdgeInsets.only(right: 10),
                              child: checkAvatar(
                                  context, '${snapshot.data['imageUrl']}'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${snapshot.data['firstName'] ?? ''} ${snapshot.data['lastName'] ?? ''}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Color(0xFF0C387D),
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Text(
                                      'นายท้ายเรือ',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        color: Color(0xFF0C387D),
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const VerticalDivider(
                              thickness: 1,
                              endIndent: 0,
                              color: Color(0xFFD5E7D7),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyQrCode(),
                                  ),
                                );
                              },
                              child: Container(
                                // padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  // color: Color(0XFFB03432),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icons/qr_code2.png',
                                      height: 40,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'my qrcode',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Color(0xFF0C387D),
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                padding: const EdgeInsets.only(right: 10),
                                child: Image.asset(
                                  'assets/images/user_not_found.png',
                                  color: const Color(0XFF0C387D),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // color: Colors.red,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Color(0XFFD5E7D7),
                                      ),
                                    ),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ไม่พบข้อมูล',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Color(0XFF0C387D),
                                          fontFamily: 'IBM Plex Mono',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // Text(
                                      //   'นายท้ายเรือ',
                                      //   style: TextStyle(
                                      //     fontSize: 20.0,
                                      //     color: Color(0XFF0C387D),
                                      //     fontFamily: 'IBM Plex Mono',
                                      //     fontWeight: FontWeight.w600,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(
                                      'assets/icons/qr_code.png',
                                      height: 33,
                                    ),
                                  ),
                                  const Text(
                                    'my qrcode',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      color: Color(0XFF59ACD4),
                                      fontFamily: 'IBM Plex Mono',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return BlankLoading();
                    } else {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              padding: const EdgeInsets.only(right: 10),
                              child: Image.asset(
                                'assets/images/user_not_found.png',
                                color: const Color(0XFF0C387D),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // color: Colors.red,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    right: BorderSide(
                                      color: Color(0XFFD5E7D7),
                                    ),
                                  ),
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'กำลังโหลด',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Color(0XFF0C387D),
                                        fontFamily: 'IBM Plex Mono',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    // Text(
                                    //   'นายท้ายเรือ',
                                    //   style: TextStyle(
                                    //     fontSize: 20.0,
                                    //     color: Color(0XFF0C387D),
                                    //     fontFamily: 'IBM Plex Mono',
                                    //     fontWeight: FontWeight.w600,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/icons/qr_code.png',
                                    height: 33,
                                  ),
                                ),
                                const Text(
                                  'my qrcode',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    color: Color(0XFF27544F),
                                    fontFamily: 'IBM Plex Mono',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // _buildProfile() {
  //   return FutureBuilder<dynamic>(
  //     future: _futureProfile,
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       if (snapshot.hasData) {
  //         if (profileCode == snapshot.data['code']) {
  //           return Container(
  //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //             decoration: BoxDecoration(
  //               // color: Colors.white,
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   height: 60,
  //                   width: 60,
  //                   padding: EdgeInsets.only(right: 10),
  //                   child: checkAvatar(context, '${snapshot.data['imageUrl']}'),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     // color: Colors.red,
  //                     // decoration: BoxDecoration(
  //                     //   border: Border(
  //                     //     right: BorderSide(
  //                     //       color: Color(0XFFD5E7D7),
  //                     //     ),
  //                     //   ),
  //                     // ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'สวัสดี',
  //                           style: TextStyle(
  //                             fontSize: 24.0,
  //                             // color: Color(0XFF0C387D),
  //                             fontFamily: 'Kanit',
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                         Text(
  //                           '${snapshot.data['firstName'] ?? ''} ${snapshot.data['lastName'] ?? ''}',
  //                           style: TextStyle(
  //                             fontSize: 15.0,
  //                             // color: Color(0XFF0C387D),
  //                             fontFamily: 'Kanit',
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 10),
  //                 GestureDetector(
  //                   onTap: () {
  //                     widget.changePage(4);
  //                     // Navigator.push(
  //                     //   context,
  //                     //   MaterialPageRoute(
  //                     //     builder: (context) => MyQrCode(),
  //                     //   ),
  //                     // );
  //                   },
  //                   child: Container(
  //                     padding: EdgeInsets.all(10.0),
  //                     decoration: BoxDecoration(
  //                       color: Color(0XFFB03432),
  //                       borderRadius: BorderRadius.circular(12),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Image.asset(
  //                           'assets/icons/qr_code.png',
  //                           height: 33,
  //                         ),
  //                         Text(
  //                           'สแกน',
  //                           style: TextStyle(
  //                             fontSize: 11.0,
  //                             color: Color(0XFFFFFFFF),
  //                             fontFamily: 'Kanit',
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           );
  //         } else {
  //           return Container(
  //             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Row(
  //               children: [
  //                 Container(
  //                   height: 60,
  //                   width: 60,
  //                   padding: EdgeInsets.only(right: 10),
  //                   child: Image.asset(
  //                     'assets/images/user_not_found.png',
  //                     color: Color(0XFF0C387D),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Container(
  //                     // color: Colors.red,
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                         right: BorderSide(
  //                           color: Color(0XFFD5E7D7),
  //                         ),
  //                       ),
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           'ไม่พบข้อมูล',
  //                           style: TextStyle(
  //                             fontSize: 16.0,
  //                             color: Color(0XFF0C387D),
  //                             fontFamily: 'IBM Plex Mono',
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                         // Text(
  //                         //   'นายท้ายเรือ',
  //                         //   style: TextStyle(
  //                         //     fontSize: 20.0,
  //                         //     color: Color(0XFF0C387D),
  //                         //     fontFamily: 'IBM Plex Mono',
  //                         //     fontWeight: FontWeight.w600,
  //                         //   ),
  //                         // ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: 10),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       padding: EdgeInsets.all(10.0),
  //                       child: Image.asset(
  //                         'assets/icons/qr_code.png',
  //                         height: 33,
  //                       ),
  //                     ),
  //                     Text(
  //                       'my qrcode',
  //                       style: TextStyle(
  //                         fontSize: 11.0,
  //                         color: Color(0XFF27544F),
  //                         fontFamily: 'IBM Plex Mono',
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           );
  //         }
  //       } else if (snapshot.hasError) {
  //         return BlankLoading();
  //       } else {
  //         return Container(
  //           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 60,
  //                 width: 60,
  //                 padding: EdgeInsets.only(right: 10),
  //                 child: Image.asset(
  //                   'assets/images/user_not_found.png',
  //                   color: Color(0XFF0C387D),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: Container(
  //                   // color: Colors.red,
  //                   decoration: BoxDecoration(
  //                     border: Border(
  //                       right: BorderSide(
  //                         color: Color(0XFFD5E7D7),
  //                       ),
  //                     ),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'กำลังโหลด',
  //                         style: TextStyle(
  //                           fontSize: 16.0,
  //                           color: Color(0XFF0C387D),
  //                           fontFamily: 'IBM Plex Mono',
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       // Text(
  //                       //   'นายท้ายเรือ',
  //                       //   style: TextStyle(
  //                       //     fontSize: 20.0,
  //                       //     color: Color(0XFF0C387D),
  //                       //     fontFamily: 'IBM Plex Mono',
  //                       //     fontWeight: FontWeight.w600,
  //                       //   ),
  //                       // ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               SizedBox(width: 10),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.all(10.0),
  //                     child: Image.asset(
  //                       'assets/icons/qr_code.png',
  //                       height: 33,
  //                     ),
  //                   ),
  //                   Text(
  //                     'my qrcode',
  //                     style: TextStyle(
  //                       fontSize: 11.0,
  //                       color: Color(0XFF27544F),
  //                       fontFamily: 'IBM Plex Mono',
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }

  _buildService() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'บริการสมาชิก',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              childAspectRatio: 1 / 0.8,
              shrinkWrap: true,
              children: [
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu2.png',
                  title: 'ข่าวสาร',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsList(
                          title: 'ข่าวสาร',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu3.png',
                  title: 'ต่อใบอนุญาต',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RenewLicensePage(),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu4.png',
                  title: 'ตรวจสอบใบอนุญาต',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckLicenseListCategory(
                          title: 'ตรวจสอบใบอนุญาต',
                        ),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu5.png',
                  title: 'คลังความรู้',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KnowledgeList(title: 'คลังความรู้'),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu6.png',
                  title: 'ถามตอบ',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionList(title: 'ถามตอบ'),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu7.png',
                  title: 'หลักสูตรอบรม',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TrainingCourseListCategory(title: 'หลักสูตรอบรม'),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu8.png',
                  title: 'ร้องเรียน',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ComplainListCategory(title: 'ร้องเรียน'),
                      ),
                    );
                  },
                ),
                _buildServiceIcon(
                  path: 'assets/icons/icon_menu1.png',
                  title: 'เกี่ยวกับเรา',
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUsForm(
                          // model: _futureAboutUs,
                          title: 'ติดต่อเรา',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
                child: Container(
                  // padding: EdgeInsets.symmetric(ho: 10.0),
                  // margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
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
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<dynamic>(
            future: _futureNews,
            // builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            //   if (snapshot.hasData) {
            //     return Container(
            //       height: 280,
            //       color: Colors.transparent,
            //       // alignment: Alignment.center,
            //       child: ListView.builder(
            //         physics: ScrollPhysics(),
            //         shrinkWrap: true,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: snapshot.data.length,
            //         itemBuilder: (context, index) {
            //           return GestureDetector(
            //             onTap: () {
            //               Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                   builder: (context) => NewsForm(
            //                     url: newsApi,
            //                     code: snapshot.data[index]['code'],
            //                     model: snapshot.data[index],
            //                     urlComment: newsApi,
            //                     urlGallery: newsGalleryApi,
            //                   ),
            //                 ),
            //               );
            //             },
            //             child: Container(
            //               width: MediaQuery.of(context).size.width * 0.45,
            //               padding:
            //                   EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            //               child: Card(
            //                 elevation: 4,
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(16),
            //                 ),
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     ClipRRect(
            //                       borderRadius: BorderRadius.only(
            //                         topLeft: Radius.circular(16),
            //                         topRight: Radius.circular(16),
            //                       ),
            //                       child:
            //                           snapshot.data[index]['imageUrl'] != null
            //                               ? Image.network(
            //                                   '${snapshot.data[index]['imageUrl']}',
            //                                   fit: BoxFit.cover,
            //                                   width: 180,
            //                                   height: 180,
            //                                 )
            //                               : BlankLoading(
            //                                   height: 180,
            //                                 ),
            //                     ),
            //                     Padding(
            //                       padding: const EdgeInsets.all(12.0),
            //                       child: Text(
            //                         '${snapshot.data[index]['title']}',
            //                         maxLines: 2,
            //                         overflow: TextOverflow.ellipsis,
            //                         style: TextStyle(
            //                             fontFamily: 'Sarabun',
            //                             fontSize: 14.0,
            //                             fontWeight: FontWeight.w400,
            //                             color: Color(0xFF000000)),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),
            //     );
            //   } else if (snapshot.hasError) {
            //     return BlankLoading();
            //   } else {
            //     return const Center(
            //       child: Text(
            //         'ไม่พบข้อมูล',
            //         style: TextStyle(
            //           fontSize: 20.0,
            //           fontFamily: 'Kanit',
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     );
            //   }
            // },
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                print("กำลังรับข้อมูลจาก FutureBuilder");
                if (_newsList.isEmpty) {
                  _newsList = snapshot.data;
                  print("รับข้อมูล ${_newsList.length} รายการ");
                }

                return Center(
                  child: Container(
                    child: Wrap(
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: _newsList.map<Widget>(
                        (data) {
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
                              width: MediaQuery.of(context).size.width * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  const BoxShadow(
                                    color: Colors.transparent,
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      topRight: Radius.circular(14),
                                    ),
                                    // child: Container(
                                    //   decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.only(
                                    //       topLeft: Radius.circular(14),
                                    //       topRight: Radius.circular(14),
                                    //     ),
                                    //     color: Color(0xFFFFFFFF),
                                    //   ),
                                    //   constraints: BoxConstraints(
                                    //     minHeight: 200,
                                    //     maxHeight: 200,
                                    //     minWidth: double.infinity,
                                    //   ),
                                    //   child: data['imageUrl'] != null
                                    //       ? Image.network(
                                    //           '${data['imageUrl']}',
                                    //           fit: BoxFit.contain,
                                    //         )
                                    //       : BlankLoading(
                                    //           height: 200,
                                    //           width: null,
                                    //         ),
                                    // ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(14),
                                        ),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 5,
                                            spreadRadius: 2,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      constraints: const BoxConstraints(
                                        minHeight: 200,
                                        maxHeight: 200,
                                        minWidth: double.infinity,
                                      ),
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
                                                height: 200,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : BlankLoading(
                                                height: 200,
                                                width: null,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
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
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
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
          const SizedBox(
            height: 10,
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

  _buildRotation() {
    return CarouselRotation(
      model: _futureRotation!,
      nav: (String path, String action, dynamic model, String code) {
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
    );
  }

  _buildPrivilegeMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[7]['title'] != ''
                  ? snapshot.data[7]['title']
                  : '',
              imageUrl: snapshot.data[7]['imageUrl'],
              model: _futureMenu!,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivilegeMain(
                      title: snapshot.data[7]['title'],
                      fromPolicy: false,
                    ),
                  ),
                );
                // if (!checkDirection) {
                //   _showDialogDirection();
                // } else if (_dataPolicy.length > 0) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PolicyPrivilege(
                //         title: snapshot.data[4]['title'],
                //         username: userData.username,
                //         fromPolicy: true,
                //       ),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PrivilegeMain(
                //         title: snapshot.data[7]['title'],
                //         fromPolicy: false,
                //       ),
                //     ),
                //   );
                // }
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildContactMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[6]['title'] != ''
                  ? snapshot.data[6]['title']
                  : '',
              imageUrl: snapshot.data[6]['imageUrl'],
              model: _futureMenu!,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactListCategory(
                      title: snapshot.data[6]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ContactListCategory(
                //         title: snapshot.data[6]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );

    ;
  }

  _buildPoiMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[8]['title'] != ''
                  ? snapshot.data[8]['title']
                  : '',
              imageUrl: snapshot.data[8]['imageUrl'],
              model: _futureMenu!,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoiList(
                      title: snapshot.data[8]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PoiList(
                //         title: snapshot.data[8]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildPollMenu() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[9]['title'] != ''
                  ? snapshot.data[9]['title']
                  : '',
              imageUrl: snapshot.data[9]['imageUrl'],
              model: _futureMenu!,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollList(
                      title: snapshot.data[9]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PollList(
                //         title: snapshot.data[9]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildFooter() {
    return Container(
      // height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      child: Image.asset(
        'assets/background/background_mics_webuilds.png',
        fit: BoxFit.cover,
      ),
    );
  }

  _read() async {
    // print('-------------start response------------');

    _getLocation();

    //read profile
    profileCode = (await storage.read(key: 'profileCode2'))!;
    if (profileCode != '' && profileCode != null) {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
      _futureMenu = postDio('${menuApi}read', {'limit': 10});
      _futureBanner = postDio('${mainBannerApi}read', {'limit': 10});
      _futureRotation = postDio('${mainRotationApi}read', {'limit': 10});
      _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
      _futureAboutUs = postDio('${aboutUsApi}read', {});
      _futureNews =
          postDio('${newsApi}read', {'skip': 0, 'limit': 2, 'app': 'marine'});

      _futureVerifyTicket = postDio(getNotpaidTicketListApi,
          {"createBy": "createBy", "updateBy": "updateBy"});
      // getMainPopUp();
      // _getLocation();
      // print('-------------end response------------');
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
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

  // void _onRefresh() async {
  //   // getCurrentUserData();
  //   _read();

  //   // if failed,use refreshFailed()
  //   _refreshController.refreshCompleted();
  //   // _refreshController.loadComplete();
  // }

  // void _onLoading() async {
  //   await Future.delayed(const Duration(milliseconds: 1000));
  //   _refreshController.loadComplete();
  // }
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
    print("เริ่มรีเฟรช");
    _currentNewsPage = 0;
    _newsList = [];

    try {
      var newsData = await postDio('${newsApi}read', {
        'skip': 0,
        'limit': _newsLimit,
        'app': 'marine',
      });

      setState(() {
        _newsList = newsData;
        print("รีเฟรชข้อมูลเสร็จสิ้น: ${_newsList.length} รายการ");
      });
    } catch (e) {
      print("เกิดข้อผิดพลาดในการรีเฟรช: $e");
    }

    _refreshController.refreshCompleted();
    _hasMoreNews = true;
  }

  _getLocation() async {
    print('currentLocation');
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
