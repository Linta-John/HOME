import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:p/components/navigation.dart';
import 'package:p/ownernav/accdetails.dart';
import 'package:p/ownernav/add1.dart';
import 'package:p/ownernav/update.dart';

class home1 extends StatefulWidget {
  @override
  _home1State createState() => _home1State();
}

class _home1State extends State<home1> {
  List<Map<String, dynamic>> accomodations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  void fetchStations() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print('No user logged in');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    try {
      var collection = FirebaseFirestore.instance.collection('accommodation');
      var querySnapshot =
          await collection.where('userId', isEqualTo: currentUser.uid).get();

      var fetchedAccomodations = [
        for (var doc in querySnapshot.docs)
          {
            ...doc.data(),
            'id': doc.id,
          }
      ];

      if (mounted) {
        setState(() {
          accomodations = fetchedAccomodations;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching accomodations: $e');
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
        title: const Text('WELCOME...', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: accomodations.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == accomodations.length) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const add1(),
                        ),
                      );
                    },
                  );
                } else {
                  var acco = accomodations[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(
                          acco['accommodationName'] ?? 'Unknown Accommodation'),
                      subtitle: Text(acco['name'] ?? 'No name Info'),
                      trailing: IconButton(
                        icon: const Icon(Icons.chevron_right),
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
                }
              },
            ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
