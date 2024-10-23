import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Pengguna'),
        backgroundColor: const Color.fromARGB(255, 107, 128, 156),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Profil
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/profile_picture.png'),
              ),
            ),
            const SizedBox(height: 20),

            // Nama Pengguna
            Text(
              'Muhammad Zuama Al Amin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Email Pengguna
            Text(
              'zuama@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Keluar
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
                    Icons.edit,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add your analyze button functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 243, 0, 0),
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
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'LogOut',
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
