class Dog {
  String bio;
  String birthday;
  String breed;
  bool isMale;
  bool isVaccinated;
  String medID;
  String name;
  String ownerId;
  String profilePicture;
  double avgRating;

  Dog({
    required this.bio,
    required this.birthday,
    required this.breed,
    required this.isMale,
    required this.isVaccinated,
    required this.medID,
    required this.name,
    required this.ownerId,
    required this.profilePicture,
    required this.avgRating,
  });

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      bio: json['bio'] ?? '',
      birthday: json['birthday'] ?? '',
      breed: json['breed'] ?? '',
      isMale: json['isMale'] ?? false,
      isVaccinated: json['isVaccinated'] ?? false,
      medID: json['medID'] ?? '',
      name: json['name'] ?? '',
      ownerId: json['ownerId'] ?? '',
      profilePicture: json['profilepicture'] ?? '',
      avgRating: (json['avgRating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bio': bio,
      'birthday': birthday,
      'breed': breed,
      'isMale': isMale,
      'isVaccinated': isVaccinated,
      'medID': medID,
      'name': name,
      'ownerId': ownerId,
      'profilepicture': profilePicture,
      'avgRating': avgRating,
    };
  }

  int calculateAge() {
    DateTime now = DateTime.now();
    DateTime birthDate = DateTime.parse(birthday);
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
