import 'package:flutter/material.dart';

class CheckLicenseDetail extends StatefulWidget {
  CheckLicenseDetail({super.key, this.model});
  final dynamic model;
  @override
  _CheckLicenseDetail createState() => _CheckLicenseDetail();
}

class _CheckLicenseDetail extends State<CheckLicenseDetail> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  final txtLicense = TextEditingController();

  @override
  void dispose() {
    txtLicense.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, true);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
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
              Expanded(
                child: Text(
                  'ตรวจสอบข้อมูลใบอนุญาต',
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
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(height: 70),
            widget.model?.isNotEmpty
                ? Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 20,
                        ),
                      ],
                      // color: Color.fromRGBO(0, 0, 2, 1),
                    ),
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(15.0),
                            color: Color(0xFFFFFFFF),
                          ),
                          padding: EdgeInsets.all(15.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Container(
                                    child: Text(
                                      'ข้อมูลเลขที่ใบอนุญาต',
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                        color: Color(0XFF213F91),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Kanit',
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'เลขที่ใบอนุญาต',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '${widget.model[0]['license']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'ชื่อเรือ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '${widget.model[0]['boatName']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 15),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'สถานะ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 100,
                                            height: 35,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: widget.model[0]
                                                          ['status'] ==
                                                      'ใช้งาน'
                                                  ? Color(0xFF0C7D30)
                                                  : Colors.red,
                                            ),
                                            child: Text(
                                              '${widget.model[0]['status']}',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 15,
                                                color: Color(0xFFFFFFFF),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'หมายเหตุ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '${widget.model[0]['description']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            'วันหมดอายุ',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '${widget.model[0]['expDate']}',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 150),
                    child: Text(
                      'ไม่พบข้อมูลเลขที่ใบอนุญาต',
                      style: new TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
