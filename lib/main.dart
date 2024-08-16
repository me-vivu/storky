import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Todo/models/TimeScheduleModel.dart';
import 'package:storky/Todo/screens/calendar.dart';
import 'package:storky/Todo/utils/StateManager.dart';
import 'package:storky/router.dart';



void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => StateManager(),
        child: const MainPage()
      )
  );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<TimeScheduleModel> eventDetails;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const CalendarPage(),

    );
  }
}
