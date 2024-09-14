import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_therapy/screens/email_auth/login_screen.dart';
import 'package:app_therapy/screens/pages/professional_guidance.dart'; // Import the new screen
import 'package:app_therapy/screens/pages/vr.dart'; // Import your VR therapy screen
import 'package:app_therapy/screens/pages/sub_pages/therapist_main.dart'; // Therapist screen
import 'package:app_therapy/screens/pages/journal_screen.dart'; // Import your Journal screen
import 'package:app_therapy/screens/pages/community_support_screen.dart';
import 'package:google_fonts/google_fonts.dart'; // Import your Community Support screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Set up timer for auto-scrolling
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 6) {
        // Adjusted to match the number of images
        _currentPage++;
      } else {
        _currentPage = 0; // Reset to the first page after the last one
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

   @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }


  void logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, CupertinoPageRoute(builder: (context) => LoginScreen()));
  }
  

  // Method to return pages based on selected index
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage(); // New Home screen with quotes and VR therapy section
      case 1:
        return TherapistPage();
      case 2:
        return ProfessionalGuidancePage();
      case 3:
        return CommunitySupportScreen();
      case 4:
        return JournalPage();
      default:
        return Center(child: Text('Error'));
    }
  }

  // Method to handle bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Build the Home screen with quotes and VR therapy section
 // Build the Home screen with quotes and VR therapy section
Widget _buildHomePage() {
  return SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 9),

            // App name at center
            Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 140, 206, 241),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Our VR therapy app offers a groundbreaking approach to mental wellness, blending immersive virtual reality experiences with professional guidance.",
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            SizedBox(height: 10),

            // Light blue banner
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Transforming Minds, One Virtual Step at a Time",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Opportunities Section
            Text(
              "Explore Opportunities",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            // Larger VR Session box
            Center(
              child: _buildLargeOpportunityBox(
                "VR SESSIONS",
                "Step into a New Dimension of Healing",
                'assets/vr1.jpeg',
                VrTherapyScreen(),
              ),
            ),
            SizedBox(height: 15),
  
            // Row with equal-sized opportunity boxes with internal scrolling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: _buildScrollableOpportunityBox(
                    "FIND A THERAPIST",
                    "Discover Qualified Therapists to Support Your Mental Health, Connect, and Begin Your Path to Wellness",
                    'assets/vr5.jpeg',
                    TherapistPage(),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: _buildScrollableOpportunityBox(
                    "INSIGHTS CENTER",
                    "Expert Insights, Personalized Care - Your Path to Better Mental Health",
                    'assets/vr2.jpeg',
                    ProfessionalGuidancePage(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Another row with equal-sized opportunity boxes with internal scrolling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: _buildScrollableOpportunityBox(
                    "COMMUNITY SUPPORT",
                    "Empowering Each Other: A Community for Shared Healing and Support",
                    'assets/vr4c.jpeg',
                    CommunitySupportScreen(),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: _buildScrollableOpportunityBox(
                    "JOURNAL",
                    "Capture Your Thoughts and Feelings: Your Personal Journal for Reflection and Growth",
                    'assets/vr3j.jpeg',
                    JournalPage(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Inspirational Quotes Section
            Text(
              "Inspirational Quotes",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),

            // Quote carousel
            _buildQuoteCarousel(),

            SizedBox(height: 30),
          ],
        ),
      ),
    ),
  );
}

Widget _buildScrollableOpportunityBox(String title, String description, String image, Widget targetPage) {
  return GestureDetector(
    onTap: () {
      // Navigate to targetPage
    },
    child: Container(
      height: 300,  // Limit the height for internal scrolling
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 108, 211, 255),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Image
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),

          // Scrollable description
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


// Build large opportunity box for VR Sessions
Widget _buildLargeOpportunityBox(String title, String description, String imagePath, Widget page) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Container(
      height: 200, // Larger height for the VR session box
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: Text(
                  "Learn More",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Build equal-sized opportunity box for other sections
Widget _buildEqualOpportunityBox(String title, String description, String imagePath, Widget page) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Container(
      height: 150, // Set height for all equal-sized boxes
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => page),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                 child: Text(
                  "Learn More",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Build the quote carousel with auto-scroll and author images
  Widget _buildQuoteCarousel() {
    return SizedBox(
      height: 300,
      child: PageView.builder(
        controller: _pageController,
        itemCount: 10000, // Set a high value to simulate infinite scrolling
        itemBuilder: (context, index) {
          // Loop through the images based on the index
          int displayIndex = index % 7; // Assuming you have 7 images

          switch (displayIndex) {
            case 0:
              return _buildQuoteCard(
                "'The best way to predict the future is to create it.' — Peter Drucker",
                'assets/11.jpeg',
              );
            case 1:
              return _buildQuoteCard(
                "'Believe you can and you're halfway there.' — Theodore Roosevelt",
                'assets/12.jpg',
              );
            case 2:
              return _buildQuoteCard(
                "'The only limit to our realization of tomorrow is our doubts of today.' — Franklin D. Roosevelt",
                'assets/13.jpeg',
              );
            case 3:
              return _buildQuoteCard(
                "'Happiness is not something ready-made. It comes from your own actions.' — Dalai Lama",
                'assets/14.jpg',
              );
            case 4:
              return _buildQuoteCard(
                "'In the end, it's not the years in your life that count. It's the life in your years.' — Abraham Lincoln",
                'assets/15.jpg',
              );
            case 5:
              return _buildQuoteCard(
                "'You are never too old to set another goal or to dream a new dream.' — C.S. Lewis",
                'assets/16.jpeg',
              );
            case 6:
              return _buildQuoteCard(
                "'The only way to do great work is to love what you do.' — Steve Jobs",
                'assets/17.jpeg',
              );
            default:
              return SizedBox(); // Empty widget in case of an error
          }
        },
      ),
    );
  }

  // Updated _buildQuoteCard method with image as full background
  Widget _buildQuoteCard(String quote, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 300, // Set fixed height for square container
        width: 600, // Set fixed width for square container
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // Cover the square area
            colorFilter: ColorFilter.mode(
              Colors.black
                  .withOpacity(0.5), // Dark overlay for better text contrast
              BlendMode.darken,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              quote,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Blue background for AppBar
        title: Text(
          "THERAPYVERSE",
          style: GoogleFonts.dancingScript(
            textStyle: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 255, 255, 255), // White text for contrast
            ),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/vrlogo6.png', // Reference to your logo
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => logOut(),
          ),
        ],
      ),
      body: _getSelectedPage(), // Display the selected page here
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Therapists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Guidance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Keeps labels visible
      ),
    );
  }
}