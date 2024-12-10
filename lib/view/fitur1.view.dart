import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController _textController = TextEditingController();
  String? _errorMessage;

  Future<void> fetchPredictions() async {
    final String inputText = _textController.text.trim();

    if (inputText.isEmpty) {
      setState(() {
        _errorMessage = "Teks tidak boleh kosong.";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      // Endpoint API
      final url = Uri.parse("http://192.168.1.7:5000/predict");

      // Request ke API
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "texts": [inputText]
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['predictions'] != null &&
            responseData['predictions'].isNotEmpty) {
          final prediction = responseData['predictions'][0];
          final predictedLabel = prediction['predicted_label'];
          final originalText = prediction['original_text'];

          // Navigasi ke halaman hasil prediksi
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PredictionResultPage(
                originalText: originalText,
                predictedLabel: predictedLabel,
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
              "Gagal memuat prediksi. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediksi Teks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Masukkan teks untuk prediksi",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: fetchPredictions,
              child: const Text("Prediksi"),
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
      // Tampilkan dialog untuk meminta nama file
      String? fileName = await showDialog<String>(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController();
          return AlertDialog(
            title: const Text("Masukkan Nama File"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Nama file"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text("Simpan"),
              ),
            ],
          );
        },
      );

      if (fileName != null && fileName.isNotEmpty) {
        // Direktori penyimpanan
        final directory = Directory('/storage/emulated/0/Download');
        if (!directory.existsSync()) {
          directory.createSync(recursive: true);
        }
        final file = File('${directory.path}/$fileName.txt');
        await file.writeAsString(text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File berhasil disimpan di: ${file.path}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menyimpan file: $e")),
      );
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
    home: PredictionPage(),
  ));
}
