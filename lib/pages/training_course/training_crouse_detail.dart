import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marine_mobile/pages/blank_page/blank_loading.dart';
import 'package:marine_mobile/pages/training_course/training_course_list_category.dart';

class TrainingCrouseDetail extends StatefulWidget {
  TrainingCrouseDetail({super.key, this.model, this.changePage});

  dynamic model;
  Function? changePage;

  @override
  _TrainingCrouseDetail createState() => _TrainingCrouseDetail();
}

class _TrainingCrouseDetail extends State<TrainingCrouseDetail> {
  bool showCalendar = false;
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  String profileCode = '';
  int? selectedButtonIndex = 1;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode2'))!;
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F5),
      resizeToAvoidBottomInset: true,
      // extendBodyBehindAppBar: true,
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
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                // height: 226,
                width: MediaQuery.of(context).size.width,
                child: Container(),
              ),
            ),
            ListView(
              children: [
                SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // height: MediaQuery.of(context).size.height,
                          // height: 226,
                          width: MediaQuery.of(context).size.width > 336
                              ? 336
                              : MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              widget.model['imageUrl'] != '' &&
                                      widget.model['imageUrl'] != null
                                  ? Container(
                                      child: Image.network(
                                        '${widget.model['imageUrl']}',
                                        // color: Color(0xFF224B45),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        // height: MediaQuery.of(context).size.height,
                                        fit: BoxFit.contain,
                                        height: 220,
                                      ),
                                    )
                                  : Container(
                                      child: Image.asset(
                                        './assets/temp_screen.png',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                        height: 220,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).padding.top - 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          // height: 600,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35)),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, -20),
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              Text(
                                '${widget.model['title']}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF213F91),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.model['titleEN']}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0xFF213F91),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'คุณสมบัติผู้เข้ารับการอบรม',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['qualifications']}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ค่าอบรม',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['fee']}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'จำนวนที่รับสมัคร',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['number']} คน',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ระยะเวลาการฝึกอบรม',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['day']} วัน / ( ${widget.model['hourDay']} ชม. )',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ทฤษฎี',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['hourTheory']} ชม.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ปฏิบัติ',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${widget.model['hourPractical']} ชม.',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 150,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 30.0),
                                    child: Material(
                                      elevation: 2.0,
                                      borderRadius: BorderRadius.circular(35.0),
                                      color: Theme.of(context).primaryColor,
                                      child: MaterialButton(
                                        // minWidth: MediaQuery.of(context).size.width,
                                        height: 40,
                                        onPressed: () {
                                          createPayment();
                                        },
                                        child: new Text(
                                          'ลงทะเบียน',
                                          style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  createPayment() {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ลงทะเบียน',
            style: TextStyle(
              fontSize: 22.0,
              color: Color(0xFF213F91),
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'ท่านต้องการลงทะเบียนเข้าอบรมใช่หรือไม่ ?',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // ปิด Popup
              child: Text(
                'ยกเลิก',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Popup แรก
                showSuccessDialog(context); // เปิด Popup Success
              },
              child: Text(
                'ตกลง',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ลงทะเบียนสำเร็จ!',
            style: TextStyle(
              fontSize: 18.0,
              color: Color(0xFF213F91),
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
          content: Text('ลงทะเบียนอบรมสำเร็จ กรุณารอเจ้าหน้าที่ตรวจสอบข้อมูล',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w400,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // ปิด Popup
              child: Text('ตกลง',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ],
        );
      },
    );
  }
}
