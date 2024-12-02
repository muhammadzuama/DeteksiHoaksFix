import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String? _predictionResult;

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

  // Ambil artikel dan lakukan prediksi
  Future<void> _fetchAndPredictArticle() async {
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
      _predictionResult = null;
    });

    try {
      String articleContent = await fetchArticleContent(url);
      setState(() {
        _articleContent = articleContent;
      });
      await _detectHoax(articleContent);
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

  // Prediksi apakah artikel hoaks
  Future<void> _detectHoax(String articleContent) async {
    final Uri apiEndpoint = Uri.parse("http://192.168.1.4:5000/predict");

    try {
      final response = await http.post(
        apiEndpoint,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "texts": [articleContent]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final prediction = responseData['predictions']?[0]?['label'];
        setState(() {
          _predictionResult = prediction ?? 'Hasil tidak ditemukan.';
        });
      } else {
        setState(() {
          _errorMessage =
              'Gagal memuat prediksi. Status kode: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Kesalahan saat memproses prediksi: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Article'),
        backgroundColor: Colors.blueGrey,
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
              onPressed: _isLoading ? null : _fetchAndPredictArticle,
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
                  Text('Analyze', style: TextStyle(color: Colors.white)),
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
                      ),
                      const SizedBox(height: 20),
                      if (_predictionResult != null)
                        Text(
                          'Hoax Prediction: $_predictionResult',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
