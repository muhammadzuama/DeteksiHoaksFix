import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>>? _predictions;
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
      _predictions = null;
    });

    try {
      // Endpoint API
      final url = Uri.parse("http://192.168.1.4:5000/predict");

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

        if (responseData['predictions'] != null) {
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Teks Asli: ${prediction['original_text']}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  // Text("Teks Bersih: ${prediction['cleaned_text']}"),
                  Text("Label Prediksi: ${prediction['predicted_label']}"),
                  // Text(
                  //     "Probabilitas: ${prediction['prediction_probabilities']}"),
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
    home: PredictionPage(),
  ));
}
