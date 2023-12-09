import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/models.dart';
import 'repositories.dart';

class DatabaseRepository extends BaseDatabaseRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Stream<Dog> getDog(String dogId) {
    print('Getting dog images from DB');
    return _firebaseFirestore
        .collection('dogs')
        .doc(dogId)
        .snapshots()
        .map((snap) => Dog.fromSnapshot(snap));
  }

  @override
  Stream<List<Dog>> getDogs(
    String dogId,

  ) {
    return _firebaseFirestore
        .collection('dogs')
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) => Dog.fromSnapshot(doc)).toList();
    });
  }
  

}