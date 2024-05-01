import 'package:p/components/tenantnavigation.dart';
import 'package:flutter/material.dart';

class habchat extends StatefulWidget {
  @override
  State<habchat> createState() => _Trip();
}

class _Trip extends State<habchat> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              "CHAT",
              style: TextStyle(fontSize: 50),
            )
          ],
        ),
      ),
      bottomNavigationBar: Navigation(),
    );
  }
}
