import 'package:flutter/material.dart';
import 'package:hoaks/trial/fetch.dart';
import 'package:hoaks/util/global.color.dart';

class ArticleFetcherPage extends StatefulWidget {
  @override
  _ArticleFetcherPageState createState() => _ArticleFetcherPageState();
}

class _ArticleFetcherPageState extends State<ArticleFetcherPage> {
  final TextEditingController _urlController = TextEditingController();
  String _articleTitle = '';
  String _articleContent = '';
  bool _isLoading = false;
  String? _errorMessage;

  void _fetchArticle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String url = _urlController.text;

    try {
      // Fetch the article
      Map<String, String> result = await fetchArticle(url);

      setState(() {
        _articleTitle = result['title'] ?? 'No Title';
        _articleContent = result['content'] ?? 'No Content';
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Failed to load article. Please check the URL and try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              onPressed: _fetchArticle,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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
            if (_articleTitle.isNotEmpty && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _articleTitle,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(_articleContent),
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
