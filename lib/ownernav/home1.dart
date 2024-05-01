import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/components/navigation.dart';
import 'package:p/ownernav/accdetails.dart';
import 'package:p/ownernav/add1.dart';
import 'package:p/ownernav/update.dart';

class home1 extends StatefulWidget {
  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<home1> {
  String userName = '';
  List<Map<String, dynamic>> accommodations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchStations();
  }

  void fetchUserData() async {
    try {
      String name = await fetchUserName();
      setState(() {
        userName = name;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<String> fetchUserName() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        var userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        return userDoc['name'] ?? '';
      } catch (e) {
        throw Exception('Error fetching user data: $e');
      }
    }
    throw Exception('Current user is null');
  }

  void fetchStations() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No user logged in');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var collection = FirebaseFirestore.instance.collection('accommodation');
      var querySnapshot =
          await collection.where('userId', isEqualTo: currentUser.uid).get();

      var fetchedAccommodations = querySnapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();

      setState(() {
        accommodations = fetchedAccommodations;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching accommodations: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Welcome  $userName', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: accommodations.length,
              itemBuilder: (BuildContext context, int index) {
                var acco = accommodations[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.home),
                    title: Text(
                        acco['accommodationName'] ?? 'Unknown Accommodation'),
                    subtitle: Text(acco['name'] ?? 'No name Info'),
                    trailing: IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => accdetails(
                              accommodationId: acco['id'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

