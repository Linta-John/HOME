import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class accommodationscreen extends StatefulWidget {
  final String accommodationId;
  final String Rent;
  final String Gender;
  final String Type;
  const accommodationscreen({
    required this.accommodationId,
    required this.Rent,
    required this.Gender,
    required this.Type,
  });
  @override
  _accommodationscreenState createState() => _accommodationscreenState();
}

class _accommodationscreenState extends State<accommodationscreen> {
  bool showRooms = true;
  bool showAmenities = false;
  bool showReviews = false;
  int currentIndex = 0;
  late String accommodationName;
  late String stateName;
  late String districtName;
  late String cityName;
  late String address;
  late String phone;
  late String name;
  late String rules;
  bool is24Hours = false;
  List<Map<String, dynamic>> roomdetails = [];
  List<String> imageUrls = [];
  List<String> amenities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchRooms();
  }

  Future<void> fetchDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('accommodation')
          .doc(widget.accommodationId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        accommodationName = data['accommodationName'] ?? '';
        stateName = data['stateName'] ?? '';
        districtName = data['districtName'] ?? '';
        cityName = data['cityName'] ?? '';
        address = data['address'] ?? '';
        name = data['name'] ?? '';
        phone = data['phone'] ?? '';
        rules = data['rules'] ?? '';
        amenities = List<String>.from(data['amenities'] ?? []);
        is24Hours = data['is24Hours'] ?? false;
        imageUrls = List<String>.from(data['imageUrls'] ?? []);
        setState(() {});
      }
    } catch (e) {
      print('Error fetching accommodation details: $e');
    }
  }

  void fetchRooms() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('roomdetails')
          .where('availability', isEqualTo: 'available')
          .where('type', isEqualTo: widget.Type)
          .where('gender', isEqualTo: widget.Gender)
          .where('rent', isEqualTo: widget.Rent)
          .where('accommodation_id', isEqualTo: widget.accommodationId)
          .get();

      var fetchedRooms = querySnapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();

      setState(() {
        roomdetails = fetchedRooms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching rooms: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> navTitles = ["ROOMS", "AMENITIES", "REVIEWS"];
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              buildImageCarousel(),
              Positioned(
                top: 20.0,
                left: 5.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: const Color.fromARGB(255, 12, 12, 12)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                if (roomdetails.isNotEmpty)
                  Column(
                    children: roomdetails.map((room) {
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    room['name'] != null
                                        ? room['name']
                                        : 'Name not available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    room['type'] != null
                                        ? room['type']
                                        : 'Type not available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    room['gender'] != null
                                        ? room['gender']
                                        : 'Gender not available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    room['rent'] != null
                                        ? room['rent']
                                        : 'Rent not available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              SizedBox(height: 10),
                              TimeSlot(
                                startDate: DateFormat('dd/MM/yy')
                                    .format(DateTime.now()),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                if (showAmenities) buildAmenitiesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAmenitiesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amenities:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: amenities
              .map((amenity) => Text(
                    amenity,
                    style: TextStyle(color: Colors.grey[600]),
                  ))
              .toList(),
        ),
        SizedBox(height: 10),
        Text(
          "Rules:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          rules,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget buildImageCarousel() {
    return SizedBox(
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
    );
  }
}

class TimeSlot extends StatelessWidget {
  final String startDate;
  const TimeSlot({
    Key? key,
    required this.startDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(startDate),
        ],
      ),
    );
  }
}
