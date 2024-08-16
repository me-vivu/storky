import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Todo/models/TimeScheduleModel.dart';

class DetailsBlock extends StatelessWidget {
  final List<TimeScheduleModel> eventDetail;
  final int index;
  const DetailsBlock({Key? key, required this.eventDetail, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          eventDetail[index].eventTitle!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 24
          ),
        ),

        const SizedBox(height: 10,),

        Text(
          DateFormat('EEEE d MMMM yyyy').format(eventDetail[index].startTime!),
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
              fontSize: 18
          ),
        ),

        Text(

          'from ${DateFormat('hh:mm a').format(eventDetail[index].startTime!)} to ${DateFormat('hh:mm a').format(eventDetail[index].endTime!)}',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black38,
              fontSize: 18
          ),
        ),

      ],
    );
  }
}
