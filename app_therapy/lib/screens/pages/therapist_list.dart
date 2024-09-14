import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'therapist_details.dart';
import 'package:app_therapy/screens/pages/therapist.dart';

class TherapistListPage extends StatelessWidget {
  const TherapistListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/tb.jpg', // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // AppBar-like title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Choose Your Therapist',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // GridView for therapists
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('therapists').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final therapists = snapshot.data!.docs.map((doc) => Therapist.fromFirestore(doc)).toList();

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 1.0, // Adjust aspect ratio if needed
                        ),
                        itemCount: therapists.length,
                        itemBuilder: (context, index) {
                          final therapist = therapists[index];
                          return Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TherapistDetailsPage(therapist: therapist),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(therapist.photoUrl),
                                      backgroundColor: Colors.grey[200],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      therapist.name,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    therapist.role,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
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
