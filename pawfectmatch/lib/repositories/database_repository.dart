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
    return _firebaseFirestore
        .collection('dogs')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => Dog.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
