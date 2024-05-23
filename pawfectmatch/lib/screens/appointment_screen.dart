import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/repositories/database_repository.dart'; 

class AppointmentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Appointments'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
              Tab(text: 'Cancelled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AppointmentList(status: 'upcoming'),
            _AppointmentList(status: 'completed'),
            _AppointmentList(status: 'cancelled'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to a screen for creating a new appointment
            // You can pass relevant data to the new screen, such as matched users
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewAppointmentScreen(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final String status;

  _AppointmentList({required this.status});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      // Replace with the actual method to get appointments based on status
      future: _getAppointments(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No $status appointments available.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                // Customize the ListTile as needed based on your appointment model
              );
            },
          );
        }
      },
    );
  }

  Future<List<String>> _getAppointments(String status) async {
  try {
    // method to get appointments by status
    List<String> appointments = await DatabaseRepository().getAppointmentsByStatus(status);

    return appointments;
  } catch (error) {
    print('Error fetching appointments: $error');
    return [];
  }
}

}

  class NewAppointmentScreen extends StatefulWidget {
    @override
    _NewAppointmentScreenState createState() => _NewAppointmentScreenState();
  }
  
  class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  String selectedDog = ''; // State variable to store the selected matched dog
  DateTime selectedDateTime = DateTime.now(); // State variable to store selected date and time

  Future<List<DropdownMenuItem<String>>> _getMatchedDogs() async {
    try {
      // Get the current user's dog ID
      DatabaseRepository databaseRepository = DatabaseRepository();
await databaseRepository.setLoggedInDog();// Create an instance

      // Fetch matches for the logged-in user
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('matches')
          .where('user1', isEqualTo: databaseRepository.loggedInOwner)
          .get();

      List<DropdownMenuItem<String>> matchedDogs = [];

      // Extract matched dogs from the documents
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        String matchedDog = await databaseRepository.getDogOwned(doc['user2'] as String); // Use the instance
        if (matchedDog.isNotEmpty) {
          matchedDogs.add(
            DropdownMenuItem<String>(
              value: matchedDog,
              child: Text(matchedDog),
            ),
          );
        }
      }

      return matchedDogs;
    } catch (error) {
      print('Error getting matched dogs: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make New Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<DropdownMenuItem<String>>>(
              future: _getMatchedDogs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or any loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No matched dogs available.');
                } else {
                  return DropdownButtonFormField<String>(
                    value: selectedDog,
                    onChanged: (value) {
                      setState(() {
                        selectedDog = value!;
                      });
                    },
                    items: snapshot.data!,
                    decoration: InputDecoration(labelText: 'Select Matched Dog'),
                  );
                }
              },
            ),
            SizedBox(height: 16),

            // Date and time picker
            InkWell(
              onTap: () async {
                // Show date and time picker when the field is tapped
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDateTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)), // Allow appointments within the next year
                );

                if (pickedDate != null) {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Date and Time',
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMM d, y h:mm a').format(selectedDateTime),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Button to submit the appointment
            ElevatedButton(
              onPressed: () {
                //save the appointment with selectedDog and selectedDateTime
                _saveAppointment(selectedDog, selectedDateTime);

                //navigate back to the previous screen or perform any other action
                Navigator.pop(context);
              },
              child: Text('Submit Appointment'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAppointment(String selectedDog, DateTime selectedDateTime) async {
  try {
    // Get the reference to the 'appointments' collection
    CollectionReference<Map<String, dynamic>> appointments =
        FirebaseFirestore.instance.collection('appointments');

    // Create a new document with a unique ID
    await appointments.add({
      'dog': selectedDog,
      'dateTime': selectedDateTime,
    });

  
    print('Appointment saved successfully!');
  } catch (error) {
    print('Error saving appointment: $error');
  }
}

}