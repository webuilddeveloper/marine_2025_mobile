import 'package:flutter/material.dart';

import 'training_course_list.dart';

class TrainingCourseListCategoryVertical extends StatefulWidget {
  const TrainingCourseListCategoryVertical({
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
  TrainingCourseListCategoryVerticalState createState() =>
      TrainingCourseListCategoryVerticalState();
}

class TrainingCourseListCategoryVerticalState
    extends State<TrainingCourseListCategoryVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

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
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainingCourseList(
                              title: snapshot.data[index]['title'],
                              code: snapshot.data[index]['code']),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            // color: Color.fromRGBO(0, 0, 2, 1),
                          ),
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            children: [
                              Container(
                                height: 80.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: const Color(0xFFFFFFFF),
                                ),
                                padding: const EdgeInsets.all(5.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.75,
                                          padding: const EdgeInsets.all(5),
                                          // color: Colors.red,
                                          child: Text(
                                            '${snapshot.data[index]['title']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Kanit',
                                              color: Color(0xFF0C387D),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                      color: Color.fromRGBO(0, 0, 0, 0.5),
                                      size: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
