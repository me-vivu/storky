
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storky/Constant/constant.dart';
import 'package:storky/EventViewer/screens/eventViewer.dart';
import 'package:storky/Todo/models/TimeScheduleModel.dart';
import 'package:storky/Todo/screens/calendar.dart';
import '../../Todo/utils/StateManager.dart';
import '../../Todo/widgets/bottomSheet.dart';


class EventViewerAppBar extends StatelessWidget implements PreferredSize {

  const EventViewerAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StateManager stateManager = Provider.of<StateManager>(context);
    DateTime currentDate = stateManager.value;
    List<TimeScheduleModel> eventDetails = [];

    return Row(
      children: [

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

        Row(
          children:[

            InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CalendarPage.routeName);
                },
                child: const Icon(
                  Icons.event,
                  color: primaryColor,
                  size: 28,)
            ),

            const SizedBox(width: 15,),
            const Icon(Icons.search_rounded, color: primaryColor, size: 25,),
            const SizedBox(width: 15,),
            InkWell(
                onTap: (){
                  for(int i = 0; i< 96; i++){
                    Random random = Random();
                    Color color = Color.fromRGBO(
                      random.nextInt(128) + 128,
                      random.nextInt(128) + 128,
                      random.nextInt(128) + 128,
                      1,
                    );
                    eventDetails.add(TimeScheduleModel(color, false, i));
                  }
                  bottomSheet(context, eventDetails, 0, stateManager);
                },



                child: const Icon(
                  Icons.add_rounded,
                  color: primaryColor,
                  size: 30,)),
            const SizedBox(width: 15,),

          ],
        ),


      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget get child => throw UnimplementedError();
}
