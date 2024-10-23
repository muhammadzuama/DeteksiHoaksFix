import 'package:flutter/material.dart';
import 'package:hoaks/trial/fetch.dart';

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

    // Fetch the article
    Map<String, String> result = await fetchArticle(url);

    setState(() {
      _isLoading = false;
      _articleTitle = result['title']!;
      _articleContent = result['content']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Article'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'Paste article link here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchArticle,
              child: Text('Fetch Article'),
            ),
            SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            if (_articleTitle.isNotEmpty && !_isLoading)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _articleTitle,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
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
