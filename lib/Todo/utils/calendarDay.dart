import 'package:flutter/material.dart';

class CalendarDay {
  final DateTime date;

  CalendarDay(this.date);
}


List<CalendarDay> generateCalendarData(DateTime month) {
  final startDate = DateTime(month.year, month.month, 1);
  final endDate = DateTime(month.year, month.month + 1, 7);


  List<CalendarDay> days = [];

  for (var date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {

    days.add(CalendarDay(date));
  }

  return days;
}



