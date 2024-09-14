import 'package:cloud_firestore/cloud_firestore.dart';

class Therapist {
  final String id;
  final String name;
  final String role;
  final String details;
   final String photoUrl; // Added
  final String bio; // Added
  final String speaks; // Added
  final List<String> appointments; // List of appointments

  Therapist({
    required this.id,
    required this.name,
    required this.role,
    required this.details,
     required this.photoUrl, // Added
    required this.bio, // Added
    required this.speaks, // Added
    this.appointments = const [],
  });

  factory Therapist.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Therapist(
      id: doc.id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      details: data['details'] ?? '',
      photoUrl: data['photoUrl'] ?? '', // Added
      bio: data['bio'] ?? '', // Added
      speaks: data['speaks'] ?? '', // Added
      appointments: List<String>.from(data['appointments'] ?? []), // Initialize appointments list
    );
  }

  Future<void> addAppointment(String appointment) async {
    final docRef = FirebaseFirestore.instance.collection('therapists').doc(id);
    appointments.add(appointment);
    await docRef.update({'appointments': appointments});
  }
}