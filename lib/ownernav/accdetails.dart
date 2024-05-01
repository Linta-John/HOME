import 'package:flutter/material.dart';
import 'package:p/ownernav/update.dart';
import 'package:p/ownernav/update1.dart';

class accdetails extends StatelessWidget {
  final String accommodationId;
  accdetails({required this.accommodationId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            update1(accommodationId: accommodationId)));
              },
              child: Text('Add Room Details'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            update(accommodationId: accommodationId)));
              },
              child: Text('Update Existing Details'),
            ),
          ],
        ),
      ),
    );
  }
}
