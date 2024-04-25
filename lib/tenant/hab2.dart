import 'package:flutter/material.dart';
import 'package:p/tenant/hab3.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Define primary and accent colors
  static const Color primaryColor =
      Color(0xFF0C0C0C); // Black with some darkness
  static const Color accentColor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Rental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: hab2(),
    );
  }
}

class hab2 extends StatelessWidget {
  final Future<ImageProvider> _imageFuture =
      Future<ImageProvider>.value(NetworkImage(
    'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FcbcmxVVQi7l7bydVexSq%2Fc41db057f751547631ccd2b6aeb7d2f4b9e35d95j7jje0r3d5961%201.png?alt=media&token=0d9fcf1d-cf42-4d95-ae37-695b9ec31923',
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF111416), // Set background color of app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Handle back button
            Navigator.of(context).pop();
          },
          color: Colors.white, // Set icon color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Handle more button
            },
            color: Colors.white, // Set icon color to white
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FutureBuilder<ImageProvider>(
                  future: _imageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child:
                              CircularProgressIndicator()); // Show loading indicator while image is being fetched
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error loading image')); // Show error message if image loading fails
                    } else {
                      return Image(
                          image: snapshot.data!,
                          fit: BoxFit.cover); // Display the loaded image
                    }
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFE1D5FF).withOpacity(
                          0.8), // Semi-transparent background color
                    ),
                    child: Text(
                      'Available',
                      style: TextStyle(
                        color: Colors.black, // Set text color to black
                        fontSize: 16,
                        height: 1.3,
                        fontFamily: 'FONTSPRING DEMO - Lufga ExtraBold',
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () {
                      // Handle icon tap
                    },
                    child: Image.network(
                      'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2F9e355e08e835a96e077f2b458ad365f1.png',
                      width: 20,
                      height: 18,
                      fit: BoxFit.contain,
                      color: Colors.black, // Set icon color to black
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Color(
                  0xFF0C0C0C), // Set background color to the specified color
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'St. Thomas Hostel',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Bharananganam, Pala',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Rs.3900 / Month',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '2 Beds • 1 bath • 1000m',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle more details
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(
                                    0xFF111416)), // Set button color to 0xFF111416
                          ),
                          child: Text('More Details'),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle book now
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => hab3()),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(
                                    0xFF111416)), // Set button color to 0xFF111416
                          ),
                          child: Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
