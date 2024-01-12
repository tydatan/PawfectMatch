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

  Future<void> updateLikedDogsInFirestore(String likedDogOwnerId) async {
    try {
      String loggedInUserId = loggedInDogUid;
      print('Liked Dogs Owner: $likedDogOwnerId');
      await FirebaseService().updateLikedDogs(loggedInUserId, [likedDogOwnerId]);
      
    } catch (e) {
      print('Error updating liked dogs in Firestore: $e');
    }
  }
  
Future<bool> isDogLiked(String dogOwnerId, String likedDogOwnerId) async {
  try {
    // Get the dogOwned by awaiting the result of getDogOwned
    String? dog1 = await getDogOwned(dogOwnerId);

    if (dog1 != null && dog1.isNotEmpty) {
      CollectionReference<Map<String, dynamic>> likedDogsCollection =
          _firebaseFirestore.collection('dogs').doc(dog1).collection('likedDogs');

      print('Checking if $likedDogOwnerId is liked by $dog1');

      // Check if the document exists in 'likedDogs' subcollection
      bool isLiked = (await likedDogsCollection.doc(likedDogOwnerId).get()).exists;

      print('Result: $isLiked');

      return isLiked;
    } else {
      // Handle the case where dog1 is null or empty
      print('DogOwned is null or empty for ownerId: $dogOwnerId');
      return false;
    }
  } catch (error) {
    print('Error checking liked dogs: $error');
    return false;
  }
}


Future<List<String>> getLikedDogs() async {
  try {
    // Get a reference to the 'likedDogs' subcollection for the logged-in dog
    CollectionReference<Map<String, dynamic>> likedDogsCollection =
        _firebaseFirestore.collection('dogs').doc(loggedInDogUid).collection('likedDogs');

    // Get all documents in the 'likedDogs' subcollection
    QuerySnapshot<Map<String, dynamic>> likedDogsSnapshot =
        await likedDogsCollection.get();

    // Extract the 'owner' field from each document
    List<String> likedDogOwners = likedDogsSnapshot.docs
        .map((doc) => doc.data()['owner'] as String)
        .toList();

    return likedDogOwners;
  } catch (error) {
    print('Error getting liked dog owners: $error');
    return [];
  }
}

Future<bool> checkMatch(String likedDogOwnerId) async {
  try {
    // Get the current user's dog ID
    setLoggedInOwner();
    setLoggedInDog();

    // Check if the liked dog has liked the current user's dog
    bool isMatch = await isDogLiked(likedDogOwnerId, loggedInOwner) && await isDogLiked(loggedInOwner, likedDogOwnerId);

    return isMatch;
  } catch (error) {
    print('Error checking match: $error');
    return false;
  }
}

Future<String> getDogOwned(String ownerId) async {
  try {
    // Get a reference to the 'user' document
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _firebaseFirestore.collection('users').doc(ownerId).get();

    // Check if the document exists
    if (userSnapshot.exists) {
      // Retrieve the 'dog' field from the document
      String dogOwned = userSnapshot.data()?['dog'];
      print('got the dog owned: $dogOwned');
      return dogOwned;
    } else {
      print('User document not found for ownerId: $ownerId');
      return '';
    }
  } catch (error) {
    print('Error getting dogOwned: $error');
    return '';
  }
}


Future<void> updateMatchInfo(String dogOwnerId, String matchedDogOwnerId) async {
  try {
    // Perform the necessary actions to update match information in Firestore
    // For example, you can update a 'matches' collection or fields in the 'dogs' collection
    // Update the 'matches' field in Firestore for the specified dog
    await _firebaseFirestore
        .collection('dogs')
        .doc(dogOwnerId)
        .update({
      'matches': FieldValue.arrayUnion([matchedDogOwnerId]),
    });
  } catch (error) {
    print('Error updating match info in Firestore: $error');
  }
}

Future<void> updateMatched(String likedDogOwnerId) async {
  try {
    // Get the current user's dog ID
    setLoggedInOwner();
    setLoggedInDog();

    // Get the dog owned by the liked dog owner
    String matchedDogOwnerId = likedDogOwnerId;

    if (matchedDogOwnerId.isNotEmpty) {
      // Check if the match already exists
      bool matchExists = await checkMatchExists(loggedInOwner, likedDogOwnerId);

      if (!matchExists) {
        // Update 'matches' collection for user1 (logged-in owner)
        await _firebaseFirestore.collection('matches').add({
          'user1': loggedInOwner,
          'user2': likedDogOwnerId,
        });

        // Update 'matches' collection for user2 (liked dog owner)
        await _firebaseFirestore.collection('matches').add({
          'user1': likedDogOwnerId,
          'user2': loggedInOwner,
        });
      } else {
        print('Match already exists between $loggedInOwner and $likedDogOwnerId');
      }
    } else {
      print('Matched dog not found for ownerId: $likedDogOwnerId');
    }
  } catch (error) {
    print('Error updating matched info in Firestore: $error');
  }
}

Future<bool> checkMatchExists(String user1, String user2) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection('matches')
        .where('user1', isEqualTo: user1)
        .where('user2', isEqualTo: user2)
        .get();

    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    print('Error checking match existence: $error');
    return false;
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
