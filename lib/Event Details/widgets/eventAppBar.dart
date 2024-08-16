import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Todo/widgets/bottomSheet.dart';

import '../../Constant/commonUtils.dart';
import '../../Todo/models/CalendarModel.dart';
import '../../Todo/models/TimeScheduleModel.dart';
import '../../Todo/utils/StateManager.dart';


class EventAppBar extends StatelessWidget implements PreferredSize {

  DateTime deleteEventTime ;
  int index;

  EventAppBar(this.deleteEventTime, this.index , {Key? key}) : super(key: key);

  bool isSameDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }


  @override
  Widget build(BuildContext context) {
    StateManager manager = Provider.of<StateManager>(context);
    // List<CalendarModel> event = manager.eventList;
    // int deleteIndex = event.indexWhere((element) => isSameDate(element.eventDate! , deleteEventTime));
    // List<TimeScheduleModel> events = event[deleteIndex].eventDetail;
    // int itemIndex = events.indexWhere((element) => element.itemIndex == index);

    List<TimeScheduleModel> eventDetails = buildTimeModelList(manager);

    return Container(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children:  [

          const Icon(Icons.keyboard_arrow_left_rounded, color: primaryColor, size: 40,),
          const Text(
            'June',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 20
            ),
          ),
          const Spacer(),

          const Text(
            'Event Details',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20
            ),
          ),

          const Spacer(),

        InkWell(
          onTap: (){
            bottomSheet(context, eventDetails, index, manager);
          },

            child: const Text(
              'Edit',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontSize: 20
              ),
            ),
          ),



        ],
      ),
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget get child => throw UnimplementedError();
}
