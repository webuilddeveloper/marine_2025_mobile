import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../component/carousel_banner.dart';
import '../../component/carousel_form.dart';
import '../../component/link_url_in.dart';
import '../../shared/api_provider.dart';
import '../../widget/header.dart';
import 'reporter_list_category_vertical.dart';

class ReporterListCategory extends StatefulWidget {
  ReporterListCategory({super.key, this.title});
  final String? title;
  @override
  _ReporterListCategory createState() => _ReporterListCategory();
}

class _ReporterListCategory extends State<ReporterListCategory> {
  final storage = new FlutterSecureStorage();

  ReporterListCategoryVertical? reporter;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureCategoryReporter;

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureCategoryReporter =
        post('${reporterCategoryApi}read', {'skip': 0, 'limit': 50});
    _futureBanner = post('${reporterBannerApi}read', {'skip': 0, 'limit': 50});

    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        goBack,
        title: widget.title,
        // isButtonRight: true,
        // rightButton: () => _handleClickMe(),
        // menu: 'reporter',
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            CarouselBanner(
              model: _futureBanner,
              nav: (String path, String action, dynamic model, String code,
                  String urlGallery) {
                if (action == 'out') {
                  launchInWebViewWithJavaScript(path);
                } else if (action == 'in') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarouselForm(
                        code: code,
                        model: model,
                        url: reporterBannerApi,
                        urlGallery: bannerGalleryApi,
                      ),
                    ),
                  );
                }
              },
            ),
            // ),
            SizedBox(height: 10),
            ReporterListCategoryVertical(
              site: "DDPM",
              model: _futureCategoryReporter,
              title: "",
              url: '${reporterCategoryApi}read',
            ),
          ],
        ),
      ),
    );
  }
}
