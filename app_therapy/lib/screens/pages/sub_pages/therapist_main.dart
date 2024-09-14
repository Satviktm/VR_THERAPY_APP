import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_therapy/screens/pages/therapist_list.dart';

class TherapistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Therapist Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 149, 203, 248),
        elevation: 0, // Remove shadow for a flat look
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Slogan and Description
            Text(
              "Guiding You to a Healthier Mind, One Step at a Time",
              style: GoogleFonts.dancingScript(
                fontSize: 24, // Increased font size for better visibility
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0), // Slogan color
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Our therapists are here to provide expert care and personalized support for your mental health journey. Whether you're seeking help with stress, anxiety, PTSD, or other challenges, our experienced professionals are ready to help you navigate your path to well-being.",
              style: GoogleFonts.roboto(
                fontSize: 18, // Increased font size for better readability
                color: Colors.black, // Description text color
              ),
            ),
            SizedBox(height: 30),

            // Button to go to Therapist List
            ElevatedButton(
              onPressed: () {
                // Navigate to the existing Therapist List Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TherapistListPage()),
                );
              },
              child: Text('Therapists'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button background color
                foregroundColor: Color.fromARGB(255, 255, 255, 255), // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
              ),
            ),
            SizedBox(height: 20), // Added space between button and image

            // Flexible to prevent overflow
            Flexible(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  'assets/tm4.png', // Path to your image
                  width: 375, // Increased width
                  height: 375, // Increased height
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
