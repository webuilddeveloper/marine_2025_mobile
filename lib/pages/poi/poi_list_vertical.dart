import 'package:flutter/material.dart';

import '../../shared/api_provider.dart';
import 'poi_form.dart';

class PoiListVertical extends StatefulWidget {
  PoiListVertical({super.key, this.model});

  final Future<dynamic>? model;

  @override
  _PoiListVertical createState() => _PoiListVertical();
}

class _PoiListVertical extends State<PoiListVertical> {
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
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
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
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1,
                ),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoiForm(
                            code: snapshot.data[index]['code'],
                            model: snapshot.data[index],
                            url: poiApi,
                            urlComment: poiCommentApi,
                            urlGallery: poiGalleryApi,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: index == 0
                          ? const EdgeInsets.only(left: 5.0, right: 5.0)
                          : index == snapshot.data.length - 1
                              ? const EdgeInsets.only(left: 5.0, right: 15.0)
                              : const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      width: 170.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 170.0,
                            // width: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0),
                              ),
                              color: Colors.grey.withAlpha(220),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  snapshot.data[index]['imageUrl'],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 150.0),
                            padding: const EdgeInsets.all(5),
                            alignment: Alignment.topLeft,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(5.0),
                                bottomRight: Radius.circular(5.0),
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index]['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Sarabun',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  snapshot.data[index]['distance'] == null
                                      ? "ระยะห่าง - กิโลเมตร"
                                      : "ระยะห่าง " +
                                          snapshot.data[index]['distance']
                                              .toStringAsFixed(2) +
                                          " กิโลเมตร",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 8,
                                    fontFamily: 'Sarabun',
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
