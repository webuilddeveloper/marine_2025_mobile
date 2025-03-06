import 'package:flutter/material.dart';

import 'knowledge_form.dart';

class KnowledgeListVertical extends StatefulWidget {
  const KnowledgeListVertical({
    super.key,
    this.site,
    // this.model,
  });

  final String? site;
  // final Future<dynamic>? model;

  @override
  // ignore: library_private_types_in_public_api
  _KnowledgeListVertical createState() => _KnowledgeListVertical();
}

class _KnowledgeListVertical extends State<KnowledgeListVertical> {
  @override
  void initState() {
    super.initState();
  }

  // final List<String> items =
  //     List<String>.generate(10, (index) => "Item: ${++index}");

  final List<Map<String, String>> modelData = [
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250306-113801-1.jpg',
      'title':
          'กรมเจ้าท่ากับการแก้ไขปัญหาการทำประมงผิดกฎหมาย ขาดการรายงาน และไร้การควบคุม (IUU Fishing) ในยุค New Normal',
      'code': 'K003',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250306-113801-1.jpg',
      'title':
          'กรมเจ้าท่ากับการแก้ไขปัญหาการทำประมงผิดกฎหมาย ขาดการรายงาน และไร้การควบคุม (IUU Fishing) ในยุค New Normal',
      'code': 'K003',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250306-113801-1.jpg',
      'title':
          'กรมเจ้าท่ากับการแก้ไขปัญหาการทำประมงผิดกฎหมาย ขาดการรายงาน และไร้การควบคุม (IUU Fishing) ในยุค New Normal',
      'code': 'K003',
    },
    {
      'imageUrl':
          'https://gateway.we-builds.com/wb-py-media/uploads/smart-security\\20250306-113801-1.jpg',
      'title':
          'กรมเจ้าท่ากับการแก้ไขปัญหาการทำประมงผิดกฎหมาย ขาดการรายงาน และไร้การควบคุม (IUU Fishing) ในยุค New Normal',
      'code': 'K003',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (modelData.isEmpty) {
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
    }
    return Container(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.1,
        ),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: modelData.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              SizedBox(
                width: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeForm(
                          code: modelData[index]['code']!,
                          urlComment: '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 0.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        modelData[index]['imageUrl']!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 20 / 100,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Image.asset('assets/images/bar.png'),
              ),
            ],
          );
        },
      ),
    );

    // return FutureBuilder<dynamic>(
    //   future: widget.model, // function where you call your api
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     // AsyncSnapshot<Your object type>
    //     if (snapshot.hasData) {
    //       if (snapshot.data.length == 0) {
    //         return Container(
    //           height: 200,
    //           alignment: Alignment.center,
    //           child: const Text(
    //             'ไม่พบข้อมูล',
    //             style: TextStyle(
    //               fontSize: 18,
    //               fontFamily: 'Sarabun',
    //               color: Color.fromRGBO(0, 0, 0, 0.6),
    //             ),
    //           ),
    //         );
    //       } else {
    //         return Container(
    //           padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    //           child: GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 2,
    //               childAspectRatio: 1 / 1.1,
    //             ),
    //             physics: const ClampingScrollPhysics(),
    //             shrinkWrap: true,
    //             itemCount: snapshot.data.length,
    //             itemBuilder: (context, index) {
    //               return Column(
    //                 children: <Widget>[
    //                   SizedBox(
    //                     width: 150,
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         Navigator.push(
    //                           context,
    //                           MaterialPageRoute(
    //                             builder: (context) => KnowledgeForm(
    //                               code: snapshot.data[index]['code'],
    //                             ),
    //                           ),
    //                         );
    //                       },
    //                       child: Container(
    //                         margin: const EdgeInsets.symmetric(
    //                           horizontal: 5.0,
    //                           vertical: 0.0,
    //                         ),
    //                         child: ClipRRect(
    //                           borderRadius: BorderRadius.circular(8.0),
    //                           child: Image.network(
    //                             snapshot.data[index]['imageUrl'],
    //                             fit: BoxFit.cover,
    //                             height: MediaQuery.of(context).size.height *
    //                                 20 /
    //                                 100,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     child: Center(
    //                       child: Image.asset('assets/images/bar.png'),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             },
    //           ),
    //         );
    //       }
    //     } else {
    //       return Container(
    //         height: 800,
    //         padding: const EdgeInsets.only(left: 5.0, right: 5.0),
    //         child: GridView.count(
    //           crossAxisCount: 2,
    //           children: List.generate(
    //             10,
    //             (index) {
    //               return Column(
    //                 children: <Widget>[
    //                   Expanded(
    //                     child: GestureDetector(
    //                       onTap: () {},
    //                       child: Container(
    //                         padding: const EdgeInsets.only(left: 30, right: 30),
    //                         child: Container(
    //                           decoration: new BoxDecoration(
    //                             color: Colors.white,
    //                             boxShadow: [
    //                               BoxShadow(
    //                                 color: Colors.grey.withOpacity(0.2),
    //                                 spreadRadius: 0,
    //                                 blurRadius: 7,
    //                                 offset: const Offset(
    //                                     0, 3), // changes position of shadow
    //                               ),
    //                             ],
    //                             borderRadius: new BorderRadius.circular(6.0),
    //                           ),
    //                         ),
    //                         // height: 205,
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                     child: Center(
    //                       child: Image.asset('assets/images/bar.png'),
    //                     ),
    //                   ),
    //                 ],
    //               );
    //             },
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
  }
}
