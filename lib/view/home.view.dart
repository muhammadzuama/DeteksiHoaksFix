import 'package:flutter/material.dart';
import 'package:hoaks/view/about.view.dart';
import 'package:hoaks/view/detection.view.dart';
import 'package:hoaks/view/edu.view.dart';
import 'package:hoaks/view/history.view.dart';
import 'package:hoaks/view/profile.view.dart'; // Import halaman profil pengguna
import 'package:shared_preferences/shared_preferences.dart'; // Untuk SharedPreferences

class Homepage extends StatefulWidget {
  final int userId; // User ID diterima melalui konstruktor

  Homepage({required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  late PageController _pageController;
  String _userName = 'User'; // Untuk nama pengguna
  int? _userId; // Jadikan nullable untuk menghindari late initialization error

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _loadUserData(); // Memuat data pengguna dari SharedPreferences
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk memuat data pengguna
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil user_id dari SharedPreferences
      _userId = prefs.getInt('user_id') ?? widget.userId;
      _userName =
          prefs.getString('user_name') ?? 'User'; // Mendapatkan nama pengguna
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color iconColor = const Color.fromARGB(255, 1, 25, 70);

    // Jika data belum selesai dimuat, tampilkan indikator loading
    if (_userId == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: [
            // Halaman Utama (Home)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Menampilkan pesan selamat datang
                    Text(
                      'Selamat datang, $_userName',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        HoaxFeature(
                          imagePath: 'images/image4.png',
                          title: 'Detect Hoax',
                          subtitle: 'Gunakan AI untuk Mendeteksi Hoax',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetectionView(userId: _userId!)),
                            );
                          },
                        ),
                        HoaxFeature(
                          imagePath: 'images/image5.png',
                          title: 'Edukasi',
                          subtitle: 'Lihat edukasi untuk menghindari hoax',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuUtamaPage()),
                            );
                          },
                        ),
                        HoaxFeature(
                          imagePath: 'images/image6.png',
                          title: 'Tentang Apps',
                          subtitle: 'Lihat profil dari aplikasi ini',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Halaman History
            HoaxCheckHistoryPage(userId: _userId!),
            // Halaman Profil Pengguna
            ProfilePage(userId: _userId!),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: iconColor,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }
}

class HoaxFeature extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const HoaxFeature({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
