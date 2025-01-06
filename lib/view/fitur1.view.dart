import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hoaks/util/global.color.dart';
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

    final wordCount = inputText.split(RegExp(r'\s+')).length;
    if (wordCount < 20 || wordCount > 1200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Validasi Jumlah Kata"),
          content: Text(
              "Jumlah kata yang dimasukkan adalah $wordCount kata. Jumlah kata harus antara 40 hingga 1.200."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    try {
      final url = Uri.parse("https://j3wm37sm-5000.asse.devtunnels.ms/predict");

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Deteksi Teks",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: "Masukkan teks untuk Deteksi",
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple, width: 2.0),
                ),
              ),
              maxLines: 5,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: fetchPredictions,
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.button,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 135),
                elevation: 5,
              ),
              icon: Icon(
                Icons.auto_awesome_outlined,
                color: Colors.white,
                size: 20.0,
              ),
              label: const Text("Analyze",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 16.0),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
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
      final timestamp = DateTime.now().toIso8601String().replaceAll(":", "-");
      final fileName = "deteksi_$timestamp.txt";

      final directory = Directory('/storage/emulated/0/Download/Deteksi Hoaks');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final file = File('${directory.path}/$fileName');
      await file.writeAsString(text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File disimpan di: ${file.path}"),
        ),
      );
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Hasil Deteksi",
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: GlobalColors.button,
        iconTheme: IconThemeData(
          color: Colors.white, // Mengubah warna ikon menjadi putih
        ),
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
                  textAlign: TextAlign.justify,
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: PredictionPage(),
//     theme: ThemeData(primarySwatch: Colors.deepPurple),
//   ));
// }
