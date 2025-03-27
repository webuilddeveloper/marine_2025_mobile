import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marine_mobile/pages/license/renew_license_payment.dart';

class RenewLicenseDetail extends StatefulWidget {
  RenewLicenseDetail({super.key, this.model});

  final dynamic model;
  final storage = new FlutterSecureStorage();

  @override
  _RenewLicenseDetail createState() => _RenewLicenseDetail();
}

class _RenewLicenseDetail extends State<RenewLicenseDetail> {
  final storage = new FlutterSecureStorage();

  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    scrollController = ScrollController();
    print('---123----${widget.model}');
    super.initState();
  }

  contentCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(20),
            // height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 20),
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'รายละเอียดข้อมูล',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF213F91),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['description'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ชื่อเรือ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['boatName'],
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
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'เลขทะเบียนเรือ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['boatLicense'],
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
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ใบอนุญาตใช้เรือสิ้นสุดในวันที่',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['expDate'],
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
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ใบอนุญาตใช้เรือเดิม',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['fileBoatLicenseName'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF0C387D),
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ใบสำคัญรับรองการตรวจเรือ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.model['fileShipInspectionName'],
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color(0xFF0C387D),
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ไฟล์รูปถ่าย',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      widget.model['fileImageOther'] != "" &&
                              widget.model['fileImageOther'] != null
                          ? Expanded(
                              flex: 1,
                              child: Image.network(
                                widget.model['fileImageOther'],
                                width: 120,
                                height: 120,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Color(0xFFFFFFFF),
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      'แก้ไขข้อมูล',
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF0C387D),
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 40),
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 30.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RenewLicensePayment(model: widget.model),
                        ),
                      );
                    },
                    child: new Text(
                      'ถัดไป',
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
        backgroundColor: Color(0xFFF3F5F5),
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
                  '',
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
      backgroundColor: Color(0xFFF3F5F5),
      body: Container(
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
      ),
    );
  }
}
