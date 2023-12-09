import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawfectmatch/blocs/swipe/swipe_bloc.dart';
//import 'package:pawfectmatch/models/models.dart';
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
      backgroundColor: Color(0xffF1F6F8),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if(state is SwipeLoading){
            return Center(child: CircularProgressIndicator(),
            );
          }
          else if(state is SwipeLoaded) {
            return Column(
              children: [
              InkWell(
                onDoubleTap: () {
                  Navigator.pushNamed(context, '/dogs', 
                  arguments: state.dogs[0]);
                },
                child: Draggable(
                            child: DogCard(dog: state.dogs[0]),
                            feedback: DogCard(dog: state.dogs[0]),
                            childWhenDragging: DogCard(dog: state.dogs[1]),
                            onDragEnd: (drag) {
                if (drag.offset.dx < 0) {
                  context.read<SwipeBloc>()..add(SwipeLeft(dogs: state.dogs[0]));
                  print('Swiped left');
                } else {
                  context.read<SwipeBloc>()..add(SwipeRight(dogs: state.dogs[0]));
                  print('Swiped right');
                }
                            },
                            ),
              ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal:70 ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()..add(SwipeLeft(dogs: state.dogs[0]));
                    print('Swiped left');
                  },
                  child: ChoiceButton(
                    width: 70, 
                    height: 70, 
                    size: 30, 
                    color: Colors.redAccent, 
                    icon: Icons.clear_rounded,
                    ),
                ),
                InkWell(
                  onTap: () {
                    context.read<SwipeBloc>()..add(SwipeRight(dogs: state.dogs[0]));
                    print('Swiped left');
                  },
                  child: ChoiceButton(
                  width: 70, 
                  height: 70, 
                  size: 30, 
                  color: Colors.greenAccent, 
                  icon: Icons.favorite,
                  ),
                ),
              ],
            ),
          ),
            ],);
          }
          else {return Text('Something went wrong.');
          }
        },
      ),
    );
  }
}




