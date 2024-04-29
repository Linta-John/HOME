import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
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
          Expanded(
            child: Container(
              color: Colors.white,
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
                  return documents.isEmpty?Center(child:Text('No results found')):
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var doc = documents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                             MaterialPageRoute(
                                builder: (context) => accommodationscreen(accommodationId: doc['accommodationId']),
                              ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: Image.network(
                                    doc['imageUrls'][0],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  doc['accommodationName'] ?? 'N/A',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
