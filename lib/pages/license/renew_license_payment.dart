import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/api_provider.dart';

class RenewLicensePayment extends StatefulWidget {
  RenewLicensePayment({super.key, this.model});

  final dynamic model;
  final storage = const FlutterSecureStorage();

  @override
  _RenewLicensePayment createState() => _RenewLicensePayment();
}

class _RenewLicensePayment extends State<RenewLicensePayment> {
  final storage = const FlutterSecureStorage();
  XFile? _image;

  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  contentCard() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView(
        controller: scrollController,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width > 336
                ? 336
                : MediaQuery.of(context).size.width,
            child: Container(
              child: Image.asset(
                'assets/profile_qr.png',
                width: MediaQuery.of(context).size.width,
                height: 170,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () => _downloadQR(),
            child: Container(
              alignment: Alignment.center,
              child: const Text(
                'ดาวน์โหลด QR Code',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.underline,
                  color: Color(0xFF213F91),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            // height: 500,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
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
                const Text(
                  'ชำระค่าธรรมเนียม',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFF213F91),
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ค่าใบอนุญาตใช้เรือ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'รายละเอียด',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'เรือกลไฟและเรือยนต์ ขนาดไม่เกิน 5 ตันกรอส',
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
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'ค่าธรรมเนียม',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '20.00 บาท',
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
                const SizedBox(height: 30),
                Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: MaterialButton(
                        onPressed: () {
                          _showPickerImage(context);
                        },
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.upload_file,
                          size: 50,
                          color: Color(0xFF0C387D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      child: const Text(
                        'อัพโหลดสลิปค่าธรรมเนียม',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                widget.model['imageUrlPayment'] != '' &&
                        widget.model['imageUrlPayment'] != null
                    ? Image.network(
                        widget.model['imageUrlPayment'],
                        width: 150,
                        height: 150,
                        fit: BoxFit.fill,
                      )
                    : Container(),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                margin: const EdgeInsets.symmetric(vertical: 30.0),
                child: Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(5.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      createPayment();
                    },
                    child: new Text(
                      'ยืนยัน',
                      style: const TextStyle(
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

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text(
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
                  leading: const Icon(Icons.photo_camera),
                  title: const Text(
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

    uploadImage(_image!).then((res) {
      setState(() {
        widget.model['imageUrlPayment'] = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  bool dataLoaded = false;

  _downloadQR() async {
    var _url =
        "https://lc.we-builds.com/lc-document/images/news/a4366866-886d-47fd-9337-24fd052e5210/profile_qr.png";

    var response = await Dio()
        .get(_url, options: Options(responseType: ResponseType.bytes));
    // final result = await ImageGallerySaver.saveImage(
    //     Uint8List.fromList(response.data),
    //     quality: 100,
    //     name: "_imageQR");

    final result = true;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ดาวน์โหลดรูปภาพเรียบร้อย'),
        ),
      );
    }
  }

  createPayment() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: CupertinoAlertDialog(
            title: const Text(
              'ขอบคุณที่ชำระค่าธรรมเนียมต่อใบอนุญาตใช้เรือ กรุณารอเจ้าหน้าที่ทำการตรวจสอบสักครู่',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: const Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    color: Color(0xFF0C387D),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();

                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //     builder: (context) => HomePage(),
                  //   ),
                  // );
                  // goBack();
                },
              ),
            ],
          ),
        );
      },
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
        backgroundColor: const Color(0xFFF3F5F5),
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
                    color: const Color(0XFF213F91),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
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
      backgroundColor: const Color(0xFFF3F5F5),
      body: Container(
        child: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
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
