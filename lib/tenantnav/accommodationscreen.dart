import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class accommodationscreen extends StatefulWidget {
  final String accommodationId;
  final String Rent;
  final String Gender;
  final String Type;
  const accommodationscreen(
      {required this.accommodationId,
      required this.Rent,
      required this.Gender,
      required this.Type});

  @override
  _accommodationscreenState createState() => _accommodationscreenState();
}

class _accommodationscreenState extends State<accommodationscreen> {
  String accommodationName = '';
  String address = '';
  String cityName = '';
  String districtName = '';
  String stateName = '';
  String name = '';
  String phone = '';
  String rules = '';
  List<String> amenities = [];
  List<String> imageUrls = [];
  List<Map<String, dynamic>> roomdetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchRooms();
  }

  Future<void> fetchDetails() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('accommodation')
        .doc(widget.accommodationId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      setState(() {
        accommodationName = data?['accommodationName'] ?? '';
        address = data?['address'] ?? '';
        cityName = data?['cityName'] ?? ''; // Correct assignment
        districtName = data?['districtName'] ?? ''; // Correct assignment
        stateName = data?['stateName'] ?? ''; // Correct assignment
        name = data?['name'] ?? ''; // Correct assignment
        phone = data?['phone'] ?? '';
        rules = data?['rules'] ?? '';
        amenities = List<String>.from(data?['amenities'] ?? []);
        imageUrls = List<String>.from(data?['imageUrls'] ?? []);
        isLoading = false;
      });
    }
  }

  void fetchRooms() async {
    try {
      var collection = FirebaseFirestore.instance.collection('roomdetails');
      var query = collection.where('availability', isEqualTo: 'Available');

      // Add filters based on provided parameters
      if (widget.Type.isNotEmpty) {
        query = query.where('type', isEqualTo: widget.Type);
      }
      if (widget.Gender.isNotEmpty) {
        query = query.where('gender', isEqualTo: widget.Gender);
      }
      if (widget.Rent.isNotEmpty) {
        query = query.where('rent', isEqualTo: widget.Rent);
      }
      if (widget.accommodationId.isNotEmpty) {
        query =
            query.where('accommodation_id', isEqualTo: widget.accommodationId);
      }

      var querySnapshot = await query.get();

      var fetchedRoomdetails = [
        for (var doc in querySnapshot.docs)
          {
            ...doc.data(),
            'id': doc.id,
          }
      ];

      if (mounted) {
        setState(() {
          roomdetails = fetchedRoomdetails;
        });
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accommodation Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display images
            if (imageUrls.isNotEmpty)
              SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            // Display accommodation details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accommodationName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Address: $address',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Cityname: $cityName',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'District: $districtName',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'State: $stateName',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Name: $name',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Phone: $phone',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Rules: $rules',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Amenities:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Display amenities
                  for (var amenity in amenities)
                    Text(
                      '- $amenity',
                      style: TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            // Display available rooms
            // Display available rooms
            if (roomdetails.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: roomdetails.length,
                itemBuilder: (context, index) {
                  var room = roomdetails[index];
                  // Check if the room matches the parameters passed from the previous page

                  // Display room details
                  return Card(
                    child: ListTile(
                      title: Text(room['name'] ?? 'Loading...'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(room['type'] ?? 'Loading...'),
                          Text(room['rent'] ?? 'Loading...'),
                          Text(room['gender'] ?? 'Loading...'),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
