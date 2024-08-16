import 'dart:math';

import 'package:calendar_agenda/calendar_agenda.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Todo/models/CalendarModel.dart';
import 'package:storky/Todo/utils/StateManager.dart';
import 'package:storky/Todo/widgets/bottomSheet.dart';
import 'package:storky/Todo/widgets/calendarAppBar.dart';
import 'package:storky/Todo/widgets/calendarWeek.dart';

import '../../Event Details/screens/eventDetailsScreen.dart';
import '../models/TimeScheduleModel.dart';
import '../utils/calendarDay.dart';


class CalendarPage extends StatefulWidget {
  static const String routeName = '/calendar-screen';
  const CalendarPage({Key? key}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

enum ScrollingList {
  none,
  left,
  right,
}

class CalendarPageState extends State<CalendarPage> {

  final items = time;
  DateTime eventDate = DateTime.now();
  CalendarAgendaController calendarController = CalendarAgendaController();
  late DateTime selectedDateAppBBar;
  bool isSelected = false;
  Color color = backgroundColor;
  BoxDecoration? timeSlotBackground;
  late ScrollController taskController ;
  late ScrollController timeController ;
  var scrollingList = ScrollingList.none;
  bool nullEventDetails =true;

  List<CalendarModel> calendarDetails= [];

  List<TimeScheduleModel> eventDetails =[];
  int updated = 0;





  void highlightRow(int index){
    Random random = Random();
    color = Color.fromRGBO(
      random.nextInt(128) + 128,
      random.nextInt(128) + 128,
      random.nextInt(128) + 128,
      1,
    );

    timeSlotBackground = BoxDecoration(
      color: color,
    );

    setState(() {
      eventDetails[index].isSelected = !eventDetails[index].isSelected;
      eventDetails[index].backgroundColor = color;
      nullEventDetails = false;
    });

  }


  bool isSameDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }

  @override
  void dispose() {

    taskController.dispose();
    timeController.dispose();
    super.dispose();
  }

  int findTimeIndex(DateTime time){
    int totalMinutes = time.hour * 60 + time.minute;
    int indexNo = totalMinutes ~/ 15;
    return indexNo;
  }




  @override
  void initState() {
    selectedDateAppBBar = DateTime.now();
    taskController = ScrollController(initialScrollOffset: ((findTimeIndex(DateTime.now())) * 16.0));
    timeController = ScrollController(initialScrollOffset:((findTimeIndex(DateTime.now())) * 16.0));
    super.initState();


  }

  @override
  Widget build(BuildContext context) {

    return Consumer<StateManager>(
      builder: (context, stateManager, _) {

        DateTime currentDate = stateManager.value;
        final timeLine = DateTime.now();
        List<CalendarDay> calendarData = generateCalendarData(currentDate);
        int i = 0;

        //finding index of time
        int totalMinutes = timeLine.hour * 60 + timeLine.minute;
        int currentTimeIndex = totalMinutes ~/ 15;
        double totalVal = totalMinutes/15 ;
        double heightRatio = totalVal - currentTimeIndex;
        double paddingRatio = 1 - heightRatio;


        int len = stateManager.getTotalEvent.length;
        List<CalendarModel> eventList = stateManager.getTotalEvent;
        List<TimeScheduleModel> allEvents = [];

        if(!isSameDate(eventDate, currentDate)){
          eventDate = currentDate;
          eventDetails = [];

        }


        while(i < len){

          List<TimeScheduleModel> eventItem = eventList[i].eventDetail;
          DateTime? eventDate = eventList[i].eventDate;
          bool flag = isSameDate(currentDate, eventDate!);
          if(flag){
            allEvents = eventItem;
            eventDetails = [];
            break;
          }

          i++;

        }

        //creating a list of item to be accessed
        for(int i = 0; i< 96; i++){
          final hour = i ~/ 4;
          final minute = (i % 4) * 15;
          DateTime startDateTime = DateTime(stateManager.value.year, stateManager.value.month,
              stateManager.value.day, hour, minute);
          DateTime endDateTime = startDateTime.add(const Duration(minutes: 15));

          int eventIndex = allEvents.indexWhere((element) => element.itemIndex == i);

          if(eventIndex != -1){
            eventDetails.add(allEvents[eventIndex]);
            int timeSlots = allEvents[eventIndex].totalTimeSlot!;
            if(timeSlots > 1){
                for (int j = 1; j < timeSlots; j++) {
                  eventDetails.add(TimeScheduleModel(backgroundColor, isSelected, i));
                  eventDetails[i + j].isEventAdded = true;
                  eventDetails[i + j].backgroundColor = allEvents[eventIndex].backgroundColor;
                }

                i = i + timeSlots -1;
            }
            if(i == currentTimeIndex){
              eventDetails[i].containCurrentTime = true;
            }

          }else{
            eventDetails.add(TimeScheduleModel(backgroundColor, isSelected, i));
            if(i == currentTimeIndex){
              eventDetails[i].containCurrentTime = true;
            }
          }

        }



        return SafeArea(
          child: Scaffold(
            appBar:const CalendarAppBar(),

            body: Column(
              children: [

                SizedBox(
                  height: 100,
                    child: CustomCalendar(calendarData)
                ),

                Expanded(
                  child: Container(
                    color: backgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 50,
                            child: Column(
                              children: [
                                Flexible(
                                  child: NotificationListener<ScrollNotification>(
                                    onNotification: (notification){

                                      if (notification is ScrollStartNotification) {
                                        if (scrollingList == ScrollingList.none) {
                                          scrollingList = ScrollingList.left;
                                        }
                                      } else if (notification is ScrollEndNotification) {
                                        if (scrollingList == ScrollingList.left) {
                                          scrollingList = ScrollingList.none;
                                        }
                                      }
                                      if (scrollingList == ScrollingList.left) {
                                        taskController.jumpTo(timeController.offset);
                                      }
                                      return true;
                                    },
                                    child: ScrollConfiguration(
                                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                      child: ListView.builder(
                                        controller: timeController,
                                          itemCount: items.length * 4,
                                          itemBuilder: (context, index){
                                            String readTime = items[index ~/ 4];


                                            return (index % 4 == 0)
                                                ? Container(
                                                  height: 20,
                                                  decoration: const BoxDecoration(
                                                    color: backgroundColor,

                                                  ),

                                                  child: Container(
                                                    alignment: Alignment.topLeft,
                                                    child: Text( readTime,
                                                      style: const TextStyle(
                                                        color: Colors.black38,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                : const SizedBox(height: 20,);

                                          }
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8,),
                              ],
                            ),
                          ),

                          Expanded(

                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(height: 8,),
                            Flexible(
                              child: NotificationListener<ScrollNotification>(

                                onNotification: (notification) {
                                  if (notification is ScrollStartNotification) {
                                    if (scrollingList == ScrollingList.none) {
                                      scrollingList = ScrollingList.right;
                                    }
                                  } else if (notification is ScrollEndNotification) {
                                    if (scrollingList == ScrollingList.right) {
                                      scrollingList = ScrollingList.none;
                                    }
                                  }
                                  if (scrollingList == ScrollingList.right) {
                                    timeController.jumpTo(taskController.offset);
                                  }
                                  return true;
                                },

                                child: ListView.builder(
                                    controller: taskController,
                                    itemCount: 96,
                                    itemBuilder: (context, index){

                                      return (index % 4 == 0)
                                          ? InkWell(
                                            onTap: () async {

                                              if(eventDetails[index].isEventAdded!){
                                                Navigator.pushNamed(
                                                    context,
                                                    EventDetails.routeName,
                                                    arguments: {'eventDetail': eventDetails, 'index': index, 'deleteEventTime': eventDetails[index].startTime});

                                              }

                                              if(eventDetails[index].isSelected){
                                                bottomSheet(context, eventDetails, index, stateManager);

                                              }
                                            },

                                            onLongPress: () async {
                                              if(!(eventDetails[index].isEventAdded!)){
                                                highlightRow(index);
                                                bottomSheet(context, eventDetails, index, stateManager);

                                              }

                                            },

                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: backgroundColor,

                                              ),



                                              child: eventDetails[index].isEventAdded!
                                                  ? eventDetails[index].isMainNode!
                                                  ? Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: 20 * eventDetails[index].totalTimeSlot!.toDouble(),
                                                    width: MediaQuery.of(context).size.width,
                                                    padding: const EdgeInsets.only(left: 5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                      color: eventDetails[index].backgroundColor,
                                                    ),
                                                    child:  Text(eventDetails[index].eventTitle!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black
                                                      ),),

                                              )
                                              : const SizedBox(height: 0, width: 0,)

                                              :eventDetails[index].isSelected
                                              //TODO: build the stack for the given selected row
                                                ? SizedBox(
                                                  height: 20,
                                                  child: Stack(

                                                    children: [
                                                      Container(
                                                          height: 20,
                                                          decoration:  BoxDecoration(
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft:  Radius.circular(5)),
                                                            color: eventDetails[index].backgroundColor,
                                                          )

                                                      ),
                                                      // Column(
                                                      //   children: [
                                                      //     Container(
                                                      //       padding: const EdgeInsets.only(right: 8),
                                                      //       height: 4,
                                                      //       decoration:  BoxDecoration(
                                                      //         border: Border.all(),
                                                      //         borderRadius: const BorderRadius.all(Radius.circular(2))
                                                      //       ),
                                                      //
                                                      //       child: Row(
                                                      //         children: const [
                                                      //           Spacer(),
                                                      //           Icon(Icons.album_outlined,size: 12, )
                                                      //
                                                      //
                                                      //
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //     const Spacer(),
                                                      //     Container(
                                                      //       padding: const EdgeInsets.only(left: 5, bottom: 5),
                                                      //       height: 4,
                                                      //       decoration:  BoxDecoration(
                                                      //           border: Border.all(),
                                                      //           borderRadius: const BorderRadius.all(Radius.circular(2))
                                                      //       ),
                                                      //       child: Row(
                                                      //         children: const [
                                                      //           Padding(
                                                      //             padding: EdgeInsets.zero,
                                                      //             child: Icon(Icons.album_outlined,size: 12, ),
                                                      //           )
                                                      //
                                                      //         ],
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // )

                                                    ],

                                                  ),
                                                )
                                                : SizedBox(
                                                  height: 20,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        color: backgroundColor, // Color of the container
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topCenter,
                                                        child: Container(
                                                          height: 2,
                                                          color: Colors.black12, // Color of the line
                                                        ),
                                                      ),

                                                      eventDetails[index].containCurrentTime! &&
                                                        isSameDate(currentDate, timeLine)
                                                          ? Padding(
                                                            padding: EdgeInsets.only(top: heightRatio * 20),
                                                            child: Container(
                                                              height: 1.2,
                                                              color: Colors.red,
                                                            ),
                                                          )
                                                          : const SizedBox(height: 0,)
                                                    ],
                                                  ),
                                            ),
                                        ),
                                      )

                                          : InkWell(

                                            onTap: ()  async {

                                              if(eventDetails[index].isEventAdded!){
                                                Navigator.pushNamed(
                                                    context,
                                                    EventDetails.routeName,
                                                    arguments: {'eventDetail': eventDetails, 'index': index, 'deleteEventTime': eventDetails[index].startTime});

                                              }

                                            if(eventDetails[index].isSelected){
                                              bottomSheet(context, eventDetails, index, stateManager);


                                                }
                                            },

                                            onLongPress: ()  async {
                                              if(!(eventDetails[index].isEventAdded!)) {
                                                highlightRow(index);
                                                bottomSheet(
                                                    context, eventDetails,
                                                    index, stateManager);
                                              }
                                            },

                                            child: eventDetails[index].isEventAdded!
                                                ? eventDetails[index].isMainNode!
                                                ? Container(
                                                  height:  20 * eventDetails[index].totalTimeSlot!.toDouble(),
                                                  width: MediaQuery.of(context).size.width,
                                                  alignment: Alignment.centerLeft,
                                                  padding: const EdgeInsets.only(left: 5,),
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
                                                    color: eventDetails[index].backgroundColor,
                                                  ),
                                                  child:  Text(
                                                    eventDetails[index].eventTitle!,
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 11
                                                    ),
                                                  ),

                                                )

                                            : const SizedBox( height: 0,)

                                            :Container(
                                              height: 20,
                                              alignment: Alignment.bottomCenter,

                                              decoration: eventDetails[index].isSelected
                                                  ? BoxDecoration(
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomLeft:  Radius.circular(5)),
                                                color: eventDetails[index].backgroundColor,
                                              )
                                                  : const BoxDecoration(
                                                      border: Border(
                                                          top: BorderSide(
                                                            color: Colors.black12,
                                                            width: 1,
                                                            style: BorderStyle.solid,
                                                          )
                                                      ),

                                                      color: backgroundColor,
                                              ),

                                              child: eventDetails[index].containCurrentTime! &&
                                                isSameDate(currentDate, timeLine)
                                                  ? Padding(
                                                    padding: EdgeInsets.only(bottom: paddingRatio * 18),
                                                    child: Container(
                                                      height: 1.2,
                                                      color: Colors.red,
                                                    ),
                                                  )
                                              : const SizedBox(height: 0,),


                                            ),


                                      );


                                    }
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),



          ),
        );
      }
    );



  }
}