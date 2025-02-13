import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dialog(BuildContext context,
    {String? title,
    String? description,
    bool isYesNo = false,
    Function? callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            title!,
            style: const TextStyle(
              fontSize: 20,
              fontFamily: 'Sarabun',
              color: Colors.red,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description!,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            if (isYesNo)
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Sarabun',
                    color: Colors.red,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Sarabun',
                  color: Colors.red,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                if (isYesNo) {
                  callBack!();
                  Navigator.pop(context, false);
                } else {
                  Navigator.pop(context, false);
                }
              },
            ),
          ],
        );
      });
}
