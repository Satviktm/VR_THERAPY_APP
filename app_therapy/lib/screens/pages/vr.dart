import 'package:flutter/material.dart';
import 'package:app_therapy/screens/pages/sub_pages/section_video_page.dart'; // Adjust the import path as needed

class VrTherapyScreen extends StatelessWidget {
  final List<String> sections = const [
    'Stress Management & Relaxation',
    'Anxiety & Panic Attack Relief',
    'Exposure Therapy',
    'Post-Traumatic Stress Disorder (PTSD)',
    'Depression',
    'Sleep Therapy',
    'Chronic Pain Management',
    'General Mental Health Resources',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VR Therapy Sessions'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 68, 0, 75), // Black
              Color(0xFF800000), // Maroon (faded)
            ],
            stops: [0.3, 1], // Fades the colors
          ),
        ),
        child: Column(
          children: [
            // Add image at the top
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/vrg.png'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Add card section with GridView below the image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 68, 0, 75), // Black
                          Color(0xFF800000), // Maroon (faded)
                        ],
                        stops: [0.3, 1], // Fades the colors
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _SectionGrid(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionGrid extends StatelessWidget {
  const _SectionGrid();

  @override
  Widget build(BuildContext context) {
    final sections = const [
      'Stress Management & Relaxation',
      'Anxiety & Panic Attack Relief',
      'Exposure Therapy',
      'Post-Traumatic Stress Disorder (PTSD)',
      'Depression',
      'Sleep Therapy',
      'Chronic Pain Management',
      'General Mental Health Resources',
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return _buildTile(
          context,
          sectionTitle: sections[index],
        );
      },
    );
  }

  Widget _buildTile(BuildContext context, {required String sectionTitle}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionVideoPage(
              sectionTitle: sectionTitle,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 168, 207, 255), // Yellow
              Color.fromARGB(255, 0, 62, 161), // Orange
            ],
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            sectionTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
