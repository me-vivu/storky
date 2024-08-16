import 'package:flutter/material.dart';

class EventRow extends StatelessWidget {
  final String eventName;
  final String eventStatus;
  const EventRow({Key? key, required this.eventName, required this.eventStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [

          Text(
            eventName,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold,

          ),),
          const Spacer(),
           Text(
            eventStatus,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black38,
              fontWeight: FontWeight.bold,

            ),),

           Container(
             padding: const EdgeInsets.all(5),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Container(
                   width: 15,
                   alignment: Alignment.bottomCenter,
                   child: Image.asset('assets/images/up_arrow.png', color: Colors.grey,),
                 ),

                 Container(
                     width: 15,
                     child: Image.asset('assets/images/down_arrow.png', color: Colors.grey,)),

               ],
             ),
           )


        ],
      ),
    );
  }
}
