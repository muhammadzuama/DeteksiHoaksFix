import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoaks/trial/fetch.dart';
import 'package:hoaks/util/global.color.dart';

class ArticleFetcherPage extends StatefulWidget {
  @override
  _ArticleFetcherPageState createState() => _ArticleFetcherPageState();
}

class _ArticleFetcherPageState extends State<ArticleFetcherPage> {
  final TextEditingController _urlController = TextEditingController();
  String _articleContent = '';
  bool _isLoading = false;
  String? _errorMessage;

  // Validasi URL dengan Regex
  bool _isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    final RegExp regex = RegExp(
      r'^(http|https):\/\/[^\s$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return uri != null &&
        uri.hasScheme &&
        uri.hasAuthority &&
        regex.hasMatch(url);
  }

  // Ambil artikel dari URL
  Future<void> _fetchArticle() async {
    String url = _urlController.text.trim();
    if (!_isValidUrl(url)) {
      setState(() {
        _errorMessage = 'URL tidak valid. Masukkan URL yang benar.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _articleContent = '';
    });

    try {
      String articleContent = await fetchArticleContent(url);
      setState(() {
        _articleContent = articleContent;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Kesalahan saat memuat data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Salin konten artikel ke clipboard
  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _articleContent));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konten artikel disalin ke clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ambil Content Berita",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: GlobalColors.button,
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna ikon menjadi putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                hintText: 'Paste article link here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchArticle,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.button,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 16.0),
                textStyle: const TextStyle(
                    fontSize: 16.0, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_outlined, color: Colors.white),
                  SizedBox(width: 10.0),
                  Text('Cek Berita', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            if (_articleContent.isNotEmpty && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _articleContent,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _copyToClipboard,
                        icon: const Icon(Icons.copy, color: Colors.white),
                        label: const Text(
                          'Copy Text Berita',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GlobalColors.button,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    home: ArticleFetcherPage(),
  ));
}
