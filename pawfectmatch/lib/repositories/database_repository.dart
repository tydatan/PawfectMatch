import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawfectmatch/firebase_service.dart';
import '/models/models.dart';
import 'repositories.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<Dog> getDog(String dogId) {
    print('Getting dog from DB');
    return _firebaseFirestore
        .collection('dogs')
        .doc(dogId)
        .snapshots()
        .map((snap) => Dog.fromJson(snap.data() as Map<String, dynamic>));
  }

  @override
  Stream<List<Dog>> getDogs() {
    try {
      // Query the "dogs" collection
      setLoggedInOwner();
      setLoggedInDog();
      print(loggedInOwner);
      return _firebaseFirestore
          .collection('dogs')
          .snapshots()
          .map((snap) => snap.docs
              .map((doc) => Dog.fromJson(doc.data() as Map<String, dynamic>))
              .where((dog) => dog.owner != loggedInOwner)
              .toList());
    } catch (error) {
      print('Error getting dogs: $error');
      rethrow;
    }
  }

  String loggedInOwner = '';
  String loggedInDogUid = '';

  void setLoggedInOwner() {
    try {
      loggedInOwner = FirebaseAuth.instance.currentUser!.uid;
      print('uid has been stored safely');
    } catch (e) {
      // Handle the case where there is no logged-in user
      print('error in getting uid: $e');
      loggedInOwner = ''; // Set to an appropriate default value
    }
  }

  Future<void> setLoggedInDog() async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(loggedInOwner).get();

      // Use the Users.fromJson method to create an instance of Users from the JSON data
      Users user = Users.fromJson(userSnapshot.data() as Map<String, dynamic>);
      loggedInDogUid = user.dogId;

      // Get the dog using the updated getDog method and print its name
      await getDog(loggedInDogUid).first.then((dog) {
        print('Logged in dog name: ${dog.name}');
      });
    } catch (e) {
      print('Setting Logged in Dog Failed: $e');
    }
  }

  Future<void> _updateLikedDogsInFirestore(String likedDogOwnerId) async {
    try {
      String loggedInUserId = "owner";
      await FirebaseService().updateLikedDogs(loggedInUserId, [likedDogOwnerId]);
    } catch (e) {
      print('Error updating liked dogs in Firestore: $e');
    }
  }

  
}

 


// // Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
// //   try {
// //     // Query the "messages" subcollection of the specified conversation
// //     QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
// //         .collection('conversations')
// //         .doc(conversationId)
// //         .collection('messages')
// //         .orderBy('timestamp',
// //             descending: false) // You can adjust the ordering as needed
// //         .get();

// //     // Convert the messages to a list of maps
// //     List<Map<String, dynamic>> messages = messagesSnapshot.docs.map((doc) {
// //       return {
// //         'senderId': doc['senderId'],
// //         'receiverId': doc['receiverId'],
// //         'messageContent': doc['messageContent'],
// //         'timestamp': doc['timestamp'],
// //       };
// //     }).toList();

// //     return messages;
// //   } catch (error) {
// //     print('Error getting messages: $error');
// //     rethrow;
// //   }
// // }



// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rxdart/rxdart.dart'; // Import rxdart
// import '/models/models.dart';
// import 'repositories.dart';
// import 'package:pawfectmatch/screens/screens.dart';

// class DatabaseRepository extends BaseDatabaseRepository {
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  
//   // StreamController to broadcast changes in loggedInOwner
//   final _loggedInOwnerController = BehaviorSubject<String>.seeded('');

//   DatabaseRepository() {
//     // Listen to authentication state changes and update loggedInOwner
//     FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user != null) {
//         loggedInOwner = user.uid;
//         print('userid stored in database');
//       } else {
//         loggedInOwner = ''; // Set to an appropriate default value
//       }
//       _loggedInOwnerController.add(loggedInOwner);
//     });
//   }

//   // Property to store the gender of the logged-in dog
//   String loggedInOwner = '';

//   // Stream to listen to changes in loggedInOwner
//   Stream<String> get loggedInOwnerStream => _loggedInOwnerController.stream;

//   @override
//   Stream<Dog> getDog(String dogId) {
//     print('Getting dog from DB');
//     return _firebaseFirestore
//         .collection('dogs')
//         .doc(dogId)
//         .snapshots()
//         .map((snap) => Dog.fromJson(snap.data() as Map<String, dynamic>));
//   }

//   @override
//   Stream<List<Dog>> getDogs() {
//     try {
//       // Combine streams to react to changes in both dogs and loggedInOwner
//       return Rx.combineLatest2(
//         _firebaseFirestore.collection('dogs').snapshots(),
//         loggedInOwnerStream,
//         (QuerySnapshot<Object?> snap, String loggedInOwner) {
//           return snap.docs
//               .map((doc) => Dog.fromJson(doc.data() as Map<String, dynamic>))
//               .where((dog) => dog.ownerId != loggedInOwner)
//               .toList();
//         },
//       );
//     } catch (error) {
//       print('Error getting dogs: $error');
//       rethrow;
//     }
//   }

//   // Close the StreamController when the repository is disposed
//   void dispose() {
//     _loggedInOwnerController.close();
//   }
// }
