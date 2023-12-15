import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference dogsCollection = FirebaseFirestore.instance.collection('dogs');


  Future<List<Map<String, dynamic>>> getDogsExcludingLoggedInDog(String doguid) async {
    try {
      // Get a reference to the dogs collection
      CollectionReference dogsCollection = FirebaseFirestore.instance.collection('dogs');

      // Get all dogs excluding the logged-in dog
      QuerySnapshot querySnapshot = await dogsCollection.where('doguid', isNotEqualTo: doguid).get();

      // Convert QuerySnapshot to List<Map<String, dynamic>>
      List<Map<String, dynamic>> dogsData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      // Return the list of dogs as JSON objects
      return dogsData;
    } catch (e) {
      print('Error fetching dogs: $e');
      return [];
    }
  }

   Future<bool> getLoggedInDogIsMale(String loggedInDogUid) async {
    try {
      DocumentSnapshot dogSnapshot = await dogsCollection.doc(loggedInDogUid).get();

      // Replace 'gender' with the actual field name in your dog model that represents gender
      bool isMale = dogSnapshot.get('isMale') == 'true';

      return isMale;
    } catch (e) {
      print('Error fetching dog details: $e');
      return false; // Return a default value or handle the error accordingly
    }
  }


  Future<void> updateLikedDogs(String doguid, List<String> likedDogIds) async {
  try {
    // Get the current liked dogs for the user
    DocumentSnapshot dogSnapshot = await dogsCollection.doc(doguid).get();
    List<String> currentLikedDogs = List<String>.from(dogSnapshot.get('likedDogs') ?? []);

    // Combine the existing liked dogs with the new ones and remove duplicates
    List<String> updatedLikedDogs = Set<String>.from([...currentLikedDogs, ...likedDogIds]).toList();

    // Update the 'likedDogs' field in Firestore
    await dogsCollection.doc(doguid).update({
      'likedDogs': updatedLikedDogs,
    });
  } catch (e) {
    print('Error updating liked dogs in Firestore: $e');
  }
}

}
