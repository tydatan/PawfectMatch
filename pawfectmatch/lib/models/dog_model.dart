import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Dog extends Equatable{
  final String? id;
  final String name;
  final int age;
  final String bio;
  final String imageUrl;
  final String breed;
  final String medID;
  final String birthday;
  final String vaxStatus;
  final String gender;
  final String location;

  const Dog({
    this.id, 
    required this.name,
    required this.age, 
    required this.bio, 
    required this.imageUrl, 
    required this.breed, 
    required this.medID, 
    required this.birthday, 
    required this.vaxStatus,  
    required this.gender,
    required this.location,
    });

    @override
    List<Object?> get props => [id, name, age, bio, imageUrl, breed, medID, birthday, vaxStatus, gender, location];

  static Dog fromSnapshot(DocumentSnapshot snap) {
    Dog dog = Dog(
      id: snap.id,
      name: snap['name'],
      age: snap['age'],
      bio: snap['bio'],
      imageUrl: snap['imageUrl'],
      breed: snap['breed'],
      medID: snap['medID'],
      birthday: snap['birthday'],
      vaxStatus: snap['vaxStatus'],
      gender: snap['gender'],
      location: snap['location'],
    );
    return dog;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'bio': bio,
      'imageUrl': imageUrl,
      'breed': breed,
      'medID': medID,
      'birthday': birthday,
      'vaxStatus': vaxStatus,
      'gender': gender,
      'location': location,
    };
  }

  Dog copyWith({
    String? id,
    String? name,
    int? age,
    String? bio,
    String? imageUrl,
    String? breed,
    String? medID,
    String? birthday,
    String? vaxStatus,
    String? gender,
    String? location,
  }) {
    return Dog(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      breed: breed ?? this.breed,
      medID: medID ?? this.medID,
      birthday: birthday ?? this.birthday,
      vaxStatus: vaxStatus ?? this.vaxStatus,
      gender: gender ?? this.gender,
      location: location ?? this.location,
    );
  }
    

  static List<Dog> dogs = [
        Dog( 
          id: 'VopfG4JlgVHNs2CeKL6F',
          name: '"dog"',
          age: 2,
          bio: 'definitely isnt a cat',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/pawfectmatch-f92dd.appspot.com/o/VopfG4JlgVHNs2CeKL6F?alt=media&token=74a4069f-630a-4575-bb85-aeedfd5e64e1',
          breed: 'hotdog',
          medID: '1111111111',
          birthday: '2023-11-16',
          vaxStatus: 'Complete',
          gender: 'male',
          location: 'here'
        ),
        Dog( 
          id: 'uaMwyVRZcMxOm1IX7LEa',
          name: 'Butters',
          age: 69,
          bio: 'butter cat butter cat butter cat butter cat butter cat',
          imageUrl: 'https://firebasestorage.googleapis.com/v0/b/pawfectmatch-f92dd.appspot.com/o/uaMwyVRZcMxOm1IX7LEa?alt=media&token=876c2944-b284-49f0-84b9-bbe4af5dc642',
          breed: 'loaf',
          medID: '22509741',
          birthday: '1957-12-17',
          vaxStatus: 'Complete',
          gender: 'male',
          location: 'there'
        ),
        
    ];

}