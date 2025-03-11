import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  final String _imageProfile = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];
  bool notShowOnDay = false;
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.10),
              blurRadius: 4,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // กระจายปุ่มให้เท่ากัน
          children: [
            Expanded(
              child: _buildTap(
                0,
                'หน้าหลัก',
                icon: 'assets/icons/home_icon.png',
                iconActive: 'assets/icons/home_active_icon.png',
              ),
            ),
            Expanded(
              child: _buildTap(
                1,
                'ปฎิทิน',
                icon: 'assets/icons/calendar_icon.png',
                iconActive: 'assets/icons/calendar_active_icon.png',
              ),
            ),
            Expanded(
              child: _buildTap(
                2,
                'ใบอนุญาต',
                isLicense: true,
              ),
            ),
            Expanded(
              child: _buildTap(
                3,
                'แจ้งเตือน',
                icon: 'assets/icons/noti_icon.png',
                iconActive: 'assets/icons/noti_active_icon.png',
                isNoti: true,
              ),
            ),
            Expanded(
              child: _buildTap(
                4,
                'โปรไฟล์',
                icon: 'assets/icons/profile_icon.png',
                iconActive: 'assets/icons/profile_active_icon.png',
                isNetwork: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int index,
    String title, {
    bool isNetwork = false,
    bool isIconsData = false,
    bool isNoti = false,
    bool isLicense = false,
    String? icon,
    String? iconActive,
  }) {
    Color color = _currentPage == index
        ? const Color(0xFF252120)
        : const Color(0XFFA49E9E);

    return GestureDetector(
      onTap: () {
        debugPrint("Tapped index: $index");
        _onItemTapped(index);
      },
      child: Column(
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
                        height: 30,
                        width: 30,
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
                      alignment: Alignment.center, // ทำให้ Stack อยู่ตรงกลาง
                      clipBehavior: Clip.none, // ป้องกันการขยายตัวผิดปกติ
                      children: [
                        Image.asset(
                          _currentPage == index ? iconActive! : icon!,
                          height: 30,
                          width: 30,
                        ),
                        if (_ListNotiModel.isNotEmpty)
                          const Positioned(
                            top: -2, // ขยับขึ้นเพื่อให้ไม่เกินกรอบ
                            right: -2, // ปรับขอบให้พอดี
                            child: SizedBox(
                              height: 12,
                              width: 12,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFE40000),
                                ),
                              ),
                            ),
                          ),
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
                        ),
        ],
      ),
    );
  }
}
