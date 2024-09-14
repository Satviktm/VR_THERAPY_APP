import 'package:flutter/material.dart';
import 'package:app_therapy/screens/pages/therapist.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistDetailsPage extends StatefulWidget {
  final Therapist therapist;

  const TherapistDetailsPage({Key? key, required this.therapist}) : super(key: key);

  @override
  _TherapistDetailsPageState createState() => _TherapistDetailsPageState();
}

class _TherapistDetailsPageState extends State<TherapistDetailsPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _auth = FirebaseAuth.instance;
  User? _currentUser;
  late CollectionReference _appointmentsRef;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _appointmentsRef = FirebaseFirestore.instance.collection('appointments');
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _addAppointment() async {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
      final String formattedAppointment = DateFormat('yyyy-MM-dd – kk:mm').format(appointmentDateTime);

      final String appointmentId = DateTime.now().millisecondsSinceEpoch.toString();

      await _appointmentsRef.doc(appointmentId).set({
        'userId': _currentUser!.uid,
        'therapistId': widget.therapist.id,
        'therapistName': widget.therapist.name,
        'appointmentTime': formattedAppointment,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );

      setState(() {
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  Future<void> _confirmCancellation(String appointmentId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Appointment'),
          content: Text('Are you sure you want to cancel this appointment?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _cancelAppointment(appointmentId);
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    await _appointmentsRef.doc(appointmentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 183, 232, 255),
      appBar: AppBar(
        title: Text(widget.therapist.name),
        backgroundColor: Colors.blue, // Customize AppBar background color
      ),
      body: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Stack(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(0.2),
                  ),
                ),
                Positioned(
                  left: 30,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Therapist image with overlay text for name and role
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(widget.therapist.photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.therapist.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.therapist.role,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Additional Information Section
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.pink, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Speaks:', style: _boldTextStyle()),
                        SizedBox(height: 5),
                        Text(widget.therapist.speaks, style: _normalTextStyle()),
                        SizedBox(height: 10),
                        Text('Bio:', style: _boldTextStyle()),
                        SizedBox(height: 5),
                        Text(widget.therapist.bio, style: _normalTextStyle()),
                        SizedBox(height: 10),
                        Text('Details:', style: _boldTextStyle()),
                        SizedBox(height: 5),
                        Text(widget.therapist.details, style: _normalTextStyle()),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // Appointments Section
                  Text('Appointments:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildAppointmentsSection(),
                  SizedBox(height: 20),

                  // Appointment Booking Section
                  _buildBookingSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _boldTextStyle() => TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);

  TextStyle _normalTextStyle() => TextStyle(fontSize: 16, color: Colors.black);

  Widget _buildAppointmentsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _appointmentsRef
          .where('userId', isEqualTo: _currentUser!.uid)
          .where('therapistId', isEqualTo: widget.therapist.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final doc = appointments[index];
            final appointmentTime = doc['appointmentTime'];
            final appointmentId = doc.id;

            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Appointment: $appointmentTime'),
                trailing: IconButton(
                  icon: Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => _confirmCancellation(appointmentId),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBookingSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Book an Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    _selectedDate == null ? 'Select Date' : DateFormat.yMd().format(_selectedDate!),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    _selectedTime == null ? 'Select Time' : _selectedTime!.format(context),
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _addAppointment,
              child: Text('Add Appointment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
