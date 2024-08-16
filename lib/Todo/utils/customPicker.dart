import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTimePicker(TimeOfDay initialTime) {
  return SizedBox(
    height: 130,
    child: CupertinoDatePicker(
      initialDateTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        initialTime.hour,
        initialTime.minute,
      ),
      onDateTimeChanged: (DateTime newDateTime) {

      },
      mode: CupertinoDatePickerMode.time,
      minuteInterval: 15, // Set the minute interval to 15 minutes
    ),
  );

}