import 'package:flutter/material.dart';
import 'package:pawfectmatch/reusables/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawfectmatch/screens/home_screen.dart';
import 'package:pawfectmatch/screens/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String uid;
  String username = '';
  String contactNumber = '';
  String email = '';
  String firstname = '';
  String lastname = '';

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Extract the data from the document snapshot
      contactNumber = userSnapshot['contactnumber'];
      username = userSnapshot['username'];
      email = userSnapshot['email'];
      firstname = userSnapshot['firstname'];
      lastname = userSnapshot['lastname'];

      // Update the UI with the contact number
      setState(() {});
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> showEditProfileDialog() async {
    final TextEditingController _pwTxtCtrl = TextEditingController();
    final TextEditingController _userTxtCtrl = TextEditingController();
    final TextEditingController _contactTxtCtrl = TextEditingController();
    final TextEditingController _fnTxtCtrl = TextEditingController();
    final TextEditingController _lnTxtCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xffFFDD82),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48.0),
                    ],
                  ),
                  // Add your content here
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Username",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff011F3F))),
                        reusableInputTextField(
                            "Enter username", _userTxtCtrl, TextInputType.text),
                        const SizedBox(height: 20),
                        const Text("Contact Number",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff011F3F))),
                        reusableInputTextField("Enter phone number",
                            _contactTxtCtrl, TextInputType.phone),
                        const SizedBox(height: 20),
                        const Text("First Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff011F3F))),
                        reusableInputTextField(
                            "Enter first name", _fnTxtCtrl, TextInputType.text),
                        const SizedBox(height: 20),
                        const Text("Last Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff011F3F))),
                        reusableInputTextField(
                            "Enter last name", _lnTxtCtrl, TextInputType.text),
                        const SizedBox(height: 20),
                        const Text("Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff011F3F))),
                        ReusablePasswordField(
                          text: "Enter password",
                          ctrl: _pwTxtCtrl,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    margin: const EdgeInsets.all(20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      onPressed: () {
                        confirmEditProfile(
                            _userTxtCtrl.text,
                            _contactTxtCtrl.text,
                            _fnTxtCtrl.text,
                            _lnTxtCtrl.text,
                            _pwTxtCtrl.text);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(0xff545F71).withOpacity(0.8);
                            }
                            return const Color(0xff545F71);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                      child: const Text(
                        "Apply Changes",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> confirmEditProfile(
    String newUsername,
    String newContactNumber,
    String newFirstName,
    String newLastName,
    String newPassword,
  ) async {
    // Create a map to store the updated fields
    Map<String, dynamic> updatedFields = {};

    // Conditionally add fields to the map only if the corresponding TextEditingController is not null or empty
    if (newUsername.isNotEmpty) {
      updatedFields['username'] = newUsername;
    }
    if (newContactNumber.isNotEmpty) {
      updatedFields['contactnumber'] = newContactNumber;
    }
    if (newFirstName.isNotEmpty) {
      updatedFields['firstname'] = newFirstName;
    }
    if (newLastName.isNotEmpty) {
      updatedFields['lastname'] = newLastName;
    }
    if (newPassword.isNotEmpty) {
      updatedFields['password'] = newPassword;
    }

    // Update the Firestore document with the new values
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(updatedFields);

    // Update the Firebase Authentication password if it has changed
    if (newPassword.isNotEmpty) {
      try {
        await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      } catch (e) {
        print('Error updating password: $e');
        // Handle the error (e.g., show an error message to the user)
      }
    }

    // Update the local state
    setState(() {
      if (newContactNumber.isNotEmpty) {
        contactNumber = newContactNumber;
      }
      // Add similar checks for other fields if needed
    });

    // Close the dialog
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => UserProfileScreen(),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
            color: Color(
              0xff011F3F,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 170,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      color: Colors.black,
                    ),
                  )),
              Text(
                username.isNotEmpty ? username : 'Username',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
              ),
              const SizedBox(
                height: 10,
              ),
              editProfileButton(context, () {
                showEditProfileDialog();
              }),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                "Personal Information",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstname.isNotEmpty ? firstname : 'Firstname',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const Text(
                        "First Name",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lastname.isNotEmpty ? lastname : 'Lastname',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const Text(
                        "Last Name",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        email.isNotEmpty ? email : 'Email',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const Text(
                        "Email",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contactNumber.isNotEmpty
                            ? contactNumber
                            : 'Contact Number',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      const Text(
                        "Contact No.",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Dog/s:",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff545F71)),
              ),
              //After dogs, if no dog added yet, then + sign ra ang mu gawas, if naa nay dogs, then get dog from firestore, display picture to circle (if no pic added, just display dog name), then when clicked, redirects to dog profile page where
              const SizedBox(
                height: 50,
              ),
              signOutButton(context, () {
                signUserOut(context);
              })
            ],
          ),
        ),
      ),
    );
  }
}

void signUserOut(BuildContext context) {
  FirebaseAuth.instance.signOut();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

Container signOutButton(BuildContext context, Function onTap) {
  return Container(
    width: 185,
    height: 43,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return const Color(0xffFF2C2C).withOpacity(0.8);
              }
              return const Color(0xffFF2C2C);
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)))),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Out",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18),
            ),
            SizedBox(
              width: 7,
            ),
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ],
        )),
  );
}
