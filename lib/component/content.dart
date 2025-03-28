import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shared/api_provider.dart';
import '../shared/extension.dart';
import 'gallery_view.dart';
import 'link_url_out.dart';

// ignore: must_be_immutable
class Content extends StatefulWidget {
  const Content({
    super.key,
    this.code,
    this.url,
    this.model,
    this.urlGallery,
    this.pathShare,
  });

  final String? code;
  final String? url;
  final dynamic model;
  final String? urlGallery;
  final String? pathShare;

  @override
  ContentState createState() => ContentState();
}

class ContentState extends State<Content> {
  Future<dynamic>? _futureModel;

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    sharedApi();
    _futureModel =
        post(widget.url!, {'skip': 0, 'limit': 1, 'code': widget.code});

    readGallery();
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData(widget.urlGallery!, {'code': widget.code});

    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add(
          item!['imageUrl'] != null
              ? NetworkImage(item!['imageUrl']!)
              : const NetworkImage(""),
        );
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  Future<dynamic> sharedApi() async {
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContent(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContent(
            widget.model,
          );
          // return myContent(widget.model);
        }
      },
    );
  }

  myContent(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : const NetworkImage("")
    ];

    return ListView(
      shrinkWrap: true, // 1st add
      physics: const ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
          child: GalleryView(
            imageUrl: [...image, ...urlImage],
            imageProvider: [...imagePro, ...urlImageProvider],
          ),
        ),
        Container(
          // color: Colors.green,
          padding: const EdgeInsets.only(
            right: 10.0,
            left: 10.0,
          ),
          margin: const EdgeInsets.only(right: 50.0, top: 10.0),
          child: Text(
            '${model['title']}',
            style: const TextStyle(
              fontSize: 18.0,
              fontFamily: 'Sarabun',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: model['userList'] != null &&
                            model['userList'].length > 0
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${model['userList'][0]['imageUrl']}'),
                          )
                        : Container(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model['userList'] != null &&
                                  model['userList'].length > 0
                              ? '${model['userList'][0]['firstName']} ${model['userList'][0]['lastName']}'
                              : '${model['createBy']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate']) +
                                      ' | '
                                  : '',
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ${model['view']} ครั้ง',
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.24,
                    child: Container(
                      width: 100.0,
                      height: 35.0,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        // padding: EdgeInsets.all(0.0),
                        onPressed: () {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          Share.share(
                            '$_urlShared${widget.pathShare!}${model['code']} ${model['title']}',
                            subject: '${model['title']}',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size,
                          );
                        },
                        child: Image.asset('assets/images/share.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   width: 74.0,
            //   height: 31.0,
            //   // decoration: BoxDecoration(
            //   //     image: DecorationImage(
            //   //       image: AssetImage('assets/images/share.png'),
            //   //     )),
            //   alignment: Alignment.centerRight,
            //   child: FlatButton(
            //     padding: EdgeInsets.all(0.0),
            //     onPressed: () {
            //       final RenderBox box = context.findRenderObject();
            //       Share.share(
            //         _urlShared +
            //             widget.pathShare +
            //             '${model['code']}' +
            //             ' ${model['title']}',
            //         subject: '${model['title']}',
            //         sharePositionOrigin:
            //             box.localToGlobal(Offset.zero) & box.size,
            //       );
            //     },
            //     child: Image.asset('assets/images/share.png'),
            //   ),
            // )
          ],
        ),
        Container(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Html(
              data: '${model['description']}',
              onLinkTap: (url, context, attributes) {
                // ignore: deprecated_member_use
                launchUrl(Uri.parse(url.toString()));
              }
              // (String url, RenderContext context,
              //     Map<String, String> attributes, element) {
              //   launch();
              // },
              ),

          // HtmlView(
          //   data: model['description'],
          //   scrollable:
          //       false, //false to use MarksownBody and true to use Marksown
          // ),
        ),
        Container(
          height: 10,
        ),
        model['linkUrl'] != '' ? linkButton(model) : Container(),
        Container(
          height: 10,
        ),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Sarabun',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: const Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Sarabun',
            fontSize: 14.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
