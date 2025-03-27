import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';

import '../widget/header.dart';

class QRPayment extends StatefulWidget {
  QRPayment({super.key, this.code = '', this.model, this.back = true});

  final String? code;
  final dynamic model;
  final bool? back;

  @override
  State<StatefulWidget> createState() => QRPaymentState();
}

class QRPaymentState extends State<QRPayment> {
  GlobalKey globalKey = new GlobalKey();
  final serverUrl = "https://core148.we-builds.com/payment-api/payment";
  String qrCode = '';
  bool checkOrder = false;
  String code = '';

  int? currentWidget;

  @override
  void initState() {
    currentWidget = 1;
    code = widget.code!;
    // qrCode = 'http://core148.we-builds.com/payment-api/WeMart/Update/' + code;
    qrCode = 'test';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        () {
          Navigator.pop(context);
        },
        title: 'ชำระค่าปรับ',
      ),
      body: WillPopScope(
          child: _contentWidget(), onWillPop: () => Future.value(widget.back)),
    );
  }

  _contentWidget() {
    return AnimatedSwitcher(
      // key: currentWidget,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
      child: _buildWidget(),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          ),
          child: child,
        );
      },
    );
  }

  _buildWidget() {
    return FutureBuilder(
      future: Future.value(currentWidget),
      builder: (context, snapshot) {
        return _buildQRCode();
      },
    );
  }

  Column _buildQRCode() {
    return Column(
      children: <Widget>[
        Expanded(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Color(0xFF2C2C2C),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'กรุณาวาง QR ค่าปรับ',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'ให้อยู่ในกรอบที่กำหนด',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          Image.asset(
                            'assets/images/prompay.png',
                            height: 30,
                            width: double.infinity,
                          ),
                          SizedBox(height: 20),
                          Center(
                            child: QrImageView(
                              backgroundColor: Colors.white,
                              data: qrCode,
                              size: 300,
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
        Container(height: 1, color: Colors.grey),
      ],
    );
  }
}
