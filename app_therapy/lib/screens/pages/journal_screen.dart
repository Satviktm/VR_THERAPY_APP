import 'package:flutter/material.dart';
import 'package:app_therapy/screens/pages/sub_pages/journal_list_page.dart'; // Adjust the import path as needed
import 'package:app_therapy/screens/pages/sub_pages/write_journal_page.dart'; // Adjust the import path as needed

class JournalPage extends StatelessWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image of a diary
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/diary.png'), // Relative path to the diary image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content over the background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title at the top of the diary page
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Text(
                    "My Diary",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Black text color
                      fontFamily: 'Cursive', // Use a cursive font to enhance the theme
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black26,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                  ),
                ),
                // Button for "View Existing Journals" with white background and black border
                Container(
                  width: 320,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(color: Colors.black, width: 2.0), // Black border color
                      backgroundColor: Colors.white, // White background color
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => JournalListPage(),
                        ),
                      );
                    },
                    child: Text(
                      "View Existing Journals",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Black text color
                        fontSize: 20,
                        fontFamily: 'Cursive',
                      ),
                    ),
                  ),
                ),
                // Button for "Add New Journal Entry" with white background and black border
                Container(
                  width: 320,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: BorderSide(color: Colors.black, width: 2.0), // Black border color
                      backgroundColor: Colors.white, // White background color
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WriteJournalPage(),
                        ),
                      );
                    },
                    child: Text(
                      "Add New Journal Entry",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black, // Black text color
                        fontSize: 20,
                        fontFamily: 'Cursive',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}