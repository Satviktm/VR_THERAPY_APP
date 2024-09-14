import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatGuruScreen extends StatefulWidget {
  @override
  _ChatGuruScreenState createState() => _ChatGuruScreenState();
}

class _ChatGuruScreenState extends State<ChatGuruScreen> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final CollectionReference _questionsCollection =
      FirebaseFirestore.instance.collection('questions');
  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName(); // Fetch user's name from Firebase on initialization
  }

  Future<void> _getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName =
            (userDoc.data() as Map<String, dynamic>)['name'] ?? 'Anonymous';
      });
    }
  }

  void _submitQuestion() async {
    if (_questionController.text.isNotEmpty) {
      try {
        await _questionsCollection.add({
          'question': _questionController.text,
          'answers': [],
          'name': _userName ?? 'Anonymous',
          'timestamp': FieldValue.serverTimestamp(),
        });
        _questionController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Question submitted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error submitting question')));
        print('Error submitting question: $e');
      }
    }
  }

  void _submitAnswer(String questionId) async {
    if (_answerController.text.isNotEmpty) {
      try {
        DocumentReference questionDoc = _questionsCollection.doc(questionId);
        await questionDoc.update({
          'answers': FieldValue.arrayUnion([
            {
              'answer': _answerController.text,
              'name': _userName ?? 'Anonymous',
            }
          ])
        });
        _answerController.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Answer submitted')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error submitting answer')));
        print('Error submitting answer: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color.fromARGB(255, 46, 88, 255); // Deep purple shade

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ASK & SHARE",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 46, 88, 255),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _questionsCollection
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No questions available'));
                }
                return ListView(
                  children: snapshot.data!.docs.map((question) {
                    var questionData = question.data() as Map<String, dynamic>;

                    String questionName = questionData['name'] is String
                        ? questionData['name'] as String
                        : 'Anonymous';
                    String questionText = questionData['question'] is String
                        ? questionData['question'] as String
                        : 'No question text';
                    List<dynamic> answers = questionData['answers'] is List
                        ? questionData['answers'] as List<dynamic>
                        : [];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Asked by: $questionName",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryColor),
                            ),
                            SizedBox(height: 5),
                            Text(questionText),
                            SizedBox(height: 30),
                            Text(
                              "Answers:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: primaryColor),
                            ),
                            for (var answer in answers)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "- ${answer is Map<String, dynamic> ? (answer['answer'] as String?) ?? 'No answer text' : 'No answer text'}"),
                                    Text(
                                      "Answered by: ${answer is Map<String, dynamic> ? (answer['name'] as String?) ?? 'Anonymous' : 'Anonymous'}",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextField(
                                controller: _answerController,
                                decoration: InputDecoration(
                                  labelText: 'Your answer',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 10.0),
                                  labelStyle: TextStyle(color: primaryColor),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 2.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 1.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20), // Added space here
                            ElevatedButton(
                              onPressed: () => _submitAnswer(question.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 108, 127, 204),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Submit Answer",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      labelText: 'Ask a question',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      labelStyle: TextStyle(color: primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 1.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.send, color: primaryColor, size: 30),
                  onPressed: _submitQuestion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
