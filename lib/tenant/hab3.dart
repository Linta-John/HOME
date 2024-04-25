import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: hab3(),
    );
  }
}

class hab3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(
          255, 0, 0, 0), // Adjust the color to match the background
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green, // Adjust the color to match the icon
            ),
            SizedBox(
                height: 20), // Provides space between the icon and the text
            Text(
              'Booking Successful',
              style: TextStyle(
                color: Colors.white, // Text color inside the TextField
              ),
            ),
            SizedBox(height: 10), // Provides space between the text elements
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'The Booking has been successfully purchased. Thank you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white, // Text color inside the TextField
                ),
              ),
            ),
            SizedBox(height: 30), // Space before the button
            ElevatedButton(
              onPressed: () {
                // Handle the button press
              },
              child: Text('MORE DETAILS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Button background color
                foregroundColor: Colors.white, // Button text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
