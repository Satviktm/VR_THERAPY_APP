import 'package:flutter/material.dart';
import 'package:app_therapy/screens/pages/sub_pages/Resourcespage.dart';
import 'package:app_therapy/screens/pages/sub_pages/articlepage.dart';

class ProfessionalGuidancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'INSIGHTS CENTER',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade100,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Fill the entire screen without leaving blank space
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.05, 
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Title Text
                    Text(
                      'WELCOME TO THE INSIGHT CENTER',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22.0 : 28.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),

                    // Subtitle Text
                    Text(
                      'The Insight Center offers a comprehensive array of resources and articles to enrich your understanding of mental health and well-being. Delve into expert insights, research findings, and practical advice that can guide and support you on your journey to better mental health.',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16.0 : 18.0,
                        color: Colors.indigo.shade600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 50.0),

                    // Divider
                    Divider(thickness: 1.5, color: Colors.indigo.shade300),

                    // Resources Button
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                        title: Text(
                          'Resources',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18.0 : 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: Icon(
                          Icons.library_books,
                          color: Colors.indigo.shade700,
                          size: 30,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.indigo.shade700),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResourcesPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30.0),

                    // Articles Button
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                        title: Text(
                          'Articles',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18.0 : 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        leading: Icon(
                          Icons.article,
                          color: Colors.indigo.shade700,
                          size: 30,
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            color: Colors.indigo.shade700),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArticlesPage()),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 30.0),

                    // Final Divider
                    Divider(thickness: 1.5, color: Colors.indigo.shade300),
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
