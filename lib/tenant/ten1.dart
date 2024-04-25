import 'package:flutter/material.dart';
import 'package:p/tenant/hab2.dart';

void main() => runApp(HomeConnectApp());

class HomeConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness:
            Brightness.dark, // Assuming a dark theme from the screenshot
      ),
      home: ten1(),
    );
  }
}

class ten1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 15, // Adjust width to half the original size
          height: 15, // Adjust height to half the original size
          child: Image.network(
            'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2F1980c60d35a3cb908829f5a8d4fddb26.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          'HomeConnect',
          style: TextStyle(
            color: Color(0xFFE1D5FF), // Set text color to 0xFFE1D5FF
            fontFamily:
                'FONTSPRING DEMO - Lufga ExtraBold', // Apply custom font
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://via.placeholder.com/150'), // Replace with actual image URL
          ),
        ],
        backgroundColor: Colors.black, // Assuming from the screenshot
        elevation: 0, // No shadow
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Find your new hostels, rooming house and more',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.tune), // Using built-in icon
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Tab controls for Nearby, Recommended, Upcoming
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(context, 'Nearby'),
                _buildTabButton(context, 'Recommended'),
                _buildTabButton(context, 'Upcoming'),
              ],
            ),
            // Card for hostel with an image
            Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3, // Aspect ratio of 4:3
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FcbcmxVVQi7l7bydVexSq%2Fc41db057f751547631ccd2b6aeb7d2f4b9e35d95j7jje0r3d5961%201.png?alt=media&token=e8e5ad22-fd95-4142-8827-ec904a232351', // Replace with actual image URL
                        fit: BoxFit.fill, // Fill the area
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('St.Thomas Hostel'),
                    subtitle: Text('Rs.3900 / Month'),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Icon(Icons.king_bed), // Using built-in icon
                        Text('200 rooms - 5ba - 3000m'),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          // Call action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          // Message action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => hab2()),
                          );
                          // Info action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Another card with same details
            Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3, // Aspect ratio of 4:3
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FcbcmxVVQi7l7bydVexSq%2Fc35cc1166f519ef252d014ec8bed4c0ed789c2b41yw9e7r3d5961%201.png?alt=media&token=6484b309-5adc-4822-8dae-c369ce3ec49b', // Replace with actual image URL
                        fit: BoxFit.fill, // Fill the area
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('St.George Hostel'), // Changed title
                    subtitle: Text('Rs.4000 / Month'), // Changed subtitle
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Icon(Icons.king_bed), // Using built-in icon
                        Text('150 rooms - 5ba - 3000m'),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          // Call action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          // Message action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          // Info action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Another card with same details but different title and subtitle
            Card(
              margin: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3, // Aspect ratio of 4:3
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        'https://firebasestorage.googleapis.com/v0/b/codeless-app.appspot.com/o/projects%2FcbcmxVVQi7l7bydVexSq%2Fc35cc1166f519ef252d014ec8bed4c0ed789c2b41yw9e7r3d5961%201.png?alt=media&token=6484b309-5adc-4822-8dae-c369ce3ec49b', // Replace with actual image URL
                        fit: BoxFit.fill, // Fill the area
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('St.Joseph\'s Hostel'), // Changed title
                    subtitle: Text('Rs.3500 / Month'), // Changed subtitle
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: <Widget>[
                        Icon(Icons.king_bed), // Using built-in icon
                        Text('150 rooms - 5ba - 3000m'),
                      ],
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.call),
                        onPressed: () {
                          // Call action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.message),
                        onPressed: () {
                          // Message action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          // Info action
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Color(0xFFE1D5FF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Handle first icon tap
              },
              child: Image.network(
                'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2F74ccbf7c59483981ec0ac52692953931.png',
                width: 21,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle second icon tap
              },
              child: Image.network(
                'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2F33621f47ccf42eb1daf4c57ff44e2c95.png',
                width: 21,
                height: 22,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle third icon tap
              },
              child: Image.network(
                'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2F09fb31154281bbe7ef5d94dfe6174251.png',
                width: 22,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Handle fourth icon tap
              },
              child: Image.network(
                'https://storage.googleapis.com/codeless-dev.appspot.com/uploads%2Fimages%2FcbcmxVVQi7l7bydVexSq%2Fb9d0bdc5ea1974c8ae94892d4cef5e09.png',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title) {
    return ElevatedButton(
      onPressed: () {
        // Handle tab switch
      },
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.black12), // Background color
        foregroundColor:
            MaterialStateProperty.all<Color>(Colors.white), // Text color
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
    );
  }
}
