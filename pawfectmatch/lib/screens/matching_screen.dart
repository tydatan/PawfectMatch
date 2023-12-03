import 'package:flutter/material.dart';
import 'package:pawfectmatch/models/models.dart';
import 'package:pawfectmatch/widgets/widgets.dart';


class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Color(0xFFCBDFF4),
      body: Column(
        children: [
          Draggable(
            child: DogCard(dog: Dog.dogs[0]),
            feedback: DogCard(dog: Dog.dogs[0]),
            childWhenDragging: DogCard(dog: Dog.dogs[1]),
            onDragEnd: (drag) {
              if (drag.velocity.pixelsPerSecond.dx < 0) {
                print('Swiped left');
              } else {
                print('Swiped right');
              }
            },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal:70 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ChoiceButton(
                  width: 70, 
                  height: 70, 
                  size: 30, 
                  color: Colors.redAccent, 
                  icon: Icons.clear_rounded,
                  ),
                ChoiceButton(
                width: 70, 
                height: 70, 
                size: 30, 
                color: Colors.greenAccent, 
                icon: Icons.favorite,
                ),
              ],
            ),
          ),
            
            
        ],
      ),
    );
  }
}




