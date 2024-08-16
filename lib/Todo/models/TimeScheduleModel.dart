import 'package:flutter/material.dart';

class TimeScheduleModel{


  Color backgroundColor = const Color(0xFFF1F1F1);
  DateTime? startTime = DateTime.now();
  DateTime? endTime = DateTime.now().add(const Duration(minutes: 15));
  bool isSelected = false;
  int itemIndex = -1;
  int? totalTimeSlot = 1;
  bool? isEventAdded = false;
  bool? isMainNode = false;
  bool? containCurrentTime = false;
  String? eventTitle = '';
  String? location = ' ';


  TimeScheduleModel(
      this.backgroundColor,
      this.isSelected,
      this.itemIndex
  );

}