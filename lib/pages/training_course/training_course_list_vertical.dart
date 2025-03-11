import 'package:flutter/material.dart';
import 'package:marine_mobile/pages/training_course/training_crouse_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingCourseListVertical extends StatefulWidget {
  const TrainingCourseListVertical({
    super.key,
    this.site,
    this.model,
    this.title,
    this.url,
  });

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;

  @override
  TrainingCourseListVerticalState createState() =>
      TrainingCourseListVerticalState();
}

class TrainingCourseListVerticalState
    extends State<TrainingCourseListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  _makePhoneCall(String url) async {
    url = 'tel:' + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: const Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              // color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrainingCrouseDetail(
                                  model: snapshot.data[index]),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          margin: const EdgeInsets.only(bottom: 5.0),
                          // width: 600,
                          child: Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 80,
                                  minWidth: double.infinity,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: const Color(0xFFFFFFFF),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              // color: Colors.red,
                                              child: Text(
                                                '${snapshot.data[index]['title']}',
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  fontFamily: 'Kanit',
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.75,
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              // color: Colors.red,
                                              child: Text(
                                                '${snapshot.data[index]['titleEN']}',
                                                style: const TextStyle(
                                                  // fontWeight: FontWeight.normal,
                                                  fontSize: 15.0,
                                                  fontFamily: 'Kanit',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.6),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
