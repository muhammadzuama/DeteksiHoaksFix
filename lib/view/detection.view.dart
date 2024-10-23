import 'package:flutter/material.dart';
import 'package:hoaks/trial/web.view.dart';
import 'package:hoaks/view/fitur1.view.dart';

class DetectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deteksi Hoaks'),
        backgroundColor: const Color.fromARGB(255, 107, 128, 156),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HoaxFeature(
                    imagePath: 'images/image4.png',
                    title: 'Deteksi Hoaks Copy ',
                    subtitle:
                        'Deteksi Hoaks dengan copy paste berita atau headline',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HoaxDetectionPage()),
                      );
                      // Implement the onTap action
                    },
                  ),
                  HoaxFeature(
                    imagePath: 'images/image5.png',
                    title: 'Deteksi Hoaks With Link',
                    subtitle: 'Deteksi Hoaks dengan link',
                    onTap: () {
                      // Implement the onTap action
                    },
                  ),
                  HoaxFeature(
                    imagePath: 'images/image5.png',
                    title: 'Deteksi Hoaks With Link',
                    subtitle: 'Tahap Pengembangan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArticleFetcherPage()),
                      );
                      // Implement the onTap action
                    },
                  ),
                ],
              ),
            ],
          ),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
