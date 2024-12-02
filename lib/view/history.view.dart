import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// void main() {
//   runApp(MaterialApp(
//     home: HoaxCheckHistoryPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class HoaxCheckHistoryPage extends StatelessWidget {
  final int userId; // User ID diterima melalui konstruktor
  HoaxCheckHistoryPage({required this.userId});
  // Dummy data untuk riwayat pengecekan hoaks
  final List<HoaxCheckHistory> history = [
    HoaxCheckHistory(
        input: 'Hoaks tentang vaksin',
        status: 'Hoaks',
        date: DateTime.now().subtract(Duration(days: 1))),
    HoaxCheckHistory(
        input: 'Berita gempa bumi besar',
        status: 'Benar',
        date: DateTime.now().subtract(Duration(days: 2))),
    HoaxCheckHistory(
        input: 'Promo handphone murah',
        status: 'Hoaks',
        date: DateTime.now().subtract(Duration(days: 3))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pengecekan Hoaks'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            return _buildHistoryCard(history[index]);
          },
        ),
      ),
    );
  }

  Widget _buildHistoryCard(HoaxCheckHistory historyItem) {
    // Format tanggal
    final DateFormat formatter = DateFormat('dd MMM yyyy, HH:mm');
    String formattedDate = formatter.format(historyItem.date);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      shadowColor: Colors.blueAccent.withOpacity(0.3),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input: ${historyItem.input}',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            SizedBox(height: 5),
            Text(
              'Status: ${historyItem.status}',
              style: TextStyle(
                fontSize: 16,
                color:
                    historyItem.status == 'Hoaks' ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Date: $formattedDate',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}

// Model untuk Riwayat Pengecekan Hoaks
class HoaxCheckHistory {
  final String input;
  final String status;
  final DateTime date;

  HoaxCheckHistory(
      {required this.input, required this.status, required this.date});
}
