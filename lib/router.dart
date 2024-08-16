import 'package:flutter/material.dart';
import 'package:storky/Event%20Details/screens/eventDetailsScreen.dart';
import 'package:storky/EventViewer/screens/eventViewer.dart';
import 'package:storky/Todo/models/TimeScheduleModel.dart';

import 'Todo/screens/calendar.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){

    case CalendarPage.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_)=> const CalendarPage()
      );


    case EventDetails.routeName:
      final Map<String, dynamic> arguments = routeSettings.arguments as Map<String, dynamic>;
      final eventDetail = arguments['eventDetail'];
      final index = arguments['index'];
      final deleteEventTime = arguments['deleteEventTime'];

      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) =>  EventDetails(eventDetail: eventDetail, index: index, deleteEventTime: deleteEventTime,),
      );

    case EventViewer.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) =>  const EventViewer()
      );




    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_)=> const Scaffold(
            body: Center(
              child: Text('Page Not Found!!'),
            ),
          )
      );
  }
}