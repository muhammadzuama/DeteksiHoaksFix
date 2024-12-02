import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

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
