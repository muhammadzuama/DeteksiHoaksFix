import 'package:flutter/material.dart';
import 'package:hoaks/view/login.view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Halaman profil untuk logout
class ProfilePage extends StatefulWidget {
  final int userId;

  ProfilePage({required this.userId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? userName;
  String? userEmail;
  String? userPassword;

  // Fungsi untuk mengambil data profil
  Future<void> fetchProfile() async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.3:5000/profile?user_id=${widget.userId}'), // Ganti dengan URL API yang sesuai
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      // Menangani error jika tidak dapat mengambil data profil
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Unable to fetch profile data'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  // Fungsi untuk logout
  Future<void> logout() async {
    // Menghapus user_id dan data pengguna lainnya dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    prefs.remove('user_name');
    prefs.remove('user_email');
    prefs.remove('user_password');

    // Navigasi kembali ke halaman login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }

  @override
  void initState() {
    super.initState();
    // Ambil data pengguna dari SharedPreferences
    _getUserData();
    fetchProfile();
  }

  // Fungsi untuk mengambil data pengguna dari SharedPreferences
  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? 'User';
      userEmail = prefs.getString('user_email') ?? 'Not available';
      userPassword = prefs.getString('user_password') ?? 'Not available';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueGrey, // Ganti dengan warna yang diinginkan
        actions: [
          // Tombol Edit Profile
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Fungsi untuk mengubah profil (bisa diarahkan ke halaman edit profil)
              // Ganti dengan fungsionalitas sesuai aplikasi Anda
              print("Edit Profile pressed");
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('Profile data not found'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menampilkan gambar profil
                      const Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('images/profile_picture.png'),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Menampilkan pesan selamat datang dan data pengguna
                      Text(
                        'Welcome, $userName!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Username: $userName',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: $userEmail',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Password: $userPassword', // Menampilkan password
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),

                      // Tombol Logout
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: logout,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ), // Warna tombol
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text('Logout',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tombol Ubah Profil
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Fungsi untuk mengubah profil
                            // Ganti dengan fungsionalitas sesuai aplikasi Anda
                            print("Edit Profile pressed");
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ), // Warna tombol
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text('Edit Profile',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
