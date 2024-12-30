import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: GlobalColors.button,
        title: const Text(
          "Tentang Kami",
          style: TextStyle(color: Colors.white),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     onPressed: _loadFiles,
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Header
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage(
                        'images/image7.png'), // Ganti dengan path gambar Anda
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              // Judul dan Deskripsi
              const Text(
                'Tentang Aplikasi Deteksi Hoaks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Aplikasi Deteksi Hoaks adalah solusi inovatif yang dirancang untuk membantu masyarakat dalam mengidentifikasi informasi palsu dan menilai kebenaran berita yang beredar di media sosial dan platform online lainnya. Dengan menggunakan teknologi kecerdasan buatan dan pembelajaran mesin, aplikasi ini menganalisis konten berita dan memberikan penilaian yang akurat dan cepat.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify, // Menambahkan justify
              ),
              const SizedBox(height: 16),
              // Visi dan Misi
              _buildSectionTitle('Visi dan Misi'),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Visi kami adalah menciptakan masyarakat yang lebih cerdas dan kritis terhadap informasi yang diterima. Misi kami adalah menyediakan alat yang mudah diakses untuk mendeteksi hoaks dan meningkatkan literasi media di kalangan pengguna.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify, // Menambahkan justify
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Fitur Utama
              _buildSectionTitle('Fitur Utama'),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '- Deteksi Hoaks: Mengidentifikasi berita palsu berdasarkan analisis teks.\n'
                    '- Edukasi Pengguna: Memberikan informasi tentang cara mengenali hoaks.\n'
                    '- Laporan: Pengguna dapat melaporkan berita yang mereka curigai.\n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify, // Menambahkan justify
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tim Pengembang
              _buildSectionTitle('Tim Pengembang'),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Aplikasi ini dikembangkan oleh tim yang terdiri dari profesional di bidang teknologi informasi, analisis data, dan komunikasi. Kami berkomitmen untuk terus meningkatkan aplikasi ini agar dapat memberikan manfaat yang lebih besar bagi masyarakat.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify, // Menambahkan justify
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Kontak Kami
              _buildSectionTitle('Kontak Kami'),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Jika Anda memiliki pertanyaan atau masukan, jangan ragu untuk menghubungi kami di:\n'
                    'Email: support@deteksikoaks.com\n'
                    'Instagram: @deteksikoaks\n'
                    'Facebook: /deteksikoaks\n',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify, // Menambahkan justify
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
