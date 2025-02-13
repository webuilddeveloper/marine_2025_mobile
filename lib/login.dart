import 'dart:async';
import 'dart:convert';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:weconnectsecurity/menu.dart';
// import 'package:weconnectsecurity/shared/google.dart';
// import 'package:weconnectsecurity/shared/line.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:weconnectsecurity/models/user.dart';
// import 'package:weconnectsecurity/pages/auth/register.dart';
import 'dart:io';
// import 'package:weconnectsecurity/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:weconnectsecurity/widget/text_field.dart';
// import 'home_v2.dart';
// import 'pages/auth/forgot_password.dart';
import 'menu.dart';
import 'models/user.dart';
import 'pages/auth/forgot_password.dart';
import 'pages/auth/register.dart';
import 'shared/api_provider.dart';
import 'shared/apple_firebase.dart';
import 'shared/facebook_firebase.dart';
import 'shared/google_firebase.dart';
import 'shared/line.dart';
import 'widget/text_field.dart';

DateTime now = new DateTime.now();
void main() {
  // Intl.defaultLocale = 'th';

  // runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title});
  final String? title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = new FlutterSecureStorage();

  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl;
  late String _category;
  late String _prefixName;
  late String _firstName;
  late String _lastName;

  late Map userProfile;
  bool _isOnlyWebLogin = false;

  DataUser? dataUser;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      _username = "";
      _password = "";
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _category = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    // checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () {
          loginWithGuest();
        },
        child: new Text(
          'เข้าสู่ระบบ',
          style: new TextStyle(
            fontSize: 18.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: Image.asset(
                'assets/splash_screen_marine.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 150,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    child: Container(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Row(
                                children: <Widget>[
                                  Text(
                                    'เข้าสู่ระบบ',
                                    style: TextStyle(
                                      fontSize: 18.00,
                                      fontFamily: 'Sarabun',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Text(
                                  //   ' (สำหรับสมาชิก)',
                                  //   style: TextStyle(
                                  //     fontSize: 15.00,
                                  //     fontFamily: 'Sarabun',
                                  //     fontWeight: FontWeight.w100,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              labelTextField(
                                'ชื่อผู้ใช้งาน',
                                Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.00,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              textField(
                                txtUsername,
                                null,
                                'ชื่อผู้ใช้งาน',
                                'ชื่อผู้ใช้งาน',
                                true,
                                false,
                              ),
                              SizedBox(height: 15.0),
                              labelTextField(
                                'รหัสผ่าน',
                                Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                  size: 20.00,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              textField(
                                txtPassword,
                                null,
                                'รหัสผ่าน',
                                'รหัสผ่าน',
                                true,
                                true,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              loginButon,
                              const SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "ลืมรหัสผ่าน",
                                      style: TextStyle(
                                        fontSize: 12.00,
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '|',
                                    style: TextStyle(
                                      fontSize: 15.00,
                                      fontFamily: 'Sarabun',
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new RegisterPage(
                                            username: "",
                                            password: "",
                                            facebookID: "",
                                            appleID: "",
                                            googleID: "",
                                            lineID: "",
                                            email: "",
                                            imageUrl: "",
                                            category: "guest",
                                            prefixName: "",
                                            firstName: "",
                                            lastName: "",
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "สมัครสมาชิก",
                                      style: TextStyle(
                                        fontSize: 12.00,
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 14.00,
                                      fontFamily: 'Sarabun',
                                    ),
                                  ),
                                  Text(
                                    ' หรือเข้าสู่ระบบโดย ',
                                    style: TextStyle(
                                      fontSize: 14.00,
                                      fontFamily: 'Sarabun',
                                      // color: Color(0xFFFF7514),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 14.00,
                                      fontFamily: 'Sarabun',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  if (Platform.isIOS)
                                    new Container(
                                      alignment: new FractionalOffset(0.5, 0.5),
                                      height: 50.0,
                                      width: 50.0,
                                      child: new IconButton(
                                        onPressed: () async {
                                          _loginApple();
                                        },
                                        icon: new Image.asset(
                                          "assets/logo/socials/apple.png",
                                        ),
                                        padding: new EdgeInsets.all(5.0),
                                      ),
                                    ),
                                  new Container(
                                    alignment: new FractionalOffset(0.5, 0.5),
                                    height: 50.0,
                                    width: 50.0,
                                    child: new IconButton(
                                      onPressed: () async {
                                        _loginFacebook();
                                      },
                                      icon: new Image.asset(
                                        "assets/logo/socials/Group379.png",
                                      ),
                                      padding: new EdgeInsets.all(5.0),
                                    ),
                                  ),
                                  new Container(
                                    alignment: new FractionalOffset(0.5, 0.5),
                                    height: 50.0,
                                    width: 50.0,
                                    child: new IconButton(
                                      onPressed: () async {
                                        _loginGoogle();
                                      },
                                      icon: new Image.asset(
                                        "assets/logo/socials/Group380.png",
                                      ),
                                      padding: new EdgeInsets.all(5.0),
                                    ),
                                  ),
                                  new Container(
                                    alignment: new FractionalOffset(0.5, 0.5),
                                    height: 50.0,
                                    width: 50.0,
                                    child: new IconButton(
                                      onPressed: () async {
                                        var obj = await loginLine();

                                        // print('----- obj -----' + obj.toString());
                                        final idToken = obj.accessToken.idToken;
                                        // print('----- idToken -----' + idToken.toString());
                                        final userEmail = (idToken != null)
                                            ? idToken['email'] != null
                                                ? idToken['email']
                                                : ''
                                            : '';

                                        if (obj != null) {
                                          var model = {
                                            "username": userEmail == ''
                                                ? obj.userProfile!.userId
                                                : userEmail,
                                            "email": userEmail,
                                            "imageUrl":
                                                obj.userProfile!.pictureUrl,
                                            "firstName":
                                                obj.userProfile!.displayName,
                                            "lastName": '',
                                            "lineID": obj.userProfile!.userId
                                          };

                                          Dio dio = new Dio();
                                          var response = await dio.post(
                                            '${server}m/v2/register/line/login',
                                            data: model,
                                          );

                                          // print(response.data['objectData']['code']);
                                          // storage.write(
                                          //   key: 'profileCode2',
                                          //   value: response.data['objectData']['code'],
                                          // );

                                          // storage.write(key: 'profileCategory', value: 'line');

                                          createStorageApp(
                                            model: response.data['objectData'],
                                            category: 'line',
                                          );

                                          if (obj != null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Menu(),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      icon: new Image.asset(
                                        "assets/logo/socials/Group381.png",
                                      ),
                                      padding: new EdgeInsets.all(5.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'หากผ่านหน้าจอนี้ไป แสดงว่าคุณยอมรับ',
                            style: TextStyle(
                              fontSize: 13.00,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF707070),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // ignore: deprecated_member_use
                              launch('https://policy.we-builds.com/khubdee');
                            },
                            child: const Text(
                              'นโยบายความเป็นส่วนตัว',
                              style: TextStyle(
                                fontSize: 13.00,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0000FF),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkStatus() async {
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'dataUserLoginDDPM');
    if (value != null && value != '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  //login username / password
  Future<dynamic> login() async {
    if ((_username == null || _username == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: const Text(
            'กรุณากรอกชื่อผู้ใช้',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if ((_password == null || _password == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: const Text(
            'กรุณากรอกรหัสผ่าน',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      String url = _category == 'guest'
          ? 'm/Register/login'
          : 'm/Register/${_category}/login';

      final result = await postLoginRegister(url, {
        'username': _username.toString(),
        'password': _password.toString(),
        'category': _category.toString(),
        'email': _email.toString(),
      });

      if (result.status == 'S' || result.status == 's') {
        await storage.write(
            key: 'dataUserLoginDDPM', value: jsonEncode(result.objectData));
        storage.write(key: 'profileCode2', value: result.objectData!.code);
        storage.write(key: 'username', value: result.objectData!.username);
        storage.write(
            key: 'profileImageUrl', value: result.objectData!.imageUrl);

        storage.write(key: 'idcard', value: result.objectData!.idcard);

        storage.write(key: 'profileCategory', value: 'guest');
        storage.write(
            key: 'profileFirstName', value: result.objectData!.firstName);
        storage.write(
            key: 'profileLastName', value: result.objectData!.lastName);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        if (_category == 'guest') {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                result.message!,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Color(0xFF000070),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        } else {
          register();
        }
      }
    }
  }

  Future<dynamic> register() async {
    final result = await postLoginRegister('m/Register/create', {
      'username': _username,
      'password': _password,
      'category': _category,
      'email': _email,
      'facebookID': _facebookID,
      'appleID': _appleID,
      'googleID': _googleID,
      'lineID': _lineID,
      'imageUrl': _imageUrl,
      'prefixName': _prefixName,
      'firstName': _firstName,
      'lastName': _lastName,
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'birthDay': "",
      'phone': "",
      'countUnit': "[]"
    });

    if (result.status == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result.objectData),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Menu(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            result.message!,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  //login guest
  void loginWithGuest() async {
    setState(() {
      _category = 'guest';
      _username = txtUsername.text;
      _password = txtPassword.text;
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    login();
  }

  TextStyle style = TextStyle(
    fontFamily: 'Sarabun',
    fontSize: 18.0,
  );

  _loginApple() async {
    var obj = await signInWithApple();

    // print(
    //     '----- email ----- ${obj.credential}');
    // print(obj.credential.identityToken[4]);
    // print(obj.credential.identityToken[8]);

    var model = {
      "username": obj.user!.email != null ? obj.user!.email : obj.user!.uid,
      "email": obj.user!.email != null ? obj.user!.email : '',
      "imageUrl": '',
      "firstName": obj.user!.email,
      "lastName": '',
      "appleID": obj.user!.uid
    };

    Dio dio = new Dio();
    var response = await dio.post(
      '${server}m/v2/register/apple/login',
      data: model,
    );

    // print(
    //     '----- code ----- ${response.data['objectData']['code']}');

    createStorageApp(
      model: response.data['objectData'],
      category: 'apple',
    );

    if (obj != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) =>
          //     PermissionRegisterPage(),
          builder: (context) => Menu(),
        ),
      );
    }
  }

  _loginFacebook() async {
    var obj = await signInWithFacebook();
    print('----- Login Facebook ----- ' + obj.toString());
    if (obj != null) {
      var model = {
        "username": obj.user!.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL != null ? obj.user!.photoURL : '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "facebookID": obj.user!.uid
      };

      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/v2/register/facebook/login',
        data: model,
      );

      await storage.write(key: 'categorySocial', value: 'Facebook');
      await storage.write(
        key: 'imageUrlSocial',
        value: obj.user!.photoURL != null ? obj.user!.photoURL : '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'facebook',
      );

      if (obj != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      }
    }
  }

  _loginGoogle() async {
    var obj = await signInWithGoogle();
    // print('----- Login Google ----- ' + obj.toString());
    if (obj != null) {
      var model = {
        "username": obj.user!.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL != null ? obj.user!.photoURL : '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "googleID": obj.user!.uid
      };

      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/v2/register/google/login',
        data: model,
      );

      await storage.write(
        key: 'categorySocial',
        value: 'Google',
      );

      await storage.write(
        key: 'imageUrlSocial',
        value: obj.user!.photoURL ?? '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'google',
      );

      if (obj != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Menu(),
          ),
        );
      }
    }
  }
}
