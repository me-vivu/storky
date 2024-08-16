import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Todo/models/TimeScheduleModel.dart';

import '../../Todo/models/CalendarModel.dart';

class EventList extends StatelessWidget {

  CalendarModel event;

  EventList(this.event,  {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    DateTime? eventDate = event.eventDate;
    List<TimeScheduleModel>? eventList = event.eventDetail;
    double len = eventList.length.toDouble();

    return eventList.isEmpty
        ? const SizedBox( child: Center(child: Text('List is empty')),)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMM d').format(eventDate!),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              height: 71 * len, // Set a specific height for the ListView.builder
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    child: Container(
                      height: 65,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 5,
                            height: 50,
                            decoration: BoxDecoration(
                              color: eventList[index].backgroundColor,
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eventList[index].eventTitle!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${DateFormat('hh:mm').format(eventList[index].startTime!)} - ${DateFormat('hh:mm').format(eventList[index].endTime!)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${eventList[index].location}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )


          ],
        );

  }
}
