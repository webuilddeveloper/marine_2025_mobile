import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsForm extends StatefulWidget {
  const AboutUsForm({super.key, this.title, this.code});
  final String? title;
  final String? code;
  @override
  AboutUsFormState createState() => AboutUsFormState();
}

class AboutUsFormState extends State<AboutUsForm> {
  // final Completer<GoogleMapController> _mapController = Completer();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, true);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 5,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 20,
            left: 15,
            right: 15,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  // alignment: Alignment.center,
                  width: 35,
                  decoration: BoxDecoration(
                    color: const Color(0XFF213F91),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  'ตรวจสอบข้อมูลใบอนุญาต',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          // padding: EdgeInsets.all(15),
          padding: EdgeInsets.zero,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 20),
              _buildProfile(),
              const SizedBox(
                height: 40.0,
              ),
              rowData(
                image: Image.asset(
                  "assets/logo/icons/Group56.png",
                ),
                title: '1278 ถ.โยธา แขวงตลาดน้อย เขตสัมพันธวงศ์ กรุงเทพฯ 10100',
              ),
              rowData(
                image: Image.asset(
                  "assets/logo/icons/Path34.png",
                ),
                title: 'โทรศัพท์: 0-22331311-8 โทรสาร: 0-2238-3017',
              ),
              rowData(
                image: Image.asset(
                  "assets/logo/icons/Path34.png",
                ),
                title: 'ตู้ ปณ. 1199 สายด่วน 1199 (ตลอด 24 ชั่วโมง)',
              ),
              rowData(
                  image: Image.asset(
                    "assets/logo/icons/Group62.png",
                  ),
                  title: 'อีเมล์: marine@md.go.th',
                  typeBtn: 'email',
                  value: 'marine@md.go.th'),
              const SizedBox(
                height: 25.0,
              ),
              // SizedBox(
              //   height: 300,
              //   width: double.infinity,
              //   child: googleMap(13.7325251, 100.5132745),
              // ),
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.transparent,
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(
                        color: const Color(0xFF011895),
                      ),
                    ),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        launchURLMap('13.7325251', '100.5132745');
                      },
                      child: const Text(
                        'ตำแหน่ง Google Map',
                        style: TextStyle(
                          color: Color(0xFF011895),
                          fontFamily: 'Kanit',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  checkLicense() {}

  _buildProfile() {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          SizedBox(
            height: 270,
            child: Image.asset(
              'assets/background/bg_home_marine.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            top: 290,
            // top: 190,
            bottom: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 200,
            // bottom: 20,
            // child: _buildMenu(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        // padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/icon-marine.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          // color: Colors.red,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Color(0XFFD5E7D7),
                              ),
                            ),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'กรมเจ้าท่า',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0XFF0C387D),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'MARINE DEPARTMENT',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Color(0XFF0C387D),
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowData({
    Image? image,
    String title = '',
    String value = '',
    String typeBtn = '',
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: image,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => typeBtn != ''
                  ? typeBtn == 'email'
                      ? launchUrl(Uri.parse('mailto:$value'))
                      : typeBtn == 'phone'
                          ? launchUrl(Uri.parse('tel://$value'))
                          : typeBtn == 'link'
                              ? launchUrl(Uri.parse(value))
                              : null
                  : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // googleMap(double lat, double lng) {
  //   return GoogleMap(
  //     myLocationEnabled: true,
  //     compassEnabled: true,
  //     tiltGesturesEnabled: false,
  //     mapType: MapType.normal,
  //     initialCameraPosition: CameraPosition(
  //       target: LatLng(lat, lng),
  //       zoom: 16,
  //     ),
  //     gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
  //       Factory<OneSequenceGestureRecognizer>(
  //         () => EagerGestureRecognizer(),
  //       ),
  //     },
  //     onMapCreated: (GoogleMapController controller) {
  //       _mapController.complete(controller);
  //     },
  //     // onTap: _handleTap,
  //     markers: <Marker>{
  //       Marker(
  //         markerId: const MarkerId('1'),
  //         position: LatLng(lat, lng),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //       ),
  //     },
  //   );
  // }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";
    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);
  }
}
