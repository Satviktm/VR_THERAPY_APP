import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app_therapy/screens/email_auth/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _gender;
  String? _preferences;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool _validateInputs() {
    int age = int.tryParse(_ageController.text.trim()) ?? 0;

    if (_nameController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Name is required.";
      });
      return false;
    }

    if (_ageController.text.trim().isEmpty || age < 6 || age > 80) {
      setState(() {
        _errorMessage = "Age must be between 6 and 80.";
      });
      return false;
    }

    if (_gender == null) {
      setState(() {
        _errorMessage = "Gender is required.";
      });
      return false;
    }

    if (_preferences == null) {
      setState(() {
        _errorMessage = "Preferences are required.";
      });
      return false;
    }

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Email is required.";
      });
      return false;
    }

    if (_passwordController.text.trim().isEmpty ||
        _passwordController.text.trim().length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters.";
      });
      return false;
    }

    setState(() {
      _errorMessage = null;
    });
    return true;
  }

  Future<void> _register() async {
    if (!_validateInputs()) return;

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'age': int.parse(_ageController.text.trim()),
        'gender': _gender,
        'preferences': _preferences,
        'email': _emailController.text.trim(),
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Registration failed. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: Stack(
        children: [
          // New circular design on the top-left
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue.withOpacity(0.3),
              ),
            ),
          ),
          // New circular design on the bottom-right
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue.withOpacity(0.3),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "THERAPYVERSE",
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 80),
                  Center(
                    child: Image.asset(
                      'assets/7.png',
                      height: 150,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please register to login.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.blueAccent),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon:
                          Icon(Icons.cake_outlined, color: Colors.blueAccent),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    onChanged: (String? newValue) {
                      setState(() {
                        _gender = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.wc_outlined, color: Colors.blueAccent),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: <String>['Male', 'Female', 'Other']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _preferences,
                    onChanged: (String? newValue) {
                      setState(() {
                        _preferences = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Pref',
                      prefixIcon:
                          Icon(Icons.favorite_outline, color: Colors.blueAccent),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: <String>[
                      'Stress Management & Relaxation',
                      'Anxiety & Panic Attack Relief',
                      'Exposure Therapy',
                      'Post-Traumatic Stress Disorder (PTSD)',
                      'Depression',
                      'Sleep Therapy',
                      'Chronic Pain Management',
                      'General Mental Health Resources',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.blueAccent),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.blueAccent),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 172, 204, 239),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Sign Up'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Already have an account? Sign in',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
