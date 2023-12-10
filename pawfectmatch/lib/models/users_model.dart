class Users {
  final String contactNumber;
  final String dogId;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String profilePicture;
  final String username;

  Users({
    required this.contactNumber,
    required this.dogId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.profilePicture,
    required this.username,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      contactNumber: json['contactnumber'] ?? '',
      dogId: json['dog'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstname'] ?? '',
      lastName: json['lastname'] ?? '',
      password: json['password'] ?? '',
      profilePicture: json['profilepicture'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
