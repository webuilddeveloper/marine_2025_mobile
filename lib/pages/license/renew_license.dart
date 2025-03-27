import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as datatTimePicker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marine_mobile/pages/license/renew_license_detail.dart';

import '../../shared/api_provider.dart';
import '../../widget/text_form_field.dart';
import '../blank_page/dialog_fail.dart';

class RenewLicensePage extends StatefulWidget {
  @override
  _RenewLicensePageState createState() => _RenewLicensePageState();
}

class _RenewLicensePageState extends State<RenewLicensePage> {
  final storage = new FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedSubDistrict;

  final txtTitle = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtNationality = TextEditingController();
  final txtAge = TextEditingController();
  final txtPhone = TextEditingController();
  final txtDetail = TextEditingController();
  final txtBoatLicense = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();
  final txtDescription = TextEditingController();
  final expDate = TextEditingController();
  final txtBoatName = TextEditingController();

  dynamic itemImage1 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage2 = {"imageUrl": "", "id": "", "imageType": ""};
  dynamic itemImage3 = {"imageUrl": "", "id": "", "imageType": ""};

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  Future<dynamic>? futureModel;

  ScrollController scrollController = new ScrollController();

  XFile? _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  String? _selectedOption;

  final List<String> _options = [
    'บุคคลธรรมดา',
    'ห้างหุ้นส่วนสามัญ',
    'ห้างหุ้นส่วนสามัญซึ่งจดทะเบียน',
    'ห้างหุ้นส่วนจำกัด',
    'บริษัทจำกัด',
    'บริษัทมหาชนจำกัด',
  ];

  @override
  void dispose() {
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
    getProvince();

    super.initState();
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {});
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {});
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {});
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {});
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

  Future<dynamic> submitUpdateUser() async {
    // var province = _selectedProvince != "" && _selectedProvince != null
    //     ? _itemProvince
    //         .where((i) => i["code"] == _selectedProvince)
    //         .first['title']
    //     : "";
    // var tambon = _selectedSubDistrict != "" && _selectedSubDistrict != null
    //     ? _itemSubDistrict
    //         .where((i) => i["code"] == _selectedSubDistrict)
    //         .first['title']
    //     : "";
    // var amphoe = _selectedDistrict != "" && _selectedDistrict != null
    //     ? _itemDistrict
    //         .where((i) => i["code"] == _selectedDistrict)
    //         .first['title']
    //     : "";

    var user = {};
    // user['title'] = txtTitle.text ;
    // user['firstName'] = txtFirstName.text ;
    // user['lastName'] = txtLastName.text ;
    // user['phone'] = txtPhone.text ;
    // user['renewDate'] = DateFormat("dd-MM-yyyy").format(
    //   DateTime(
    //     DateTime.now().year,
    //     DateTime.now().month,
    //     DateTime.now().day,
    //   ),
    // );
    user['expDate'] = DateFormat("dd-MM-yyyy").format(
      DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
    );
    // user['address'] = txtAddress.text ;
    // user['soi'] = txtSoi.text ;
    // user['moo'] = txtMoo.text ;
    // user['road'] = txtRoad.text ;
    // user["tambonCode"] = _selectedSubDistrict ?? '';
    // user["tambon"] = tambon ;
    // user["amphoeCode"] = _selectedDistrict ?? '';
    // user["amphoe"] = amphoe ;
    // user["provinceCode"] = _selectedProvince ?? '';
    // user["province"] = province ;
    // user["postnoCode"] = _selectedPostalCode ?? '';
    // user['phone'] = txtPhone.text ;
    user['description'] = _selectedOption;
    user['boatName'] = txtBoatName.text;
    user['boatLicense'] = txtBoatLicense.text;
    // user['age'] = txtAge.text ;
    // user['nationality'] = txtNationality.text ;
    user['fileBoatLicense'] = itemImage1['imageUrl'];
    user['fileBoatLicenseName'] = itemImage1['imageName'];
    user['fileShipInspection'] = itemImage2['imageUrl'];
    user['fileShipInspectionName'] = itemImage2['imageName'];
    user['fileImageOther'] = itemImage3['imageUrl'];

    // final result = await postObjectData('m/v2/Register/update', user);

    // if (result['status'] == 'S') {
    //   await storage.write(
    //     key: 'dataUserLoginOPEC',
    //     value: jsonEncode(result['objectData']),
    //   );

    //   await storage.write(
    //     key: 'profileImageUrl',
    //     value: _imageUrl,
    //   );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RenewLicenseDetail(model: user),
      ),
    );

    //   return showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: CupertinoAlertDialog(
    //           title: new Text(
    //             'อัพเดตข้อมูลเรียบร้อยแล้ว',
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontFamily: 'Sarabun',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           content: Text(" "),
    //           actions: [
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: new Text(
    //                 "ตกลง",
    //                 style: TextStyle(
    //                   fontSize: 13,
    //                   fontFamily: 'Sarabun',
    //                   color: Color(0xFF9A1120),
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                   MaterialPageRoute(
    //                     builder: (context) => HomePageV2(),
    //                   ),
    //                   (Route<dynamic> route) => false,
    //                 );
    //                 // goBack();
    //                 // Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    //   );
    // } else {
    //   return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return WillPopScope(
    //         onWillPop: () {
    //           return Future.value(false);
    //         },
    //         child: CupertinoAlertDialog(
    //           title: new Text(
    //             'อัพเดตข้อมูลไม่สำเร็จ',
    //             style: TextStyle(
    //               fontSize: 16,
    //               fontFamily: 'Sarabun',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           content: new Text(
    //             result['message'],
    //             style: TextStyle(
    //               fontSize: 13,
    //               fontFamily: 'Sarabun',
    //               color: Colors.black,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //           actions: [
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: new Text(
    //                 "ตกลง",
    //                 style: TextStyle(
    //                   fontSize: 13,
    //                   fontFamily: 'Sarabun',
    //                   color: Color(0xFF9A1120),
    //                   fontWeight: FontWeight.normal,
    //                 ),
    //               ),
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //             ),
    //           ],
    //         ),
    //       );
    //     },
    // );
    // }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginOPEC');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        _selectedProvince = user['provinceCode'] ?? '';
        _selectedDistrict = user['amphoeCode'] ?? '';
        _selectedSubDistrict = user['tambonCode'] ?? '';
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
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

      if (_selectedProvince != '') {
        getProvince();
        getDistrict();
        getSubDistrict();
        getPostalCode();
        // setState(() {
        //   futureModel = getUser();
        // });
      } else {
        getProvince();
        // setState(() {
        //   futureModel = getUser();
        // });
      }
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
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
            fontFamily: 'Sarabun',
          ),
          doneStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
          cancelStyle: TextStyle(
            fontSize: 16.0,
            color: Color(0xFF9A1120),
            fontWeight: FontWeight.normal,
            fontFamily: 'Sarabun',
          ),
        ),
        showTitleActions: true,
        minTime: DateTime(1800, 1, 1),
        maxTime: DateTime(
          DateTime.now().year + 5, // เพิ่ม 5 ปีจากปีปัจจุบัน
          DateTime.now().month,
          DateTime.now().day,
        ), onConfirm: (date) {
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

  contentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 30.0),
            ListTile(
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              leading: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  value: _selectedOption ==
                      'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ',
                  onChanged: (bool? isChecked) {
                    setState(() {
                      if (_selectedOption ==
                          'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ') {
                        _selectedOption = null;
                      } else {
                        _selectedOption =
                            'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ';
                      }
                    });
                  },
                ),
              ),
              title: Text(
                'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ',
                style: TextStyle(fontFamily: 'Kanit'),
              ),
              onTap: () {
                setState(() {
                  if (_selectedOption ==
                      'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ') {
                    _selectedOption = null;
                  } else {
                    _selectedOption = 'ข้าฯ มีความประสงค์ขอต่ออายุใบอนุญาตเรือ';
                  }
                });
              },
            ),
            labelTextFormField('ชื่อเรือ'),
            textFormFieldNoValidator(
              txtBoatName,
              'ชื่อเรือ',
              true,
              false,
            ),
            labelTextFormField('เลขทะเบียนเรือ'),
            textFormFieldNoValidator(
              txtBoatLicense,
              'เลขทะเบียนเรือ',
              true,
              false,
            ),
            labelTextFormField('ซึ่งใบอนุญาตใช้เรือสิ้นอายุในวันที่'),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                // horizontal: 15,
                vertical: 0,
              ),
              child: GestureDetector(
                onTap: () => dialogOpenPickerDate(),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: txtDate,
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 15.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFC5DAFC),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      hintText: 'วัน / เดือน / ปีเกิด',
                      hintStyle: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Kanit',
                        fontSize: 14.0,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28.5),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                      ),
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 10.0,
                      ),
                    ),
                    validator: (model) {
                      if (model!.isEmpty) {
                        return 'กรุณากรอกวันเดือนปีเกิด.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            labelTextFormField('ใบอนุญาตใช้เรือฉบับเดิม'),
            SizedBox(height: 5),
            itemImage1['imageUrl'] != "" && itemImage1['imageUrl'] != null
                ? Row(
                    children: [
                      Container(
                        child: Text(
                          itemImage1['imageName'],
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              color: Color(0xFF0C387D),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () {
                            _imageFromFile('1');
                          },
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Color(0xFF0C387D),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: MaterialButton(
                      onPressed: () {
                        _imageFromFile('1');
                      },
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Color(0xFF0C387D),
                      ),
                    ),
                  ),
            labelTextFormField('ใบสำคัญรับรองการตรวจเรือ (แบบ ตร.20 1ก)'),
            SizedBox(height: 5),
            itemImage2['imageUrl'] != "" && itemImage2['imageUrl'] != null
                ? Row(
                    children: [
                      Container(
                        child: Text(
                          itemImage2['imageName'],
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              color: Color(0xFF0C387D),
                              decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () {
                            _imageFromFile('2');
                          },
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Color(0xFF0C387D),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: MaterialButton(
                      onPressed: () {
                        _imageFromFile('2');
                      },
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Color(0xFF0C387D),
                      ),
                    ),
                  ),
            labelTextFormField('ไฟล์รูปถ่าย'),
            SizedBox(height: 5),
            itemImage3['imageUrl'] != "" && itemImage3['imageUrl'] != null
                ? Row(
                    children: [
                      Image.network(
                        itemImage3['imageUrl'],
                        width: 120,
                        height: 120,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 40,
                        height: 40,
                        child: MaterialButton(
                          onPressed: () {
                            _showPickerImage(context);
                          },
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            Icons.upload_file,
                            size: 40,
                            color: Color(0xFF0C387D),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: MaterialButton(
                      onPressed: () {
                        _showPickerImage(context);
                      },
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Color(0xFF0C387D),
                      ),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Center(
              child: Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 50.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      submitUpdateUser();
                    },
                    child: new Text(
                      'ถัดไป',
                      style: new TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 12.0,
                color: Color(0xFF9A1120),
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
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

  Future<void> requestPermissions() async {
    // สำหรับ Android 13+
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }

    if (await Permission.videos.isDenied) {
      await Permission.videos.request();
    }

    // สำหรับการจัดการไฟล์ทั่วไป
    if (await Permission.manageExternalStorage.isDenied) {
      await Permission.manageExternalStorage.request();
    }
  }

  _imageFromFile(String type) async {
    requestPermissions();

    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    // );

    // if (result != null && result.files.single.path != null) {
    //   setState(() {
    //     _image = XFile(result.files.single.path!);
    //   });
    // }
    _upload(type);
  }

  _imgFromCamera(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    _upload(type);
  }

  _imgFromGallery(String type) async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    _upload(type);
  }

  void _upload(String type) async {
    if (_image == null) return;

    Random random = new Random();
    uploadImage(_image!).then((res) {
      setState(() {
        String fileName = res.split('/').last;
        if (type == "1") {
          itemImage1 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageName': fileName,
          };
        }
        if (type == "2") {
          itemImage2 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageName': fileName,
          };
        }
        if (type == "3") {
          itemImage3 = {
            'imageUrl': res,
            'id': random.nextInt(100),
            'imageName': fileName,
          };
        }
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      'อัลบั้มรูปภาพ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery('3');
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera('3');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  checkBox1() {
    return Center(
      child: SizedBox(
        height: 350,
        child: Column(
          children: _options.map((option) {
            return ListTile(
              leading: Checkbox(
                value: _selectedOption == option,
                onChanged: (bool? isChecked) {
                  setState(() {
                    if (_selectedOption == option) {
                      _selectedOption = null;
                    } else {
                      _selectedOption = option;
                    }
                  });
                },
              ),
              title: Text(
                option,
                style: TextStyle(fontFamily: 'Kanit'),
              ),
              onTap: () {
                setState(() {
                  if (_selectedOption == option) {
                    _selectedOption = null;
                  } else {
                    _selectedOption = option;
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  fieldDate({
    String title = '',
    String value = '',
    String hintText = '',
    TextInputType? textInputType,
    Function? validator,
    Function? onChanged,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      color: Colors.white,
      height: 35,
      // alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              new Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                ),
              ),
              Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: TextFormField(
                controller: controller,
                inputFormatters: inputFormatters,
                textAlign: TextAlign.right,
                keyboardType: textInputType,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                ),
                decoration: new InputDecoration.collapsed(
                  hintText: hintText,
                ),
                validator: (model) {
                  return validator!(model);
                },
                onChanged: (value) => onChanged!(value),
                // initialValue: value,
                // controller: controller,
                // enabled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
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
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ต่ออายุใบอนุญาตใช้เรือ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFF5F8FB),
      body: FutureBuilder<dynamic>(
        future: futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Container(
              color: Colors.white,
              child: dialogFail(context),
            ));
          } else {
            return Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Container(
                    // color: Colors.white,
                    child: contentCard(),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
