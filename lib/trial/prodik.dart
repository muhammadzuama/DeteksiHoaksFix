import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class PredictionPage1 extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

Future<String> fetchArticleContent(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the HTML document
      var document = parse(response.body);

      // Ambil judul artikel, asumsi berada di tag <h1>
      String title = document.querySelector('h1')?.text.trim() ?? 'No Title';

      // Ambil semua elemen <p> sebagai konten artikel
      String content = document
          .querySelectorAll('p') // Ambil semua elemen <p>
          .map((element) => element.text.trim()) // Ekstrak teks dari elemen
          .where((text) =>
              text.isNotEmpty &&
              !text.toLowerCase().contains(
                  'advertisement')) // Hapus teks kosong dan kata 'advertisement'
          .join(' '); // Gabungkan semua paragraf dalam satu baris

      // Gabungkan judul dan konten
      return '$title $content';
    } else {
      throw Exception('Failed to load article');
    }
  } catch (e) {
    return 'Error fetching article: $e';
  }
}

class _PredictionPageState extends State<PredictionPage1> {
  final TextEditingController _urlController = TextEditingController();
  List<Map<String, dynamic>>? _predictions;
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> fetchPredictions(String url) async {
    final String inputText =
        await fetchArticleContent(url); // Fetch content from URL

    if (inputText.isEmpty || inputText == 'Error fetching article: null') {
      setState(() {
        _errorMessage = "Teks artikel tidak ditemukan.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _predictions = null;
    });

    try {
      // Endpoint API
      final apiUrl = Uri.parse("http://192.168.1.4:5000/predict");

      // Request ke API dengan teks artikel
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "texts": [inputText]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['predictions'] != null &&
            responseData['predictions'].isNotEmpty) {
          setState(() {
            _predictions =
                List<Map<String, dynamic>>.from(responseData['predictions']);
          });
        } else {
          setState(() {
            _errorMessage = "Data prediksi tidak ditemukan.";
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Gagal memuat prediksi. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memvalidasi URL
  bool isValidUrl(String url) {
    final Uri? parsedUrl = Uri.tryParse(url);
    return parsedUrl != null &&
        parsedUrl.hasScheme &&
        (parsedUrl.scheme == 'http' || parsedUrl.scheme == 'https');
  }

  // Fungsi untuk menampilkan popup error
  void showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediksi Teks dari URL"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "Masukkan URL artikel",
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      String url = _urlController.text.trim();
                      if (url.isEmpty) {
                        showErrorPopup("URL tidak boleh kosong.");
                      } else if (!isValidUrl(url)) {
                        showErrorPopup(
                            "URL tidak valid. Pastikan URL dimulai dengan http:// atau https://");
                      } else {
                        fetchPredictions(url);
                      }
                    },
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Prediksi"),
            ),
            const SizedBox(height: 16.0),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_predictions != null) _buildPredictionResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionResults() {
    return Expanded(
      child: ListView.builder(
        itemCount: _predictions!.length,
        itemBuilder: (context, index) {
          final prediction = _predictions![index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Teks Artikel:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(prediction['original_text']?.toString() ?? 'N/A'),
                  const SizedBox(height: 8.0),
                  const Text(
                    "Label Prediksi:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Pastikan konversi data menjadi string
                  Text(prediction['predicted_label']?.toString() ?? 'N/A'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PredictionPage1(),
  ));
}
