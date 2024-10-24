import 'package:flutter/material.dart';
import 'package:hoaks/view/fitur1.view.dart';

class HoaksDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // Light background
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(246, 255, 254, 255),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Hasil Deteksi Stress',
          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Stress Percentage
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF662D91), // Purple box color
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    '23%',
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hoaks',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.dangerous, // Emoji
                        size: 40.0,
                        color: Colors.yellow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Insomnia advice (Text Align Justify added here)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 190, 190, 190), // Darker box background
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text(
                'Insomnia. Ciptakan rutinitas malam yang tenang dengan membaca atau meditasi, hindari penggunaan perangkat elektronik sebelum tidur. Pastikan tidur nyaman dengan suhu yang baik, pencahayaan yang redup, dan tanpa kebisingan.',
                style: TextStyle(
                    fontSize: 16.0, color: Color.fromARGB(255, 0, 0, 0)),
                textAlign:
                    TextAlign.justify, // This aligns the text in justify format
              ),
            ),
            const SizedBox(height: 20),

            // Back Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HoaxDetectionPage()),
                );
                // Add your analyze button functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
                textStyle: const TextStyle(
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
                    Icons.logout,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Kembali',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
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

  void main() {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HoaksDetectionPage(),
    ));
  }
}
