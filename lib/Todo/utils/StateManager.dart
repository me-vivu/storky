
import 'package:flutter/material.dart';
import 'package:storky/Todo/models/CalendarModel.dart';

class StateManager extends ChangeNotifier {
  DateTime currentTime = DateTime.now();
  List<CalendarModel> eventList = [];

  DateTime get value => currentTime;
  List<CalendarModel> get getTotalEvent => eventList;

  void setValue(DateTime newValue) {
    currentTime = newValue;
    notifyListeners();
  }

  void addEvent(CalendarModel model, int index) {
    eventList.insert(index, model);
    // notifyListeners();


  }

  void rebuildManager(){
    notifyListeners();
  }
}