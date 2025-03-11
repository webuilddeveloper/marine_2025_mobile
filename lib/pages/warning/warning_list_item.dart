import 'package:flutter/material.dart';

import '../../shared/extension.dart';
import 'warning_form.dart';

warningList(BuildContext context, Future<dynamic> model, String title) {
  return FutureBuilder<dynamic>(
    future: model, // function where you call your api
    builder: (context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.length == 0) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            child: const Text(
              'ไม่พบข้อมูล',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Sarabun',
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
                        builder: (context) => WarningForm(
                          code: snapshot.data[index]['code'],
                          model: snapshot.data[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: const Color.fromRGBO(0, 0, 2, 1),
                            ),
                            margin: const EdgeInsets.only(bottom: 5.0),
                            width: 600,
                            child: Column(
                              children: [
                                Container(
                                  height: 55,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF3880B3),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.0),
                                      topRight: Radius.circular(5.0),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(3),
                                            height: 35,
                                            width: 35,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  '${snapshot.data[0]['imageUrlCreateBy']}'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                8, 0, 0, 0),
                                            child: Text(
                                              '${snapshot.data[index]['createBy']}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Sarabun',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                8, 0, 0, 0),
                                            child: Text(
                                              dateStringToDate(snapshot
                                                  .data[index]['createDate']),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Sarabun',
                                                fontSize: 8.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Image.network(
                                  '${snapshot.data[index]['imageUrl']}',
                                  fit: BoxFit.cover,
                                ),
                                Container(
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    color: Color(0xFFE8F0F6),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data[index]['title']}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Sarabun',
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
