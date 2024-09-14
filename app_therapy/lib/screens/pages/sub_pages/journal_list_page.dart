import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'write_journal_page.dart'; // Adjust the import path as needed

class JournalListPage extends StatelessWidget {
  const JournalListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Journals",
          style: TextStyle(color: Colors.black), // Black color for title
        ),
        backgroundColor: Color.fromARGB(255, 191, 229, 237), // App bar background color
        iconTheme: IconThemeData(color: Colors.black), // Set the back icon to black
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image.png', // Path to your background image
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),

          // Journal List Content
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('journals')
                .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("No journal entries found"));
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var journal = snapshot.data!.docs[index];
                  var data = journal.data() as Map<String, dynamic>?;

                  String heading = data != null && data.containsKey('heading')
                      ? data['heading'] ?? 'No Heading'
                      : 'No Heading';
                  String text = data != null && data.containsKey('text')
                      ? data['text'] ?? 'No Entry'
                      : 'No Entry';
                  String journalId = journal.id;

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black, // Change border color to black
                          width: 2),
                      borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Subtle shadow
                          blurRadius: 4.0,
                          offset: Offset(2, 2), // Shadow position
                        ),
                      ],
                    ),
                    child: Card(
                      margin: EdgeInsets.zero, // No extra margin
                      color: Colors.white, // White background for the card
                      elevation: 0, // No elevation for a flat look
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0), // Reduced padding
                        title: Text(
                          heading,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0, // Font size for the title
                            color: Colors.black, // Set text color to black
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0), // Slight shadow for readability
                                blurRadius: 2.0,
                                color: Colors.white, // Shadow color to contrast with background
                              ),
                            ],
                          ),
                          maxLines: 1, // Limit title to one line
                          overflow: TextOverflow.ellipsis, // Show ellipsis if title is too long
                        ),
                        subtitle: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // Show ellipsis if entry is too long
                        ),
                        onTap: () {
                          _showJournalDetails(context, heading, text, journalId); // Pass journalId to show details
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WriteJournalPage(), // For new journal entry
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // Match the gradient color
      ),
    );
  }

  // Show journal details in a new dialog with edit and delete options
  void _showJournalDetails(BuildContext context, String heading, String text, String journalId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            heading,
            style: TextStyle(color: Colors.black), // Black color for dialog title
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(color: Colors.black), // Black text for content
              ),
              SizedBox(height: 20), // Space between content and buttons
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Edit', style: TextStyle(color: Colors.green)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WriteJournalPage(
                      journalId: journalId, // Pass journalId for edit
                      initialHeading: heading,
                      initialText: text,
                    ),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteJournal(context, journalId); // Trigger delete action
              },
            ),
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  // Delete a journal entry from Firestore
  Future<void> _deleteJournal(BuildContext context, String journalId) async {
    try {
      await FirebaseFirestore.instance.collection('journals').doc(journalId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Journal entry deleted")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete journal entry")),
      );
    }
  }
}