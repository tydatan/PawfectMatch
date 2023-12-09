import 'package:pawfectmatch/models/dog_model.dart';

abstract class BaseDatabaseRepository {
  Stream<Dog> getDog(String userId);
  Stream<List<Dog>> getDogs(String dogId);
}