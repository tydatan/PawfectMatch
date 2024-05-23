import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pawfectmatch/blocs/swipe/swipe_bloc.dart';
import 'package:pawfectmatch/firebase_service.dart';
import 'package:pawfectmatch/models/dog_model.dart';
import 'package:pawfectmatch/repositories/database_repository.dart';

import 'package:pawfectmatch/widgets/widgets.dart';


class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SwipeBloc>()..add(LoadDogs());
    
  }


  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffF1F6F8),
      body: BlocBuilder<SwipeBloc, SwipeState>(
        builder: (context, state) {
          if(state is SwipeLoaded) {
            var dogCount = state.dogs.length;
            return Column(
              children: [
              InkWell(
                onDoubleTap: () {
                  Navigator.pushNamed(context, '/dogs', 
                  arguments: state.dogs[0]);
                },
                child: Draggable<Dog>(
                            data: state.dogs[0],
                            child: DogCard(dog: state.dogs[0]),
                            feedback: DogCard(dog: state.dogs[0]),
                            childWhenDragging: (dogCount > 1)
                            ? DogCard(dog: state.dogs[1])
                            : Container(),
                            onDragEnd: (drag) {
                if (drag.offset.dx < 0) {
                  context.read<SwipeBloc>()..add(SwipeLeft(dogs: state.dogs[0]));
                  print('Swiped left');
                } else {
                  context.read<SwipeBloc>()..add(SwipeRight(dogs: state.dogs[0], context: context));
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
                    context.read<SwipeBloc>()..add(SwipeRight(dogs: state.dogs[0], context: context));
                    print('Swiped right');
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
            ],
            );
          }
          else if(state is SwipeLoading){
            return Center(child: CircularProgressIndicator(),
            );
          }
          if (state is SwipeError) {
            return Center(
              child: Text('Oh no, come back for more soon.',
                  style: Theme.of(context).textTheme.headlineSmall),
            );
          } else {
            return Text('Something went wrong.');
          }
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:pawfectmatch/firebase_service.dart';
// import 'package:pawfectmatch/models/dog_model.dart';
// import 'package:pawfectmatch/widgets/widgets.dart';

// class MatchingScreen extends StatefulWidget {
//   const MatchingScreen({Key? key}) : super(key: key);

//   @override
//   State<MatchingScreen> createState() => _MatchingScreenState();
// }

// class _MatchingScreenState extends State<MatchingScreen> {
//   List<Dog> dogs = [];

//   @override
//   void initState() {
//     super.initState();
//     // Call the function when the screen is initialized
//     _loadDogs();
//   }

//   Future<void> _loadDogs() async {
//     // Replace 'loggedInDogUid' with the actual UID of the logged-in dog
//     List<Map<String, dynamic>> dogsData = await FirebaseService().getDogsExcludingLoggedInDog('loggedInDogUid');

//     setState(() {
//       // Convert JSON data to a list of Dog objects
//       dogs = dogsData.map((data) => Dog.fromJson(data)).toList();
//     });
//   }

//   void _handleSwipeLeft() {
//     setState(() {
//       // Handle logic for swiping left (disliking)
//       _removeDogFromList();
//     });
//   }

//   void _handleSwipeRight() async {
//     setState(() async {
//       // Handle logic for swiping right (liking)
//       if (dogs.isNotEmpty) {
//         Dog likedDog = dogs.removeAt(0);
//         likedDog.likedDogs.add(likedDog.ownerId);

//         // Update the likedDogs list for the liked dog in Firestore
//         await FirebaseService().updateLikedDogs(likedDog.ownerId, likedDog.likedDogs);

//         // Check for matches and handle accordingly
//         if (_checkForMatch(likedDog)) {
//           _handleMatch(likedDog);
//         }
//       }
//     });
//   }

//   void _removeDogFromList() {
//     if (dogs.isNotEmpty) {
//       dogs.removeAt(0);
//     }
//   }

//   Future<void> _updateLikedDogsInFirestore(String likedDogOwnerId) async {
//     try {
//       String loggedInUserId = "owner";
//       await FirebaseService().updateLikedDogs(loggedInUserId, [likedDogOwnerId]);
//     } catch (e) {
//       print('Error updating liked dogs in Firestore: $e');
//     }
//   }

//   bool _checkForMatch(Dog likedDog) {
//     // Check if the liked dog also liked the user
//     return likedDog.likedDogs.any((ownerId) => ownerId == 'owner');
//   }

//   void _handleMatch(Dog matchedDog) {
//     // Handle logic for a match
//     print('You matched with ${matchedDog.name}! Proceed to chat or other actions.');
//   }

//   @override
//   Widget build(BuildContext context) {
//     //List<Dog> filteredDogs = dogs.where((dog) => dog.isMale != loggedInUserIsMale).toList();

//     return Scaffold(
//       appBar: CustomAppBar(
//         automaticallyImplyLeading: false,
//       ),
//       backgroundColor: Color(0xffF1F6F8),
//       body: Column(
//         children: [
//           InkWell(
//             onDoubleTap: () {
//               Navigator.pushNamed(context, '/dogs', arguments: dogs.isNotEmpty ? dogs[0] : null);
//             },
//             child: Draggable<Dog>(
//               data: dogs.isNotEmpty ? dogs[0] : null,
//               child: dogs.isNotEmpty ? DogCard(dog: dogs[0]) : Container(),
//               feedback: dogs.isNotEmpty ? DogCard(dog: dogs[0]) : Container(),
//               childWhenDragging: (dogs.length > 1) ? DogCard(dog: dogs[1]) : Container(),
//               onDragEnd: (drag) {
//                 if (drag.offset.dx < 0) {
//                   _handleSwipeLeft();
//                   print('Swiped left');
//                 } else {
//                   _handleSwipeRight();
//                   print('Swiped right');
//                 }
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 70),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 InkWell(
//                   onTap: _handleSwipeLeft,
//                   child: ChoiceButton(
//                     width: 70,
//                     height: 70,
//                     size: 30,
//                     color: Colors.redAccent,
//                     icon: Icons.clear_rounded,
//                   ),
//                 ),
//                 InkWell(
//                   onTap: _handleSwipeRight,
//                   child: ChoiceButton(
//                     width: 70,
//                     height: 70,
//                     size: 30,
//                     color: Colors.greenAccent,
//                     icon: Icons.favorite,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
