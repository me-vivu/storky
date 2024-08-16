import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storky/EventViewer/widgets/eventList.dart';
import 'package:storky/EventViewer/widgets/eventViewerAppBar.dart';
import 'package:storky/Todo/models/CalendarModel.dart';
import 'package:storky/Todo/utils/StateManager.dart';

class EventViewer extends StatefulWidget {
  static const routeName = 'event-viewer';
  const EventViewer({Key? key}) : super(key: key);

  @override
  State<EventViewer> createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {


  @override
  Widget build(BuildContext context) {
    StateManager stateManager = Provider.of<StateManager>(context);
    List<CalendarModel> eventList = stateManager.eventList;
    eventList.sort((a,b) => a.eventDate!.compareTo(b.eventDate!));

    return SafeArea(

        child: Scaffold(
          appBar: const EventViewerAppBar(),
          body: eventList.isEmpty
              ? const Center(
                child: Text('No Event Found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                ),
              )


              :ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  return   Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 10),
                    child:  EventList(eventList[index]),
                  );
                },
              ),
        )
    );
  }
}
