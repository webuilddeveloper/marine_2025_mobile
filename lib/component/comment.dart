import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../pages/blank_page/toast_fail.dart';
import '../shared/api_provider.dart';
import '../shared/extension.dart';
import 'comment_loading.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment({super.key, this.code, this.url, this.model, this.limit});

  String? code;
  String? url;
  Future<dynamic>? model;
  int? limit;

  @override
  _Comment createState() => _Comment();
}

class _Comment extends State<Comment> {
  final txtDescription = TextEditingController();
  FlutterSecureStorage? storage;
  String username = '';
  String imageUrlCreateBy = '';
  bool hideDialog = true;

  // Future<dynamic> _futureModel;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    storage = FlutterSecureStorage();

    getUser();
    super.initState();
  }

  setDelayShowDialog() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        hideDialog = true;
        // Here you can write your code for open new view
      });
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: const Text(
                'ขอบคุณสำหรับความคิดเห็น',
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
                  child: new Text(
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      color: Theme.of(context).primaryColorDark,
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
        },
      );
    });
  }

  getUser() async {
    var value = await storage?.read(key: 'dataUserLoginDDPM');
    var data = json.decode(value!);

    setState(() {
      imageUrlCreateBy = data['imageUrl'];
      // username = data['firstName'] + ' ' + data['lastName'];
      username = data['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            'แสดงความคิดเห็น',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Sarabun',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextField(
            controller: txtDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'Sarabun',
            ),
            // decoration: new InputDecoration(hintText: "Enter Something", contentPadding: const EdgeInsets.all(20.0)),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.black.withAlpha(50), width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), gapPadding: 1),
              hintText: 'แสดงความคิดเห็น',
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerRight,
          // color: Colors.red,
          child: ElevatedButton(
            // textColor: Colors.black.withAlpha(80),
            // style: ButtonStyle(
            //   overlayColor: WidgetStateProperty.resolveWith(
            //     (states) {
            //       return states.contains(WidgetState.pressed)
            //           ? Theme.of(context).primaryColorDark
            //           : null;
            //     },
            //   ),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10.0),
            //   ),
            // ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
                overlayColor: Theme.of(context).primaryColorDark
            ),
            // splashColor: Colors.transparent,
            // highlightColor: Colors.transparent,
            
            child: const Text(
              'ส่ง',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Sarabun',
              ),
            ),
            // color: Theme.of(context).primaryColorDark,
            onPressed: () {
              sendComment();
            },
          ),
        ),
        FutureBuilder<dynamic>(
          // future: widget.model,
          future: widget.model,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return myComment(
                  snapshot.data); // } else if (snapshot.hasError) {
              //   return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return CommentLoading();
              // return Container();
            }

            // if (snapshot.hasError) {
            //   return Text(snapshot.error.toString());
            // }

            // return Container(
            //   alignment: Alignment.center,
            //   height: 200,
            //   child: Text('Loading...'),
            // );
          },
        ),
      ],
    );
  }

  myComment(dynamic model) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true, // 1st add
        physics: ClampingScrollPhysics(), // 2nd
        // scrollDirection: Axis.horizontal,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              padding: EdgeInsets.all(
                  '${model[index]['imageUrlCreateBy']}' != '' ? 0.0 : 5.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.5),
                  color: Colors.black12),
              width: 35.0,
              height: 35.0,
              child: '${model[index]['imageUrlCreateBy']}' != ''
                  ? CircleAvatar(
                      backgroundImage: model[index]['imageUrlCreateBy'] != null
                          ? NetworkImage('${model[index]['imageUrlCreateBy']}')
                          : null,
                    )
                  : Image.asset(
                      'assets/images/user_not_found.png',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 15, right: 15),
                      margin: EdgeInsets.only(
                          left: 1, right: 15, top: 5, bottom: 1),
                      decoration: BoxDecoration(
                          color: Colors.black.withAlpha(10),
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Colors.white.withAlpha(50))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${model[index]['createBy']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          Text(
                            '${model[index]['description']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    dateStringToDate(model[index]['createDate']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black.withAlpha(80),
                      fontFamily: 'Sarabun',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  sendComment() async {
    if (txtDescription.text != '') {
      postAny('${widget.url}create', {
        'createBy': username,
        'imageUrlCreateBy': imageUrlCreateBy,
        'reference': widget.code,
        'description': txtDescription.text
      }).then((response) {
        if (response == 'S') {
          txtDescription.text = '';

          unfocus(context);

          setState(() {
            widget.model = post('${widget.url}read',
                {'skip': 0, 'limit': widget.limit, 'code': widget.code});
          });
          // helloWorld();
          toastFail(context, text: 'ขอบคุณสำหรับความคิดเห็น', duration: 4);
        } else {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CupertinoAlertDialog(
                  title: new Text(
                    'ไม่สามารถแสดงความคิดเห็นได้',
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
                      child: new Text(
                        "ตกลง",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Sarabun',
                          color: Theme.of(context).primaryColorDark,
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
            },
          );
        }
      }).catchError(
        (onError) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CupertinoAlertDialog(
                  title: new Text(
                    'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
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
                      child: new Text(
                        "ตกลง",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Sarabun',
                          color: Theme.of(context).primaryColorDark,
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
            },
          );
        },
      );
    }
  }
}
