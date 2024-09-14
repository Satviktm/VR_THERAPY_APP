import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _resources = [];
  List<Map<String, dynamic>> _filteredResources = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchResources();
    _searchController.addListener(_filterResources);
  }

  void _fetchResources() async {
    QuerySnapshot snapshot = await _firestore.collection('resources').get();
    List<Map<String, dynamic>> resources = snapshot.docs.map((doc) {
      return {
        'title': doc['title'],
        'description': doc['description'],
        'icon': doc['icon'], // String type for the icon
        'url': doc['url'],
      };
    }).toList();

    setState(() {
      _resources = resources;
      _filteredResources = resources; // Initially show all resources
    });
  }

  void _filterResources() {
    String searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredResources = _resources.where((resource) {
        return resource['title'].toLowerCase().contains(searchQuery) ||
            resource['description'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  IconData getIconData(String iconName) {
    switch (iconName) {
      case 'Icons.phone':
        return Icons.phone;
      case 'Icons.web':
        return Icons.web;
      case 'Icons.spa':
        return Icons.spa;
      case 'Icons.computer':
        return Icons.computer;
      case 'Icons.psychology':
        return Icons.psychology;
      case 'Icons.group':
        return Icons.group;
      case 'Icons.nightlight':
        return Icons.nightlight;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resources'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Resources',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredResources.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredResources.length,
                    itemBuilder: (context, index) {
                      final resource = _filteredResources[index];
                      return _buildResourceCard(
                        title: resource['title'],
                        description: resource['description'],
                        iconData: getIconData(resource['icon']),
                        url: resource['url'],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard({
    required String title,
    required String description,
    required IconData iconData,
    required String url,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: Icon(iconData, size: 40.0, color: Colors.blue.shade600),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue.shade900),
        ),
        subtitle:
            Text(description, style: TextStyle(color: Colors.blue.shade700)),
        onTap: () {
          _launchURL(url);
        },
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