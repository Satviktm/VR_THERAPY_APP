import 'package:flutter/material.dart';
import 'package:app_therapy/screens/pages/full_screen_video_page.dart'; // Adjust the import path as needed

class SectionVideoPage extends StatelessWidget {
  final String sectionTitle;

  SectionVideoPage({required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    // Define videos for each section
    final Map<String, List<Map<String, String>>> sectionVideos = {
      'Stress Management & Relaxation': [
        {'id': '7AkbUfZjS5k', 'title': 'VR Nature'},
        {'id': 'v64KOxKVLVg', 'title': 'Ocean Waves VR 360°'},
        {'id': 'G_gmoSejUxU', 'title': '360° VR Forest Walk '}
      ],
      'Anxiety & Panic Attack Relief': [
        {'id': '8vkYJf8DOsc', 'title': 'VR TAKE A DEEP BREATH'},
        {'id': '6ErOlezz0Wk', 'title': 'VR Instant Panic Attack Relief'},
        {'id': '8Ffhv3-8Sjw', 'title': 'VR Guided Breathing Meditation'},
      ],
      'Exposure Therapy': [
        {'id': 'wU0aFi5avsc', 'title': 'VR Public Speaking '},
        {'id': 'rNVpFXuAXIA', 'title': 'VR Height'},
        {'id': 'ZkbjduMAlVU', 'title': 'VR Crowded areas'},
      ],
      'Post-Traumatic Stress Disorder (PTSD)': [
        {'id': 'aePXpV8Z10Y', 'title': 'VR Mountain'},
        {'id': 'Ay2-vH2hNrQ', 'title': 'VR Guided tour'},
        {'id': 'XucTpkjQQLc', 'title': 'VR 360° night sky'},
      ],
      'Depression': [
        {'id': 'zyUy9w953L0', 'title': 'VR Meditation for gratitude'},
        {'id': 'qPsiOhZ1jTQ', 'title': 'VR Sunset 360'},
        {'id': '8Du1hrPrV38', 'title': 'VR Meditation in Nature 360°'},
      ],
      'Sleep Therapy': [
        {'id': 'rvaqPPjtxng', 'title': 'VR Guided sleep meditation'},
        {'id': 'WsoK8vdkiCY', 'title': 'VR Bedroom Ambiance'},
        {'id': 'kUNQlH8TyoY', 'title': 'VR Night in the Forest'},
      ],
      'Chronic Pain Management': [
        {'id': 'hEdzv7D4CbQ', 'title': 'VR Space walk'},
        {'id': 'ywCl4u0BUuE', 'title': 'VR Mindfulness for Pain Relief'},
        {'id': 'L_tqK4eqelA', 'title': 'VR Waterfall 360'},
      ],
      'General Mental Health Resources': [
        {'id': 'wWFHmYIZgYg', 'title': '360º Calm Mountain Meditation '},
        {'id': 'ACYZXD3Ap1M', 'title': '360º Mindfulness in Nature'},
        {'id': '_ZeEPo8w-n8', 'title': '360º Beach Meditation'},
      ],
    };

    // Get videos for the selected section
    final List<Map<String, String>> videos = sectionVideos[sectionTitle] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
      ),
      body: Container(
        color: Colors.grey[200], // Set the background color to grey
        padding: EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index];
            return _buildVideoSection(
              context,
              youtubeVideoId: video['id']!,
              videoTitle: video['title']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoSection(BuildContext context, {
    required String youtubeVideoId,
    required String videoTitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8.0), // Spacing around the title
          child: Text(
            videoTitle,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenVideoPage(
                  youtubeVideoId: youtubeVideoId,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                height: 200,
                color: Colors.black, // Background color for the video preview
                child: Center(
                  child: Text(
                    'Tap to play video',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.play_circle_filled,
                    size: 50,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
