import 'package:storky/Todo/utils/StateManager.dart';

import '../Todo/models/CalendarModel.dart';
import '../Todo/models/TimeScheduleModel.dart';
import 'constant.dart';

List<TimeScheduleModel> buildTimeModelList(StateManager stateManager ){

  List<TimeScheduleModel> eventDetails = [];
  List<TimeScheduleModel> allEvents = [];
  List<CalendarModel> eventList = stateManager.getTotalEvent;
  int i = 0;
  int len = stateManager.getTotalEvent.length;
  DateTime currentDate = stateManager.value;

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

  for(int i = 0; i< 96; i++){
    final hour = i ~/ 4;
    final minute = (i % 4) * 15;
    DateTime startDateTime = DateTime(stateManager.value.year, stateManager.value.month,
        stateManager.value.day, hour, minute);
    // DateTime endDateTime = startDateTime.add(const Duration(minutes: 15));

    int eventIndex = allEvents.indexWhere((element) => element.itemIndex == i);

    if(eventIndex != -1){
      eventDetails.add(allEvents[eventIndex]);
      int timeSlots = allEvents[eventIndex].totalTimeSlot!;
      if(timeSlots > 1){
        for (int j = 1; j < timeSlots; j++) {
          eventDetails.add(TimeScheduleModel(backgroundColor,false, i));
          eventDetails[i + j].isEventAdded = true;
          eventDetails[i + j].backgroundColor = allEvents[eventIndex].backgroundColor;
        }

        i = i + timeSlots -1;
      }

    }else{
      eventDetails.add(TimeScheduleModel(backgroundColor, false, i));
    }

  }

  return eventDetails;

}

bool isSameDate(DateTime firstDate, DateTime secondDate) {
  return firstDate.year == secondDate.year &&
      firstDate.month == secondDate.month &&
      firstDate.day == secondDate.day;
}