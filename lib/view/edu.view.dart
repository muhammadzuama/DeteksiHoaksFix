import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MenuUtamaPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MenuUtamaPage extends StatelessWidget {
  final List<Map<String, String>> articles = [
    {
      'title': 'Cara Menghindari Hoaks di Media Sosial',
      'description':
          'Pelajari tips penting untuk mengenali berita palsu di media sosial agar tidak mudah tertipu.',
      'image':
          'https://cdnpro.eraspace.com/media/mageplaza/blog/post/d/i/digitaltech.jpg', // Gambar URL
    },
    {
      'title': 'Peran Teknologi dalam Memerangi Hoaks',
      'description':
          'Bagaimana teknologi seperti AI membantu mendeteksi berita palsu dan memerangi penyebarannya.',
      'image':
          'https://pascasarjana.umsu.ac.id/wp-content/uploads/2023/05/Screenshot-2023-05-05-114423.png',
    },
    {
      'title': 'Mengapa Penting Memverifikasi Berita?',
      'description':
          'Memahami dampak dari menyebarkan berita palsu dan pentingnya memverifikasi setiap informasi yang diterima.',
      'image': 'https://sulselprov.go.id/upload/post/5804a44801593.jpg',
    },
    {
      'title': 'Kenali Ciri-ciri Judul Berita Hoaks',
      'description':
          'Salah satu cara mudah untuk mengenali hoaks adalah dengan melihat ciri-ciri judul yang berlebihan.',
      'image': 'https://sulselprov.go.id/upload/post/5804a44801593.jpg',
    },
    {
      'title': 'Fakta vs. Opini: Bagaimana Membedakannya?',
      'description':
          'Sering kali hoaks menyamarkan opini sebagai fakta. Pelajari cara membedakan keduanya.',
      'image': 'https://sulselprov.go.id/upload/post/5804a44801593.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel Edukasi Hoaks'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return _buildArticleCard(
              context,
              articles[index]['title']!,
              articles[index]['description']!,
              articles[index]['image']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildArticleCard(
      BuildContext context, String title, String description, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar ditambahkan di sini
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover, // Menyesuaikan gambar sesuai kartu
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailArticlePage(title: title)),
                      );
                    },
                    child: Text(
                      'Baca Selengkapnya',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailArticlePage extends StatelessWidget {
  final String title;

  DetailArticlePage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Ini adalah detail dari artikel "$title". Konten lengkap akan ditampilkan di sini.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
