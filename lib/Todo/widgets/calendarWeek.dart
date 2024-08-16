import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/StateManager.dart';
import '../utils/calendarDay.dart';
import 'package:storky/Constant/constant.dart';

class CustomCalendar extends StatefulWidget {
  final List<CalendarDay> days;


  const CustomCalendar(this.days, {super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {


  @override
  Widget build(BuildContext context) {
    StateManager stateManager = Provider.of<StateManager>(context);
    DateTime currentDate = stateManager.value;
    DateTime lastSunday = currentDate.subtract(Duration(days: currentDate.weekday == 7? 0: currentDate.weekday));

    int firstDayOfWeekIndex = widget.days.indexWhere((day) => day.date.day == lastSunday.day);
    int itemCount = widget.days.length - firstDayOfWeekIndex;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: 70,
            width: MediaQuery.of(context).size.width ,
            child: ListView.builder(
              itemCount: itemCount,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final day = widget.days[firstDayOfWeekIndex + index];
                final isSelectedDay = day.date.day == DateTime.now().day;

                return InkWell(
                  onTap: (){
                    currentDate =  day.date;
                    stateManager.setValue(currentDate);
                    setState(() {});
                  },
                  child: Container(
                    height: 70,
                    width: (MediaQuery.of(context).size.width - 20)/ 7 ,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),


                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(

                            DateFormat('E').format(day.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,

                          ),


                        ),
                        const SizedBox(height: 8,),

                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: day.date.day == currentDate.day
                                ? primaryColor
                                : Colors.transparent
                          ),
                          child: Text(
                              DateFormat('d').format(day.date),
                            style:TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                color: day.date.day == currentDate.day
                                    ? Colors.white
                                    : Colors.black
                            ),

                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        ),
        const SizedBox(height: 6,),
        Text(
          DateFormat('EEEE d MMMM yyyy').format(currentDate),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16
          ),
        )
      ],
    );
  }
}
