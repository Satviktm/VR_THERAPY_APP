import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final CollectionReference _feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');
  String _feedbackType = 'Suggestion';
  double _rating = 3;

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _feedbackCollection.add({
          'name': _nameController.text,
          'email': _emailController.text,
          'feedbackType': _feedbackType,
          'rating': _rating,
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Feedback submitted successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting feedback: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Feedback",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 7, 2, 98),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "We value your feedback!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Please fill out the form below to help us improve.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name (Optional)',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 7, 2, 98)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlueAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email (Optional)',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 7, 2, 98)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Feedback Type',
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 7, 2, 98)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: _feedbackType,
                      items: [
                        'Complaint',
                        'Suggestion',
                        'Compliment',
                        'Bug Report',
                        'Other'
                      ].map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          )).toList(),
                      onChanged: (value) {
                        setState(() {
                          _feedbackType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Rating',
                      style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 13, 41, 169)),
                    ),
                    Slider(
                      value: _rating,
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: '$_rating stars',
                      activeColor: const Color.fromARGB(255, 7, 2, 98),                     

                      inactiveColor: Colors.lightBlue[100],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _feedbackController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: "Your Feedback",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 7, 2, 98)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.lightBlue),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your feedback';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 7, 2, 98),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Submit Feedback",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Previous Feedback",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _feedbackCollection
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
                    return Center(child: Text("No feedback available"));
                  }
                  return Column(
                    children: snapshot.data!.docs.map((feedback) {
                      return Card(
                        color: Colors.lightBlue[50],
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(
                            feedback['feedback'],
                            style: TextStyle(color: Colors.lightBlue[900]),
                          ),
                          subtitle: Text(
                            feedback['timestamp'] != null
                                ? (feedback['timestamp'] as Timestamp)
                                    .toDate()
                                    .toString()
                                : 'No timestamp',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
