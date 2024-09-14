import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteJournalPage extends StatefulWidget {
  final String? journalId;
  final String? initialHeading;
  final String? initialText;

  WriteJournalPage({
    this.journalId,
    this.initialHeading,
    this.initialText,
  });

  @override
  _WriteJournalPageState createState() => _WriteJournalPageState();
}

class _WriteJournalPageState extends State<WriteJournalPage> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.journalId != null) {
      _headingController.text = widget.initialHeading ?? '';
      _textController.text = widget.initialText ?? '';
    }
  }

  Future<void> _saveJournal() async {
    final String heading = _headingController.text;
    final String text = _textController.text;

    if (widget.journalId != null) {
      // Update existing journal entry
      await FirebaseFirestore.instance.collection('journals').doc(widget.journalId).update({
        'heading': heading,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Add new journal entry
      await FirebaseFirestore.instance.collection('journals').add({
        'heading': heading,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': FirebaseAuth.instance.currentUser!.uid,
      });
    }

    Navigator.of(context).pop(); // Go back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journalId != null ? 'Edit Journal' : 'New Journal'),
        backgroundColor: Color.fromARGB(255, 206, 239, 248), // App bar background color
        iconTheme: IconThemeData(color: Colors.black), // Set back icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Add space above

              // Heading TextField
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  controller: _headingController,
                  decoration: InputDecoration(
                    labelText: 'Heading',
                    labelStyle: TextStyle(color: Colors.black54), // Label color
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: const Color.fromARGB(255, 51, 153, 237), width: 2.0), // Border color on focus
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Padding inside text field
                  ),
                  style: TextStyle(color: Colors.black), // Text color
                  textAlignVertical: TextAlignVertical.top, // Align text to the top
                  textAlign: TextAlign.start, // Align text to the start
                ),
              ),
              
              SizedBox(height: 8.0), // Space between heading and text field

              // Text TextField
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(double.infinity, 200), // Adjust height as needed
                      painter: CornerDesignPainter(),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          labelText: 'Text',
                          labelStyle: TextStyle(color: Colors.black54), // Label color
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue), // Border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0), // Border color on focus
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0), // Padding inside text field
                        ),
                        maxLines: 20, // Multi-line text
                        style: TextStyle(color: Colors.black), // Text color
                        textAlignVertical: TextAlignVertical.top, // Align text to the top
                        textAlign: TextAlign.start, // Align text to the start
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20), // Space before save button

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveJournal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button background color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Button border radius
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white), // Button text style
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CornerDesignPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color.fromARGB(255, 126, 178, 220) // Light color for decoration
      ..style = PaintingStyle.fill;

    final double cornerSize = 50.0;

    // Top right corner design
    canvas.drawRect(
      Rect.fromLTWH(size.width - cornerSize, 0, cornerSize, cornerSize),
      paint,
    );

    // Bottom left corner design
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - cornerSize, cornerSize, cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}