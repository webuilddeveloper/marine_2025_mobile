import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:marine_mobile/pages/my_qr_code.dart';

import 'component/material/check_avatar.dart';
import 'home.dart';
import 'pages/event_calendar/event_calendar_main.dart';
import 'pages/my_license.dart';
import 'pages/notification/notification_list.dart';
import 'pages/profile/user_information.dart';
import 'shared/api_provider.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, this.pageIndex});
  final int? pageIndex;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  DateTime? currentBackPressTime;
  dynamic futureNotificationTire;
  int notiCount = 0;
  int _currentPage = 0;
  String _profileCode = '';
  String _imageProfile = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];
  bool notShowOnDay = false;
  int _currentBanner = 0;
  List<dynamic> _ListNotiModel = [];

  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    // _callRead();
    _callReadNoti();
    pages = <Widget>[
      HomePage(changePage: _changePage),
      EventCalendarMain(
        title: 'ปฏิทินกิจกรรม',
      ),
      MyLicense(changePage: _changePage),
      NotificationList(
        title: 'แจ้งเตือน',
      ),
      UserInformationPage(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _callReadNoti() async {
    postDio(
      '${notificationApi}read',
      {'skip': 0, 'limit': 1},
    ).then(
      (value) async => {
        setState(
          () {
            _ListNotiModel = value;
            print('>>>>>>>>>> ${_ListNotiModel.length}');
          },
        )
      },
    );
  }

  _changePage(index) {
    setState(() {
      _currentPage = index;
    });

    if (index == 0) {
      _callRead();
    }
  }

  onSetPage() {
    setState(() {
      _currentPage = widget.pageIndex ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _currentPage == 0) {
        _callRead();
      }

      _currentPage = index;
    });
  }

  _callRead() async {
    // var img = await DCCProvider.getImageProfile();
    // _readNotiCount();
    // setState(() => _imageProfile = img);
    // setState(() {
    //   if (_profileCode != '') {
    //     pages[4] = profilePage;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E1E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(
            index: _currentPage,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'กดอีกครั้งเพื่อออก',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBottomNavBar() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        height: 66 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).custom.f7cafce,
          //     Theme.of(context).custom.f796dc3
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.10),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            // Text(_ListNotiModel.length.toString()),
            _buildTap(
              0,
              'หน้าหลัก',
              icon: 'assets/icons/home_icon.png',
              iconActive: 'assets/icons/home_active_icon.png',
            ),
            _buildTap(
              1,
              'ปฎิทิน',
              icon: 'assets/icons/calendar_icon.png',
              iconActive: 'assets/icons/calendar_active_icon.png',
            ),
            _buildTap(
              2,
              'ใบอนุญาต',
              isLicense: true,
            ),
            _buildTap(3, 'แจ้งเตือน',
                icon: 'assets/icons/noti_icon.png',
                iconActive: 'assets/icons/noti_active_icon.png',
                isNoti: true),
            _buildTap(4, 'โปรไฟล์',
                icon: 'assets/icons/profile_icon.png',
                iconActive: 'assets/icons/profile_active_icon.png',
                isNetwork: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int? index,
    String title, {
    bool isNetwork = false,
    bool isIconsData = false,
    bool isNoti = false,
    bool isLicense = false,
    String? icon,
    String? iconActive,
    Key? key,
  }) {
    Color color = Color(0XFFA49E9E);
    if (_currentPage == index) {
      color = Color(0xFF252120);
    }

    return Flexible(
      key: key,
      flex: 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            // radius: 60,
            // splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
            onTap: () {
              _onItemTapped(index!);
              // postTrackClick("แท็บ$title");
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              // padding: EdgeInsets.all(10),
              // margin: EdgeInsets.all(10),
              decoration: _currentPage == index
                  ? BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFFFFF).withOpacity(0.50),
                          // spreadRadius: 0,
                          // blurRadius: 0,
                          // offset:
                          //     const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    )
                  : null,
              // borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isIconsData
                      ? isNetwork
                          ? Image.memory(
                              checkAvatar(context, _imageProfile),
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                              errorBuilder: (_, __, ___) => Image.asset(
                                "assets/images/profile_menu.png",
                                fit: BoxFit.fill,
                              ),
                            )
                          : Image.asset(
                              'assets/images/profile_menu.png',
                              height: 30,
                              width: 30,
                              color: color,
                            )
                      : isNoti
                          ? Stack(
                              children: [
                                Image.asset(
                                  // _currentPage == index ? iconActive : icon,
                                  _currentPage == index ? iconActive! : icon!,
                                  height: 30,
                                  width: 30,
                                  // color: color,
                                ),
                                _ListNotiModel.isNotEmpty
                                    ? Positioned(
                                        top: 0,
                                        right: 3,
                                        child: Container(
                                          height: 10,
                                          // height: 226,
                                          width: 10,
                                          child: Container(
                                            // alignment: Alignment.topCenter,
                                            // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFFE40000)),
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            )
                          : isLicense
                              ? Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0C387D),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Image.asset(
                                    'assets/icons/icon_license.png',
                                    height: 30,
                                    fit: BoxFit.contain,
                                    width: 30,
                                  ),
                                )
                              : Image.asset(
                                  _currentPage == index ? iconActive! : icon!,
                                  height: 30,
                                  width: 30,
                                  // color: color,
                                ),
                  // Text(
                  //   title,
                  //   style: TextStyle(
                  //     fontSize: 8.0,
                  //     fontFamily: 'Kanit',
                  //     fontWeight: FontWeight.w400,
                  //     color: color,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
