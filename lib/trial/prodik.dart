import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:path_provider/path_provider.dart';

class PredictionPage1 extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

Future<String> fetchArticleContent(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var document = parse(response.body);
      String title = document.querySelector('h1')?.text.trim() ?? 'No Title';
      String content = document
          .querySelectorAll('p')
          .map((element) => element.text.trim())
          .where((text) =>
              text.isNotEmpty && !text.toLowerCase().contains('advertisement'))
          .join(' ');

      if (content.isEmpty) {
        throw Exception("Tidak ada konten artikel yang ditemukan.");
      }

      return '$title\n\n$content';
    } else {
      throw Exception(
          'Gagal memuat artikel. Kode status: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error fetching article: $e';
  }
}

class _PredictionPageState extends State<PredictionPage1> {
  final TextEditingController _urlController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> fetchPredictions(String url) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final inputText = await fetchArticleContent(url);

      if (inputText.startsWith('Error fetching article')) {
        setState(() {
          _errorMessage = inputText;
        });
        return;
      }

      final apiUrl = Uri.parse("http://192.168.1.7:5000/predict");

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
          final prediction =
              Map<String, dynamic>.from(responseData['predictions'][0]);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PredictionResultPage(
                originalText: prediction['original_text']?.toString() ?? 'N/A',
                predictedLabel: prediction['predicted_label'] ?? -1,
              ),
            ),
          );
        } else {
          setState(() {
            _errorMessage = "Data prediksi tidak ditemukan.";
          });
        }
      } else {
        setState(() {
          _errorMessage =
              "Gagal memuat prediksi. Kode status: ${response.statusCode}";
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

  bool isValidUrl(String url) {
    final Uri? parsedUrl = Uri.tryParse(url);
    return parsedUrl != null &&
        parsedUrl.hasScheme &&
        (parsedUrl.scheme == 'http' || parsedUrl.scheme == 'https');
  }

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
          ],
        ),
      ),
    );
  }
}

class PredictionResultPage extends StatelessWidget {
  final String originalText;
  final int predictedLabel;

  const PredictionResultPage({
    required this.originalText,
    required this.predictedLabel,
  });

  Future<void> saveToFile(BuildContext context, String text) async {
    try {
      // Show dialog to enter custom filename
      String? fileName = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          TextEditingController fileNameController = TextEditingController();
          return AlertDialog(
            title: const Text("Masukkan Nama File"),
            content: TextField(
              controller: fileNameController,
              decoration: const InputDecoration(
                hintText: "Nama file",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(fileNameController.text.trim());
                },
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      );

      if (fileName != null && fileName.isNotEmpty) {
        final directory = Directory('/storage/emulated/0/Download');
        final file = File('${directory.path}/$fileName.txt');
        await file.writeAsString(text);
        debugPrint("File saved at: ${file.path}");
      }
    } catch (e) {
      debugPrint("Failed to save file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData icon = predictedLabel == 0
        ? Icons.check_circle_outline
        : Icons.warning_amber_rounded;

    String label = predictedLabel == 0 ? "Valid" : "Hoaks";
    Color iconColor = predictedLabel == 0 ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Prediksi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 100.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              "Teks Asli:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  originalText,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                saveToFile(context, "Prediksi: $label\n\nTeks:\n$originalText");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Hasil prediksi disimpan.")),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text("Simpan Hasil"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PredictionPage1(),
  ));
}
