import 'package:flutter/material.dart';

import '../../component/headerCalendar.dart';
import 'calendar.dart';
import 'event_calendar_list.dart';

class EventCalendarMain extends StatefulWidget {
  EventCalendarMain({super.key, this.title});

  final String? title;

  @override
  EventCalendarMainState createState() => EventCalendarMainState();
}

class EventCalendarMainState extends State<EventCalendarMain> {
  bool showCalendar = false;
  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerCalendar(
        context,
        goBack,
        showCalendar,
        title: widget.title!,
        rightButton: () => changeTab(),
        showLeading: true,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: showCalendar
            ? CalendarPage()
            : EventCalendarList(title: widget.title),
      ),
    );
  }
}
