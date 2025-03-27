import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marine_mobile/component/material/check_avatar.dart';
import 'package:marine_mobile/widget/text_form_field.dart';

import '../../shared/api_provider.dart';

class QuestionListDetail extends StatefulWidget {
  QuestionListDetail({super.key, this.model});
  final dynamic model;
  @override
  _QuestionListDetail createState() => _QuestionListDetail();
}

class _QuestionListDetail extends State<QuestionListDetail> {
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  XFile? _image;
  Future<dynamic>? _futureProfile;
  String profileCode = '';
  List<dynamic> _itemsImage = [];
  String _imageUrl = '';
  dynamic _modelProfile = {};
  final storage = new FlutterSecureStorage();

  List<dynamic> _model = [
    {
      'code': '1',
      'title': 'สอบถามหน่อยครับ',
      'description': 'สอบถามหน่อยครับ',
      'date': '3 วัน ที่ผ่านมา',
      'createDate': '20/06/2025 5:32 pm',
      'view': '535',
      'userName': 'Xxxx1'
    },
  ];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    callRead();
    super.initState();
  }

  callRead() async {
    profileCode = (await storage.read(key: 'profileCode2'))!;
    if (profileCode != '' && profileCode != null) {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
      var model = await _futureProfile;
      setState(() {
        _imageUrl = model['imageUrl'];
        _modelProfile = model;
      });
    }
  }

  void goBack() async {
    Navigator.pop(context, true);
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
                  'ถาม - ตอบ',
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
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '${widget.model['title']}',
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Kanit',
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Column(
              children: _model.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0)
                        Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: Colors.blue[500],
                            ),
                            SizedBox(width: 5),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'หัวข้อเริ่มต้น',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue[500],
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Kanit',
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${item['description']}',
                          style: new TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Kanit',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color:
                                  Colors.black.withOpacity(0.2), // Border color
                              width: 1.0, // Border width
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              // padding: EdgeInsets.only(right: 10),
                              child: checkAvatar(context, _imageUrl),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '${item['userName']}',
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Kanit',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'โพสต์ : ',
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF000000).withOpacity(0.4),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Kanit',
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              '${item['createDate']}',
                              style: new TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF000000).withOpacity(0.4),
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Kanit',
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.symmetric(horizontal: 15),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'ตอบกลับ',
                      style: new TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kanit',
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  textFormFieldNoValidatorQuestion(
                    txtDescription,
                    '',
                    true,
                    false,
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      // width: 250,
                      height: 50,
                      child: Material(
                        elevation: 2.0,
                        color: Colors.blue[500],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: MaterialButton(
                          height: 30,
                          onPressed: () {
                            createAnswer();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new Text(
                                'เพิ่มคำตอบ',
                                style: new TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  createAnswer() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy h:mm a').format(now);
    var model = {
      'title': '',
      'description': txtDescription.text,
      'userName': _modelProfile['username'],
      'imageUrl': _modelProfile['imageUrl'],
      'createDate': formattedDate,
    };

    setState(() {
      _model.add(model);
      txtDescription.text = '';
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
                      _imgFromGallery();
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
                    _imgFromCamera();
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

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    _upload();
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    _upload();
  }

  void _upload() async {
    if (_image == null) return;

    Random random = new Random();
    uploadImage(_image!).then((res) {
      setState(() {
        String fileName = res.split('/').last;

        _itemsImage.add({
          'imageUrl': res,
          'id': random.nextInt(100).toString(),
        });
        // widget.model['imageUrlPayment'] = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  dialogDeleteImage(String code) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          'ต้องการลบรูปภาพ ใช่ไหม',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: new Text(''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ยกเลิก",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ลบ",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              deleteImage(code);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  deleteImage(String code) async {
    setState(() {
      _itemsImage.removeWhere((c) => c['id'].toString() == code.toString());
    });
  }

  _buildListImage() {
    return SizedBox(
      height: 130.0, // Adjust height for the list
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        itemCount: _itemsImage.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              dialogDeleteImage(_itemsImage[index]['id']);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _itemsImage[index]['imageUrl'],
                  fit: BoxFit.cover,
                  width: 100.0,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100.0,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
