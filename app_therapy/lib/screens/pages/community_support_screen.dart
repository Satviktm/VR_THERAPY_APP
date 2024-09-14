import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_therapy/screens/pages/sub_pages/chat_guru_page.dart'; 
import 'package:app_therapy/screens/pages/sub_pages/feedback_page.dart';

class CommunitySupportScreen extends StatefulWidget {
  const CommunitySupportScreen({Key? key}) : super(key: key);

  @override
  _CommunitySupportScreenState createState() => _CommunitySupportScreenState();
}

class _CommunitySupportScreenState extends State<CommunitySupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _feedbackCollection.add({
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _feedbackController.clear();
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COMMUNITY SUPPORT',
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
                'WELCOME TO COMMUNITY SUPPORT',
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
                'Connect with others and share your feedback. Chat with our virtual guru for guidance or leave your valuable feedback to help us improve.',
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

              // Chat Guru Button
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  title: Text(
                    'ASK & SHARE',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18.0 : 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(
                    Icons.chat,
                    color: Colors.indigo.shade700,
                    size: 30,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.indigo.shade700,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatGuruScreen()),
                    );
                  },
                ),
              ),
              SizedBox(height: 30.0),

              // Feedback Button
              Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                  title: Text(
                    'FEEDBACK',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18.0 : 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.indigo.shade700,
                    size: 30,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.indigo.shade700,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackPage()),
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
    );
  }
}
