import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/Todo/models/CalendarModel.dart';
import 'package:storky/Todo/utils/StateManager.dart';
import 'package:storky/Todo/widgets/eventRow.dart';
import 'package:provider/provider.dart';

import '../models/TimeScheduleModel.dart';


Future bottomSheet(BuildContext context, List<TimeScheduleModel> eventDetails, int index, StateManager manager) async  {


  int selectedSlot = -1; // 0 refers to startTime and 1 refers to endTime
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  if(eventDetails[index].isEventAdded!){
    titleController.text = eventDetails[index].eventTitle!;
    locationController.text = eventDetails[index].location!;

  }



  int findTimeIndex(DateTime time){
    int totalMinutes = time.hour * 60 + time.minute;
    int indexNo = totalMinutes ~/ 15;
     return indexNo;
  }

  DateTime calculateTimeFromIndex(int index){
    final hour = index ~/ 4;
    final minute = (index % 4) * 15;
    DateTime startDateTime = DateTime(manager.value.year, manager.value.month,
        manager.value.day, hour, minute);

    return startDateTime;
  }

  DateTime timePicked = calculateTimeFromIndex(index);
  DateTime startTime = calculateTimeFromIndex(index);
  DateTime endTime =startTime.add(const Duration(minutes: 15));


  bool isSameDate(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }


  await showModalBottomSheet(
      backgroundColor: const Color(0xFFE3E3E3),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context, )
      {




    return InkWell(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: DraggableScrollableSheet(
          expand:false,
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.7,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,

              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),

                        child: Row(
                          children: [
                            InkWell(

                              onTap: () {
                                eventDetails[index].isSelected =
                                !eventDetails[index].isSelected;
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,

                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "New Event",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,

                              ),
                            ),
                            const Spacer(),
                             InkWell(
                              onTap: (){
                                if(eventDetails[index].isEventAdded!){
                                  List<CalendarModel> event = manager.eventList;
                                  int deleteIndex = event.indexWhere((element) => isSameDate(element.eventDate! , eventDetails[index].startTime!));
                                  List<TimeScheduleModel> events = event[deleteIndex].eventDetail;
                                  int itemIndex = events.indexWhere((element) => element.itemIndex == index);
                                  manager.eventList[deleteIndex].eventDetail.removeAt(itemIndex);
                                  manager.rebuildManager();
                                }

                                int startIndex = findTimeIndex(startTime);
                                int endIndex = findTimeIndex(endTime);

                                if(endIndex <= startIndex){
                                  Fluttertoast.showToast(msg: 'Invalid Duration');
                                }else{

                                  int timeSlots = endIndex - startIndex;

                                  for(int i = 0; i< timeSlots; i++){

                                    if(i == 0){
                                      eventDetails[startIndex].isMainNode = true;
                                      eventDetails[startIndex].totalTimeSlot = timeSlots;
                                      eventDetails[startIndex].startTime = startTime;
                                      eventDetails[startIndex].endTime = endTime;
                                    }
                                    eventDetails[startIndex + i].isEventAdded = true;
                                    eventDetails[startIndex + i].backgroundColor = eventDetails[index].backgroundColor;



                                  }

                                  eventDetails[startIndex].eventTitle = titleController.text;
                                  eventDetails[startIndex].location = locationController.text;
                                  eventDetails[index].isSelected = !eventDetails[index].isSelected;


                                  List<CalendarModel> event = manager.eventList;
                                  DateTime selectedDate = startTime;

                                  if(event.isEmpty){
                                    CalendarModel eventItem = CalendarModel();
                                    eventItem.eventDate = selectedDate;
                                    eventItem.eventDetail.add(eventDetails[startIndex]);
                                    manager.eventList.add(eventItem);
                                    manager.rebuildManager();
                                  }else{
                                    bool flag = false;
                                    for(CalendarModel events in event){
                                       flag = isSameDate(events.eventDate!, selectedDate);
                                      if(flag){
                                        int index = event.indexOf(events);
                                        manager.eventList[index].eventDetail.add(eventDetails[startIndex]);
                                        manager.rebuildManager();

                                      }

                                    }

                                    if(flag == false){
                                      CalendarModel eventItem = CalendarModel();
                                      eventItem.eventDate = selectedDate;
                                      eventItem.eventDetail.add(eventDetails[startIndex]);
                                      manager.eventList.add(eventItem);
                                      manager.rebuildManager();

                                    }



                                  }


                                  Navigator.pop(context);


                                }




                              },
                              child:  const Text(
                                "Add",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,

                                ),
                              ),
                            ),

                          ],

                        ),


                      ),
                      const SizedBox(height: 30,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [

                            Container(
                              height: 102,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: decoration,
                              child: Column(
                                children: [

                                  SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        autofocus: true,
                                        cursorColor: Colors.black38,
                                        controller: titleController,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18

                                        ),
                                        decoration: const InputDecoration(
                                            hintText: 'Title',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            )
                                        ),
                                      )
                                  ),

                                  Container(
                                    color: Colors.grey,
                                    height: 2,
                                  ),

                                  SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: locationController,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18

                                        ),
                                        cursorColor: Colors.black38,
                                        decoration: const InputDecoration(
                                            hintText: 'Location',
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                                color: Colors.black38,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18
                                            )
                                        ),
                                      )
                                  ),


                                ],
                              ),

                            ),
                            const SizedBox(height: 20,),
                            Container(
                              height: selectedSlot == -1 ? 112 : 250,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: decoration,
                              child: Column(
                                children: [

                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Starts",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,

                                          ),
                                        ),

                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE7E6E6),
                                            borderRadius: BorderRadius.circular(
                                                7),
                                          ),
                                          child: Text(
                                            DateFormat('dd-MMM-yyyy').format(
                                                startTime),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),

                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        InkWell(
                                          onTap: () {

                                            setState((){
                                              if (selectedSlot == -1){
                                                selectedSlot = 0;
                                              }else if(selectedSlot == 0){
                                                selectedSlot = -1;
                                              }

                                            });



                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 38,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE7E6E6),
                                              borderRadius: BorderRadius
                                                  .circular(7),
                                            ),
                                            child: Text(
                                              DateFormat('h:mm a').format(
                                                  startTime),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),

                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2),
                                    child: Container(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Ends",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,

                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          height: 38,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE7E6E6),
                                            borderRadius: BorderRadius.circular(
                                                7),
                                          ),
                                          child: Text(
                                            DateFormat('dd-MMM-yyyy').format(
                                                endTime),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),

                                          ),
                                        ),
                                        const SizedBox(width: 5,),
                                        InkWell(
                                          onTap: (){

                                            setState((){
                                              if (selectedSlot == -1){
                                                selectedSlot = 1;
                                              }else if(selectedSlot == 1){
                                                selectedSlot = -1;
                                              }

                                            });

                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 38,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE7E6E6),
                                              borderRadius: BorderRadius.circular(
                                                  7),
                                            ),
                                            child: Text(
                                              DateFormat('h:mm a').format(
                                                  endTime),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.black,
                                              ),

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  selectedSlot == -1
                                  ? const SizedBox(height: 2,)
                                  : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2),
                                    child: Container(
                                      color: Colors.grey,
                                      height: 2,
                                    ),
                                  ),

                                selectedSlot == -1
                                    ? const SizedBox(height: 2,)
                                    : SizedBox(
                                      height: 130,
                                      width: 300,
                                      child: CupertinoDatePicker(


                                        initialDateTime: selectedSlot == 0
                                            ? startTime
                                            : endTime,

                                        onDateTimeChanged: (DateTime newDateTime) {
                                          setState((){
                                            timePicked = newDateTime;
                                          });

                                          if(selectedSlot == 0){
                                            startTime = timePicked;
                                          }else if(selectedSlot == 1){
                                            endTime = timePicked;
                                          }

                                        },
                                        mode: CupertinoDatePickerMode.time,
                                        minuteInterval: 15, // Set the minute interval to 15 minutes
                                      ),
                                ),



                                ],
                              ),

                            ),
                            const SizedBox(height: 20,),
                            const EventRow(
                              eventName: 'Repeat', eventStatus: 'Never',),
                            const SizedBox(height: 20,),
                            const EventRow(
                              eventName: 'Invites', eventStatus: 'None',),
                            const SizedBox(height: 20,),
                            const EventRow(
                              eventName: 'Alert', eventStatus: 'None',),
                            const SizedBox(height: 20,),


                          ],
                        ),
                      ),

                    ],
                  );

                }
              ),

            );
        }),
    );
  });
}

