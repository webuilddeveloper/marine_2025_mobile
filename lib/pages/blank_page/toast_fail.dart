
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastFail(BuildContext context,{String text = 'การเชื่อมต่อผิดพลาด',Color color = Colors.grey,Color fontColor = Colors.white,int duration = 3}) {
  // return Toast.show(
  //     text,
  //     context,
  //     backgroundColor: color,
  //     duration: duration,
  //     gravity: Toast.BOTTOM,
  //     textColor: fontColor
  // );
  return Fluttertoast.showToast(
    msg: text,
    backgroundColor: color,
    gravity: ToastGravity.BOTTOM,
    textColor: fontColor
  );
}