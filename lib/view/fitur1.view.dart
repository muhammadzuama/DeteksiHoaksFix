import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';

class HoaxDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Deteksi Hoaks',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Make the AppBar background transparent
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
                hintText: 'Paste berita atau headline di sini',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add your analyze button functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.button,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Set your desired border radius
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Analyze',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HoaxDetectionPage(),
  ));
}
