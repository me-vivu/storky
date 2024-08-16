import 'package:flutter/material.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Event%20Details/widgets/detailsBlock.dart';
import 'package:storky/Event%20Details/widgets/eventAppBar.dart';
import 'package:storky/Todo/screens/calendar.dart';
import 'package:storky/Todo/utils/StateManager.dart';
import 'package:provider/provider.dart';
import '../../Todo/models/CalendarModel.dart';
import '../../Todo/models/TimeScheduleModel.dart';


class EventDetails extends StatefulWidget {
  static const String routeName = '/details-screen';
  final List<TimeScheduleModel> eventDetail;
  final DateTime deleteEventTime;
  final int index;
  const EventDetails({Key? key, required this.eventDetail, required this.deleteEventTime, required this.index}) : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  bool isSameDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }



  @override
  Widget build(BuildContext context) {
    StateManager manager = Provider.of<StateManager>(context);
    List<CalendarModel> event = manager.eventList;
    int deleteIndex = event.indexWhere((element) => isSameDate(element.eventDate! , widget.deleteEventTime));
    List<TimeScheduleModel> events = event[deleteIndex].eventDetail;
    int itemIndex = events.indexWhere((element) => element.itemIndex == widget.index);

    return  SafeArea(
        child: Scaffold(
          appBar:  EventAppBar(widget.deleteEventTime, widget.index),
          body: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsBlock(eventDetail: widget.eventDetail, index: widget.index, ),

                const Spacer(),

                InkWell(

                  onTap: (){
                    manager.eventList[deleteIndex].eventDetail.removeAt(itemIndex);
                    Navigator.pushNamed(context, CalendarPage.routeName);


                  },

                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      border: Border.all(color: secondaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Delete Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.red
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20,)

              ],
            ),
          ),
        ));
  }


}


