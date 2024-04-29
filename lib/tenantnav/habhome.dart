import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Changed from 'package:flutter_svg/svg.dart';
import 'package:p/components/tenantnavigation.dart';
import 'package:p/tenantnav/accommodationscreen.dart';
import 'package:p/tenantnav/filter.dart';

class habhome extends StatefulWidget {
  @override
  State<habhome> createState() => _habhomeState();
}

class _habhomeState extends State<habhome> {
  var selectedRoomType = '';
  var selectedRent = '';

  late final Stream<List<DocumentSnapshot<Map<String, dynamic>>>> _stream;
  final CollectionReference _accommodationReference =
      FirebaseFirestore.instance.collection('accommodation');
  final CollectionReference _roomdetailsReference =
      FirebaseFirestore.instance.collection('roomdetails');

  @override
  void initState() {
    super.initState();
    _stream = _roomdetailsReference
        .where('availability', isEqualTo: 'Available')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc as DocumentSnapshot<Map<String, dynamic>>)
            .toList());
  }

  Future<List<Map<String, dynamic>>> fetchDetails() async {
    QuerySnapshot roomSnapshot;

    if (selectedRoomType != null &&
        selectedRoomType.isNotEmpty &&
        selectedRent != null &&
        selectedRent.isNotEmpty) {
      roomSnapshot = await _roomdetailsReference
          .where('availability', isEqualTo: 'Available')
          .where('type', isEqualTo: selectedRoomType)
          .where('rent', isEqualTo: selectedRent)
          .get();
    } else {
      roomSnapshot = await _roomdetailsReference
          .where('availability', isEqualTo: 'Available')
          .get();
    }

    if (roomSnapshot.docs.isEmpty) {
      // No stations found with the selected connector type
      return Future.value([]);
    }

    List<String> availableAccommodationIds = roomSnapshot.docs
        .map((doc) => doc['accommodation_id'] as String)
        .toList();

    QuerySnapshot accommodationSnapshot = await _accommodationReference
        .where(FieldPath.documentId, whereIn: availableAccommodationIds)
        .get();

    return accommodationSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/image/home1.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Accommodations',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icon/sliders-solid.svg',
                        width: 20,
                        height: 20,
                      ),
                      onPressed: () async {
                        var filters = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FilterPage()),
                        );
                        if (filters != null) {
                          setState(() {
                            selectedRoomType = filters['selectedRoomType'];
                            selectedRent = filters[
                                'selectedRent']; // Corrected the variable name
                          });
                        }
                      },
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchDetails(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Error: ${snapshot.error.toString()}'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<Map<String, dynamic>> documents = snapshot.data!;
                  return documents.isEmpty
                      ? Center(child: Text('No results found'))
                      : ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            var doc = documents[index];
                            return ListTile(
                              title: Text(doc['accommodationName'] ?? 'N/A'),
                              subtitle: Text(
                                  '${doc['address'] ?? 'N/A'}, ${doc['cityName'] ?? 'N/A'}, ${doc['districtName'] ?? 'N/A'}, ${doc['stateName'] ?? 'N/A'}'),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            accommodationscreen())); // Changed to AccommodationScreen
                              },
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
