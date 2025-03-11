import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marine_mobile/login.dart';
import 'package:marine_mobile/menu.dart';
import 'package:marine_mobile/shared/api_provider.dart';

import 'pages/blank_page/dialog_fail.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:weconnectsecurity/menu.dart';
// import 'package:weconnectsecurity/pages/blank_page/dialog_fail.dart';
// import 'package:weconnectsecurity/shared/api_provider.dart';

// import 'home_v2.dart';
// import 'login.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Future<dynamic> futureModel;

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSplash();
  }

  _callRead() {
    futureModel =
        postDio('${server}m/splash/read', {"code": '20241030113208-998-123'});
    // futureModel = postDio(server + 'm/splash/read', {});
  }

  _callTimer(time) async {
    var duration = Duration(seconds: time);
    return Timer(duration, _callNavigatorPage);
  }

  _callNavigatorPage() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'profileCode2');

    if (value != null && value != '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Menu(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  _buildSplash() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              //if no splash from service is return array length 0
              _callTimer((snapshot.data.length > 0
                      ? int.parse(snapshot.data[0]['timeOut']) / 1000
                      : 0)
                  .round());

              return snapshot.data.length > 0
                  ? Center(
                      child: Image.network(
                        snapshot.data[0]['imageUrl'],
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    )
                  : Container();
            } else if (snapshot.hasError) {
              print('Error in FutureBuilder: ${snapshot.error}');
              return Center(
                child: Container(
                  color: Colors.white,
                  child: dialogFail(context, reloadApp: true),
                ),
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          },
        ),
      ),
    );
  }
}
