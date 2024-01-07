import 'package:cloud_firestore/cloud_firestore.dart';

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
      return _firebaseFirestore
          .collection('dogs')
          .snapshots()
          .map((snap) => snap.docs
              .map((doc) => Dog.fromJson(doc.data() as Map<String, dynamic>))
              //.where((dog) => dog.isMale != loggedInDogIsMale) // Filter dogs by gender
              .toList());
    } catch (error) {
      print('Error getting dogs: $error');
      rethrow;
    }
  }

  // Add a property to store the gender of the logged-in dog
  bool loggedInDogIsMale = true;

  // Method to set the gender of the logged-in dog
  void setLoggedInDogGender(bool isMale) {
    loggedInDogIsMale = isMale;
  }
}


// Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
//   try {
//     // Query the "messages" subcollection of the specified conversation
//     QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
//         .collection('conversations')
//         .doc(conversationId)
//         .collection('messages')
//         .orderBy('timestamp',
//             descending: false) // You can adjust the ordering as needed
//         .get();

//     // Convert the messages to a list of maps
//     List<Map<String, dynamic>> messages = messagesSnapshot.docs.map((doc) {
//       return {
//         'senderId': doc['senderId'],
//         'receiverId': doc['receiverId'],
//         'messageContent': doc['messageContent'],
//         'timestamp': doc['timestamp'],
//       };
//     }).toList();

//     return messages;
//   } catch (error) {
//     print('Error getting messages: $error');
//     rethrow;
//   }
// }