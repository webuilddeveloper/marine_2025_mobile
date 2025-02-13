import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as datatTimePicker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as datatTimePicker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import '../../home_v2.dart';
import '../../component/material/custom_alert_dialog.dart';
import '../../component/material/field_item.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'drivers_info.dart';

class RegisterWithDriverLicense extends StatefulWidget {
  @override
  _RegisterWithDriverLicensePageState createState() =>
      _RegisterWithDriverLicensePageState();
}

class _RegisterWithDriverLicensePageState
    extends State<RegisterWithDriverLicense> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TextEditingController docType = new TextEditingController();
  TextEditingController pltCode = new TextEditingController();
  TextEditingController pltNo = new TextEditingController();
  TextEditingController issDate = new TextEditingController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  Future<dynamic>? futureModel;
  List<dynamic>? _itemdocType = [];
  String? _selecteddocType;

  List<dynamic> _itemPlt = [];
  String? _selectedPlt;

  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    _read();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePageV2(),
        ),
        (Route<dynamic> route) => false,
      ).then((result) {
        return false;
      }),
      child: Scaffold(
        appBar: header(context, () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => HomePageV2(),
            ),
            (Route<dynamic> route) => false,
          );
          // Navigator.pop(context, false);
        }, title: 'ตรวจสอบข้อมูลใบอนุญาตขับรถ'),
        backgroundColor: const Color(0xFFF5F8FB),
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: screen(),
        ),
      ),
    );
  }

  screen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 240,
            color: const Color(0xFFDFCDCA),
            child: Column(
              children: [
                const SizedBox(
                  height: 34,
                ),
                Expanded(
                  child: Container(
                    child: Image.asset(
                      'assets/ex_id_card.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 34,
                )
              ],
            ),
          ),
          fieldDropdown(
            title: 'ประเภทเอกสาร',
            hintText: 'กรอกประเภทเอกสาร',
            controller: docType,
            itemsData: _itemdocType!,
            selectData: _selecteddocType!,
            typeDropdown: "docType",
          ),
          fieldDropdown(
            title: 'ประเภทใบอนุญาต',
            hintText: 'ประเภทใบอนุญาต',
            controller: pltCode,
            itemsData: _itemPlt,
            selectData: _selectedPlt!,
            typeDropdown: "Plt",
          ),
          fieldItem(
            title: 'เลขที่ใบอนุญาต',
            hintText: 'กรอกเลขที่ใบอนุญาต',
            controller: pltNo,
            inputFormatters: [
              // fixflutter2 new WhitelistingTextInputFormatter(RegExp("[0-9]")),
              // new LengthLimitingTextInputFormatter(13),
            ],
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              dialogOpenPickerDate();
            },
            child: AbsorbPointer(
              child: fieldDate(
                title: 'วันที่ออกใบอนุญาต',
                hintText: 'วันที่ออกใบอนุญาต',
                controller: issDate,
              ),
            ),
          ),
          // fieldItem(
          //   title: 'วันที่ออกใบอนุญาต',
          //   hintText: 'วันที่ออกใบอนุญาต',
          //   controller: lastName,
          // ),
          // // fieldItem(
          // //   title: 'วันหมดอายุ',
          // //   hintText: 'กรอกวันหมดอายุ',
          // //   controller: laserID,
          // //   inputFormatters: [
          // //     new WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
          // //     new UpperCaseTextFormatter(),
          // //     new LengthLimitingTextInputFormatter(12),
          // //   ],
          // //   // textInputType: TextInputType.numberWithOptions(),
          // // ),
          const SizedBox(
            height: 160,
          ),
          InkWell(
            onTap: () {
              dialogVerification();
            },
            child: Container(
              height: 45,
              width: 200,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFF9C0000),
              ),
              child: const Text(
                'ตกลง',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> dialogVerification() async {
    if (pltNo.text == '' ||
        issDate.text == '' ||
        _selecteddocType == null ||
        _selectedPlt == null) {
      // toastFail(context, text: 'กรุณากรอกข้อมูลให้ครบถ้วน');
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CustomAlertDialog(
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                width: 325,
                height: 300,
                // width: MediaQuery.of(context).size.width / 1.3,
                // height: MediaQuery.of(context).size.height / 2.5,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: const Color(0xFFFFFF),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        'assets/cross_ quadrangle.png',
                        height: 50,
                      ),
                      // Icon(
                      //   Icons.check_circle_outline_outlined,
                      //   color: Color(0xFF5AAC68),
                      //   size: 60,
                      // ),
                      const SizedBox(height: 10),
                      const Text(
                        'กรุณากรอกข้อมูลให้ครบถ้วน',
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 15,
                          // color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 15,
                          color: Color(0xFF4D4D4D),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: const Text(
                            'ลองใหม่อีกครั้ง',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF4D4D4D),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                          Navigator.pop(context, false);
                        },
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: const Text(
                            'ยกเลิก',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF9C0000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // child: //Contents here
              ),
            ),
          );
        },
      );
    } else {
      String? profileCode = await storage.read(key: 'profileCode2');
      String? idcard = await storage.read(key: 'idcard');
      if (profileCode != '' && profileCode != null) {
        final result = await postObjectDataMW(
            serverMW + 'DLTLC/insertDriverLicenceByDocNo', {
          'code': profileCode,
          'createBy': profileCode,
          'updateBy': profileCode,
          'pltNo': pltNo.text,
          'issDate': DateFormat("yyyyMMdd").format(
            DateTime(
              _selectedYear,
              _selectedMonth,
              _selectedDay,
            ),
          ),
          'docType': _selecteddocType,
          'pltCode': _selectedPlt,
          'docNo': idcard,
          'reqDocNo': idcard
        });
        if (result['status'] == 'S') {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CustomAlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  content: Container(
                    width: 325,
                    height: 235,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    // height: MediaQuery.of(context).size.height / 2.5,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            'assets/check_circle.png',
                            height: 50,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_outlined,
                          //   color: Color(0xFF5AAC68),
                          //   size: 60,
                          // ),
                          const SizedBox(height: 10),
                          const Text(
                            'ยืนยันตัวตนสำเร็จ',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              // color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DriversInfo(),
                                ),
                              );
                            },
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text(
                                'ดูใบอนุญาตขับรถของฉัน',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => HomePageV2(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF9C0000),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                'ไปหน้าหลัก',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    // child: //Contents here
                  ),
                ),
              );
            },
          );
        } else {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CustomAlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  content: Container(
                    width: 325,
                    height: 300,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    // height: MediaQuery.of(context).size.height / 2.5,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: const Color(0xFFFFFF),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Image.asset(
                            'assets/cross_ quadrangle.png',
                            height: 50,
                          ),
                          // Icon(
                          //   Icons.check_circle_outline_outlined,
                          //   color: Color(0xFF5AAC68),
                          //   size: 60,
                          // ),
                          const SizedBox(height: 10),
                          const Text(
                            'เชื่อมต่อใบอนุญาตขับรถไม่สำเร็จ',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              // color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                            style: TextStyle(
                              fontFamily: 'Sarabun',
                              fontSize: 15,
                              color: Color(0xFF4D4D4D),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                'ลองใหม่อีกครั้ง',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF4D4D4D),
                                ),
                              ),
                            ),
                          ),
                          Container(height: 0.5, color: const Color(0xFFcfcfcf)),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context, false);
                              Navigator.pop(context, false);
                            },
                            child: Container(
                              height: 45,
                              alignment: Alignment.center,
                              child: const Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  fontFamily: 'Sarabun',
                                  fontSize: 15,
                                  color: Color(0xFF9C0000),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // child: //Contents here
                  ),
                ),
              );
            },
          );
        }
      }
    }
  }

  fieldDropdown({
    String title = '',
    String value = '',
    String hintText = '',
    String typeDropdown = '',
    List<dynamic>? itemsData,
    String? selectData,
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              new Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                ),
              ),
              const Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: DropdownButtonFormField(
                items: itemsData!.map((item) {
                  return DropdownMenuItem(
                    child: new Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 15.00,
                        fontFamily: 'Kanit',
                        color: Color(
                          0xFF000070,
                        ),
                      ),
                    ),
                    value: item['code'],
                  );
                }).toList(),
                value: selectData,
                onChanged: (value) {
                  setState(() {
                    if (typeDropdown == "docType") _selecteddocType = value.toString();
                    if (typeDropdown == "Plt") _selectedPlt = value.toString();
                  });
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0.0),
                  hintText: 'กรุณาเลือก',
                  hintStyle: TextStyle(
                    fontSize: 11.00,
                    fontFamily: 'Sarabun',
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _read() {
    setState(() {
      var now = new DateTime.now();
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    getdocType();
    getPlt();
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
        maxTime: DateTime(year, month, day), onConfirm: (date) {
      setState(
        () {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          issDate.value = TextEditingValue(
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              new Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 13.0,
                ),
              ),
              const Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          const SizedBox(
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
                style: const TextStyle(
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

  Future<dynamic> getdocType() async {
    final result = await postObjectDataMW(
        "http://122.155.223.63/td-khub-dee-middleware-api/docType/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemdocType = result['objectData'];
      });
    }
  }

  Future<dynamic> getPlt() async {
    final result = await postObjectDataMW(
        "http://122.155.223.63/td-khub-dee-middleware-api/Plt/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemPlt = result['objectData'];
      });
    }
  }
}
