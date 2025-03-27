import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as datatTimePicker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import '../../widget/text_form_field.dart';
import '../blank_page/dialog_fail.dart';

class IdentityVerificationPageV2 extends StatefulWidget {
  IdentityVerificationPageV2(
      {super.key, this.fromPolicy, this.checkShowDialog, this.title});

  final bool? fromPolicy;
  final bool? checkShowDialog;
  final String? title;

  @override
  _IdentityVerificationPageV2State createState() =>
      _IdentityVerificationPageV2State();
}

class _IdentityVerificationPageV2State
    extends State<IdentityVerificationPageV2> {
  final storage = new FlutterSecureStorage();

  String? _imageUrl;
  String? status;

  bool reQuireLicense = false;
  bool reQuireIdcard = false;

  final _formKey = GlobalKey<FormState>();

  List<String> _itemPrefixName = ['นาย', 'นาง', 'นางสาว']; // Option 2
  String? _selectedPrefixName;

  List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': 'ไม่ระบุเพศ'}
  ];
  String? _selectedSex;

  List<dynamic> _itemProvince = [];
  String? _selectedProvince;

  List<dynamic> _itemDistrict = [];
  String? _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  String? _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  String? _selectedPostalCode;

  List<dynamic> _itemOrganizationLv0 = [];

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtLicenseNumber = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  Future<dynamic>? futureModel;

  ScrollController scrollController = new ScrollController();

  File? _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  bool openOrganization = false;
  String? _selectedLv0;
  String? _selectedTitleLv0;
  String? _selectedLv1;
  String? _selectedTitleLv1;
  List<dynamic> _itemLv2 = [];
  String? _selectedLv2;
  String? _selectedTitleLv2;
  List<dynamic> _itemLv3 = [];
  String? _selectedLv3;
  String? _selectedTitleLv3;
  List<dynamic> _itemLv4 = [];
  String? _selectedLv4;
  String? _selectedTitleLv4;
  List<dynamic> _itemLv5 = [];
  String? _selectedLv5;
  String? _selectedTitleLv5;
  int totalLv = 0;

  List<dynamic> dataCountUnit = [];

  List<dynamic> dataPolicy = [];

  @override
  void initState() {
    // readStorage();
    getUser();
    // getProvince();
    getOrganizationLv0();

    scrollController = ScrollController();
    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        appBar: header(context, goBack, title: widget.title),
        backgroundColor: const Color(0xFFFFFFFF),
        body: Container(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                child: FutureBuilder<dynamic>(
                  future: futureModel,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasError)
                      return Center(
                        child: Container(
                          color: Colors.white,
                          child: dialogFail(context),
                        ),
                      );
                    else
                      return _buildContentCard();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getPolicy() async {
    final result = await postDio("m/policy/read", {
      "category": "application",
    });
    // if (result['status'] == 'S') {
    if (result['objectData'].length > 0) {
      for (var i in result['objectData']) {
        result['objectData'][i].isActive = "";
        result['objectData'][i].agree = false;
        result['objectData'][i].noAgree = false;
      }
      setState(() {
        dataPolicy = result['objectData'];
      });
    }
    // }
  }

  Future<dynamic> getOrganizationLv0() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv0",
    });
    if (result['status'] == 'S') {
      setState(() {});
    }
  }

  Future<dynamic> getOrganizationLv1() async {
    setState(() {
      _selectedLv1 = "";
      _selectedTitleLv1 = "";
    });

    final result = await postObjectData("organization/category/read", {
      "category": "lv1",
      "lv0": _selectedLv0,
    });

    if (result['status'] == 'S') {
      setState(() {});
    }
  }

  Future<dynamic> getOrganizationLv2() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv2",
      "lv1": _selectedLv1,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv2 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv3() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv3",
      "lv2": _selectedLv2,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv3 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv4() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv4",
      "lv3": _selectedLv3,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv4 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv5() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv5",
      "lv4": _selectedLv4,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv5 = result['objectData'];
      });
    }
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  Future<dynamic> getUser() async {
    var profileCode = await storage.read(key: 'profileCode2');

    if (profileCode != '') {
      // print('-----$profileCode-----');
      final result =
          await postObjectData("m/Register/read", {'code': profileCode});
      // print('-----${result.toString()}-----');
      if (result['status'] == 'S') {
        // await storage.write(
        //   key: 'dataUserLoginOPEC',
        //   value: jsonEncode(result['objectData'][0]),
        // );

        if (result['objectData'][0]['birthDay'] != '') {
          if (isValidDate(result['objectData'][0]['birthDay'])) {
            var date = result['objectData'][0]['birthDay'];
            var year = date.substring(0, 4);
            var month = date.substring(4, 6);
            var day = date.substring(6, 8);
            DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
            setState(() {
              _selectedYear = todayDate.year;
              _selectedMonth = todayDate.month;
              _selectedDay = todayDate.day;
              txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
            });
          }
        }
        setState(() {
          dataCountUnit = result['objectData'][0]['countUnit'] != null
              ? json.decode(result['objectData'][0]['countUnit'])
              : [];
          _imageUrl = result['objectData'][0]['imageUrl'];
          txtFirstName.text = result['objectData'][0]['firstName'];
          txtLastName.text = result['objectData'][0]['lastName'];
          txtEmail.text = result['objectData'][0]['email'];
          txtPhone.text = result['objectData'][0]['phone'];
          _selectedPrefixName = result['objectData'][0]['prefixName'];
          txtPhone.text = result['objectData'][0]['phone'];
          txtUsername.text = result['objectData'][0]['username'];
          txtIdCard.text = result['objectData'][0]['idcard'];
          txtLineID.text = result['objectData'][0]['lineID'];
          txtOfficerCode.text = result['objectData'][0]['officerCode'];
          txtLicenseNumber.text = result['objectData'][0]['licenseNumber'];
          txtAddress.text = result['objectData'][0]['address'];
          txtMoo.text = result['objectData'][0]['moo'];
          txtSoi.text = result['objectData'][0]['soi'];
          txtRoad.text = result['objectData'][0]['road'];
          txtPrefixName.text = result['objectData'][0]['prefixName'];

          _selectedProvince = result['objectData'][0]['provinceCode'];
          _selectedDistrict = result['objectData'][0]['amphoeCode'];
          _selectedSubDistrict = result['objectData'][0]['tambonCode'];
          _selectedPostalCode = result['objectData'][0]['postnoCode'];
          _selectedSex = result['objectData'][0]['sex'];
          status = result['objectData'][0]['status'];
          reQuireLicense = result['objectData'][0]['reQuireLicense'];
          reQuireIdcard = result['objectData'][0]['reQuireIdcard'];
        });
      }
      if (_selectedProvince != '') {
        getPolicy();
        getProvince();
        getDistrict();
        getSubDistrict();
        setState(() {
          futureModel = getPostalCode();
        });
      } else {
        getPolicy();
        setState(() {
          futureModel = getProvince();
        });
      }
    }
  }

  Future<dynamic> submitAddOrganization() async {
    if (dataCountUnit.length > 0) {
      var index = dataCountUnit.indexWhere(
        (c) =>
            c['lv0'] == _selectedLv0 &&
            c['lv1'] == _selectedLv1 &&
            c['lv2'] == _selectedLv2 &&
            c['lv3'] == _selectedLv3 &&
            c['lv4'] == _selectedLv4 &&
            c['lv5'] == _selectedLv5,
      );
      if (index == -1) {
        dataCountUnit.add({
          "lv0": _selectedLv0,
          "titleLv0": _selectedTitleLv0,
          "lv1": _selectedLv1,
          "titleLv1": _selectedTitleLv1,
          "lv2": _selectedLv2,
          "titleLv2": _selectedTitleLv2,
          "lv3": _selectedLv3,
          "titleLv3": _selectedTitleLv3,
          "lv4": _selectedLv4,
          "titleLv4": _selectedTitleLv4,
          "lv5": _selectedLv5,
          "titleLv5": _selectedTitleLv5,
          "status": "V",
        });

        this.setState(() {
          dataCountUnit = dataCountUnit;
          _selectedLv0 = "";
          _selectedTitleLv0 = "";
          _selectedLv1 = "";
          _selectedTitleLv1 = "";
          _selectedLv2 = "";
          _selectedTitleLv2 = "";
          _selectedLv3 = "";
          _selectedTitleLv3 = "";
          _selectedLv4 = "";
          _selectedTitleLv4 = "";
          _selectedLv5 = "";
          _selectedTitleLv5 = "";
          openOrganization = false;
          totalLv = 0;
        });
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'ข้อมูลซ้ำ กรุณาเลือกใหม่',
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: const Text(''),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF9A1120),
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
    } else {
      dataCountUnit.add({
        "lv0": _selectedLv0,
        "titleLv0": _selectedTitleLv0,
        "lv1": _selectedLv1,
        "titleLv1": _selectedTitleLv1,
        "lv2": _selectedLv2,
        "titleLv2": _selectedTitleLv2,
        "lv3": _selectedLv3,
        "titleLv3": _selectedTitleLv3,
        "lv4": _selectedLv4,
        "titleLv4": _selectedTitleLv4,
        "lv5": _selectedLv5,
        "titleLv5": _selectedTitleLv5,
        "status": "V",
      });

      this.setState(() {
        dataCountUnit = dataCountUnit;
        _selectedLv0 = "";
        _selectedTitleLv0 = "";
        _selectedLv1 = "";
        _selectedTitleLv1 = "";
        _selectedLv2 = "";
        _selectedTitleLv2 = "";
        _selectedLv3 = "";
        _selectedTitleLv3 = "";
        _selectedLv4 = "";
        _selectedTitleLv4 = "";
        _selectedLv5 = "";
        _selectedTitleLv5 = "";
        openOrganization = false;
        totalLv = 0;
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    // print('-----dataCountUnit.length-----${dataCountUnit.length}');

    // if (dataCountUnit.length == 0) {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) => new CupertinoAlertDialog(
    //       title: new Text(
    //         'กรุณาเพิ่มหน่วยงานอย่างน้อย 1 หน่วยงาน',
    //         style: TextStyle(
    //           fontSize: 16,
    //           fontFamily: 'Kanit',
    //           color: Colors.black,
    //           fontWeight: FontWeight.normal,
    //         ),
    //       ),
    //       content: Text(''),
    //       actions: [
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           child: new Text(
    //             "ตกลง",
    //             style: TextStyle(
    //               fontSize: 13,
    //               fontFamily: 'Kanit',
    //               color: Color(0xFF9A1120),
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
    var codeLv0 = "";
    var codeLv1 = "";
    var codeLv2 = "";
    var codeLv3 = "";
    var codeLv4 = "";
    var codeLv5 = "";

    // var dataRow = dataCountUnit;
    for (var i in dataCountUnit) {
      if (codeLv0 != "") {
        codeLv0 = codeLv0 + "," + i['lv0'];
      } else {
        codeLv0 = i['lv0'];
      }

      if (codeLv1 != "") {
        codeLv1 = codeLv1 + "," + i['lv1'];
      } else {
        codeLv1 = i['lv1'];
      }

      if (codeLv2 != "") {
        codeLv2 = codeLv2 + "," + i['lv2'];
      } else {
        codeLv2 = i['lv2'];
      }

      if (codeLv3 != "") {
        codeLv3 = codeLv3 + "," + i['lv3'];
      } else {
        codeLv3 = i['lv3'];
      }

      if (codeLv4 != "") {
        codeLv4 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv4 = i['lv4'];
      }
      if (codeLv5 != "") {
        codeLv5 = codeLv4 + "," + i['lv4'];
      } else {
        codeLv5 = i['lv4'];
      }
    }

    dataCountUnit.indexWhere((c) => c['status'] != "A");

    dynamic user = {};
    var profileCode = await storage.read(key: 'profileCode2');
    if (profileCode != '' && profileCode != null) user['code'] = profileCode;
    user['imageUrl'] = _imageUrl;
    // user['prefixName'] = _selectedPrefixName;
    user['prefixName'] = txtPrefixName.text;
    user['firstName'] = txtFirstName.text;
    user['lastName'] = txtLastName.text;
    user['birthDay'] = DateFormat("yyyyMMdd").format(
      DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
    );
    user['phone'] = txtPhone.text;
    user['email'] = txtEmail.text;
    user['sex'] = _selectedSex;
    user['soi'] = txtSoi.text;
    user['address'] = txtAddress.text;
    user['moo'] = txtMoo.text;
    user['road'] = txtRoad.text;
    user['tambonCode'] = _selectedSubDistrict;
    user['tambon'] = '';
    user['amphoeCode'] = _selectedDistrict;
    user['amphoe'] = '';
    user['provinceCode'] = _selectedProvince;
    user['province'] = '';
    user['postnoCode'] = _selectedPostalCode;
    user['postno'] = '';
    user['idcard'] = txtIdCard.text;
    user['countUnit'] = json.encode(dataCountUnit);
    user['lv0'] = codeLv0;
    user['lv1'] = codeLv1;
    user['lv2'] = codeLv2;
    user['lv3'] = codeLv3;
    user['lv4'] = codeLv4;
    // user['lv5'] = codeLv5;
    // user.officerCode = txtOfficerCode.text;
    user['licenseNumber'] = txtLicenseNumber.text;
    // user.linkAccount = user.linkAccount != null ? user.linkAccount : '';
    // // user['status'] = "V";
    user['status'] = status; // index == -1 ? user['status'] : 'V';
    user['updateBy'] = '';
    print('-----user-----${user.toString()}');

    final result =
        await postDioFull('${server}m/v2/Register/verify/update', user);
    print('-----result-----${result.toString()}');

    if (result['status'].toString() == 'E') {
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'ยืนยันตัวตนไม่สำเร็จ',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            result['message'].toString(),
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF9A1120),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                new TextEditingController().clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginOPEC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'];
        txtFirstName.text = user['firstName'];
        txtLastName.text = user['lastName'];
        txtEmail.text = user['email'];
        txtPhone.text = user['phone'];
        txtPrefixName.text = user['prefixName'];
        // _selectedPrefixName = user['prefixName'];
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        // DateTime todayDate = DateTime.parse(user['birthDay']);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }
      // getUser();
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
          padding: const EdgeInsets.all(15), child: _buildContentCard()),
    );
  }

  dialogOpenPickerDate() {
    datatTimePicker.DatePicker.showDatePicker(context,
        theme: const datatTimePicker.DatePickerTheme(
          containerHeight: 210.0,
          itemStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        },
      );
    },
        currentTime: DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
        locale: datatTimePicker.LocaleType.th);
  }

  _buildContentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),
            const Text(
              'ข้อมูลสมาชิก',
              style: TextStyle(
                fontSize: 18.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            labelTextFormFieldRequired('* ', 'คำนำหน้า'),
            textFormFieldEdit(
              txtPrefixName,
              null,
              'คำนำหน้า',
              'คำนำหน้า',
              true,
              false,
              false,
              false,
            ),
            labelTextFormFieldRequired('* ', 'ชื่อ'),
            textFormFieldEdit(
              txtFirstName,
              null,
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
              false,
            ),
            labelTextFormFieldRequired('* ', 'นามสกุล'),
            textFormFieldEdit(
              txtLastName,
              null,
              'นามสกุล',
              'นามสกุล',
              true,
              false,
              false,
              false,
            ),
            labelTextFormFieldRequired('* ', 'เบอร์โทรศัพท์ (10 หลัก)'),
            textFormPhoneFieldEdit(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              true,
            ),
            labelTextFormFieldRequired(
                (reQuireLicense ? '* ' : ''), 'เลขที่ใบอนุญาตฯ'),
            !reQuireLicense
                ? textFormFieldEdit(
                    txtLicenseNumber,
                    null,
                    'เลขที่ใบอนุญาตฯ',
                    'เลขที่ใบอนุญาตฯ',
                    true,
                    false,
                    false,
                    false,
                  )
                : textFormLicenseFieldEdit(
                    txtLicenseNumber,
                    'เลขที่ใบอนุญาตฯ',
                    'เลขที่ใบอนุญาตฯ',
                    true,
                    false,
                  ),
            labelTextFormFieldRequired(
                (reQuireIdcard ? '* ' : ''), 'เลขที่บัตรปชช.'),
            !reQuireIdcard
                ? textFormFieldIsEmptyEdit(
                    txtIdCard,
                    null,
                    'เลขที่บัตรปชช',
                    'เลขที่บัตรปชช',
                    true,
                    false,
                    false,
                    false,
                    false,
                  )
                : textFormIdCardFieldEdit(
                    txtIdCard,
                    'เลขที่บัตรปชช',
                    'เลขที่บัตรปชช',
                    true,
                  ),
            labelTextFormFieldRequired('* ', 'จังหวัด'),
            new Container(
              width: 5000.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              // decoration: BoxDecoration(
              //   color: Color(0xFFC5DAFC),
              //   borderRadius: BorderRadius.circular(
              //     10,
              //   ),
              // ),
              child: (_selectedProvince != '')
                  ? DropdownButtonFormField(
                      decoration: const InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกจังหวัด'
                          : null,
                      hint: const Text(
                        'จังหวัด',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Kanit',
                        ),
                      ),
                      value: _selectedProvince,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        new TextEditingController().clear();
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDistrict = "";
                          _itemDistrict = [];
                          _selectedSubDistrict = "";
                          _itemSubDistrict = [];
                          _selectedPostalCode = "";
                          _itemPostalCode = [];
                          _selectedProvince = newValue.toString();
                        });
                        getDistrict();
                      },
                      items: _itemProvince.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Kanit',
                              color: Color(0xFF1B6CA8),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกจังหวัด'
                          : null,
                      hint: const Text(
                        'จังหวัด',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Kanit',
                        ),
                      ),
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        new TextEditingController().clear();
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDistrict = "";
                          _itemDistrict = [];
                          _selectedSubDistrict = "";
                          _itemSubDistrict = [];
                          _selectedPostalCode = "";
                          _itemPostalCode = [];
                          _selectedProvince = newValue.toString();
                        });
                        getDistrict();
                      },
                      items: _itemProvince.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: const TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Kanit',
                              color: Color(0xFF1B6CA8),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            _buildButtonSave(),
          ],
        ),
      ),
    );
  }

  _buildButtonSave() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFF99722F),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            height: 40,
            onPressed: () {
              final form = _formKey.currentState;
              if (form!.validate()) {
                form.save();
                submitUpdateUser();
              }
            },
            child: new Text(
              'บันทึกข้อมูล',
              style: new TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ),
    );
  }

  dropdownMenuItemHaveData(
      String _selected, List<dynamic> _item, String title) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) => value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: const TextStyle(
          fontSize: 15.00,
          fontFamily: 'Kanit',
        ),
      ),
      value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = newValue.toString();
        });
      },
      items: _item.map((item) {
        return DropdownMenuItem(
          child: new Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              color: Color(
                0xFF9A1120,
              ),
            ),
          ),
          value: item['code'],
        );
      }).toList(),
    );
  }

  dropdownMenuItemNoHaveData(
      String _selected, List<dynamic> _item, String title) {
    return DropdownButtonFormField(
      decoration: const InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) =>
          value == '' || value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: const TextStyle(
          fontSize: 15.00,
          fontFamily: 'Kanit',
        ),
      ),
      // value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = newValue.toString();
        });
      },
      items: _item.map((item) {
        return DropdownMenuItem(
          child: new Text(
            item['title'],
            style: const TextStyle(
              fontSize: 15.00,
              fontFamily: 'Kanit',
              color: Color(
                0xFF9A1120,
              ),
            ),
          ),
          value: item['code'],
        );
      }).toList(),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: const Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 12.0,
                color: const Color(0xFF9A1120),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }
}
