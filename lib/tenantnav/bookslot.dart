import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class bookslot extends StatefulWidget {
  final String accommodationId;
  final String roomId;

  const bookslot(
      {Key? key, required this.accommodationId, required this.roomId})
      : super(key: key);

  @override
  _bookslotState createState() => _bookslotState();
}

class _bookslotState extends State<bookslot> {
  DateTime? selectedDate;
  late String userName = ""; // To store fetched user name
  late String userId = ""; // To store fetched user ID
  String ownerName = ""; // To store fetched owner name
  String type = "";
  int rent = 0; // To store fetched rent
  int newcount = 1; // Default count
  late int originalCount;
  late String originalAvailability;
  @override
  void initState() {
    super.initState();
    getCurrentUser();

    fetchAccommodationData();
    fetchRoomDetails();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      fetchUserName();
    }
  }

  // Method to fetch the user's name from the users collection
  void fetchUserName() async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      setState(() {
        userName = userSnapshot.get('name');
      });
    }
  }

  // Fetch accommodation data to get ownerName
  void fetchAccommodationData() async {
    DocumentSnapshot accommodationSnapshot = await FirebaseFirestore.instance
        .collection('accommodation')
        .doc(widget.accommodationId)
        .get();

    if (accommodationSnapshot.exists) {
      setState(() {
        ownerName = accommodationSnapshot.get('name');
      });
    }
  }

  // Fetch room details to get rent
  void fetchRoomDetails() async {
    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('roomdetails')
        .doc(widget.roomId)
        .get();

    if (roomSnapshot.exists) {
      setState(() {
        rent = int.parse(roomSnapshot.get('rent'));
        type = roomSnapshot.get('type');
        newcount = roomSnapshot.get('count');
      });
    }
  }

  // Function to save booking details
  // Function to save booking details
  void saveBookingDetails() {
    //print(newcount);

    int orgcount = newcount - 1;
    String newAvailability = 'Available';
    if (orgcount == 0) {
      newAvailability = 'Accommodated';
    }

    // Update room details in Firestore
    FirebaseFirestore.instance
        .collection('roomdetails')
        .doc(widget.roomId)
        .update({
      'count': orgcount,
      'availability': newAvailability,
    }).then((_) {
      // Show confirmation dialog
    }).catchError((error) {
      // Handle error
      print("Failed to update room details: $error");
      // Show error message or take appropriate action
    });
  }

  // Function to show confirmation dialog
  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Booking'),
          content: Text('Are you sure you want to confirm booking?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog

                // Cancel booking and revert changes
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save booking details
                saveBookingDetails();
                saveBookingToFirestore();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();

                // Close dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void saveBookingToFirestore() {
    FirebaseFirestore.instance.collection('booking').add({
      'startDate': selectedDate,
      'roomId': widget.roomId,
      'accommodationId': widget.accommodationId,
      'userId': userId,
      'userName': userName
    }).then((value) {
      print('Booking added successfully');
    }).catchError((error) {
      print('Failed to add booking: $error');
    });
  }

  // Other methods...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Slot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your existing UI code...

            // Display ownerName fetched from accommodation collection
            Text('Name: $ownerName'),
            SizedBox(height: 20.0),

            // Display rent fetched from roomdetails collection
            Text('Rent: $rent'),
            SizedBox(height: 20.0),

            Text('Type: $type'),
            SizedBox(height: 20.0),

            // Date selection

            // Date selection
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(DateTime.now().year + 1),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Text(selectedDate != null
                  ? 'Selected Date: ${selectedDate!.toString().split(' ')[0]}'
                  : 'Select Date'),
            ),
            ElevatedButton(
              onPressed: () async {
                showConfirmationDialog();
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}
