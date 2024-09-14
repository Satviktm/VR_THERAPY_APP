import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _articles = [];
  List<Map<String, dynamic>> _filteredArticles = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _searchController.addListener(_filterArticles);
  }

  void _fetchArticles() async {
    QuerySnapshot snapshot = await _firestore.collection('articles').get();
    List<Map<String, dynamic>> articles = snapshot.docs.map((doc) {
      return {
        'title': doc['title'],
        'author': doc['author'],
        'imageUrl': doc['imageUrl'],
        'url': doc['url'],
      };
    }).toList();

    setState(() {
      _articles = articles;
      _filteredArticles = articles; // Initially show all articles
    });
  }

  void _filterArticles() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredArticles = _articles.where((article) {
        return article['title'].toLowerCase().contains(searchQuery) ||
               article['author'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Articles',
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredArticles.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredArticles.length,
                    itemBuilder: (context, index) {
                      final article = _filteredArticles[index];
                      return _buildArticleCard(
                        title: article['title'],
                        author: article['author'],
                        imageUrl: article['imageUrl'],
                        url: article['url'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String author,
    required String imageUrl,
    required String url,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
            child: Image.network(
              imageUrl,
              height: 160.0,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  author,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              onPressed: () => _launchURL(url),
              child: Text('Read More'),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
