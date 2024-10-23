import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

Future<Map<String, String>> fetchArticle(String url) async {
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the HTML document
      var document = parse(response.body);

      // Modify these selectors based on the actual HTML structure of the articles you're targeting
      String title = document.querySelector('h1')?.text ??
          'No Title'; // Assuming the title is in an <h1> tag
      String? content = document
          .querySelector('p')
          ?.text; // Assuming the first paragraph contains the main content

      // Return title and content as a map
      return {
        'title': title,
        'content': content ?? 'No Content',
      };
    } else {
      throw Exception('Failed to load article');
    }
  } catch (e) {
    return {
      'title': 'Error',
      'content': 'Error fetching article: $e',
    };
  }
}
