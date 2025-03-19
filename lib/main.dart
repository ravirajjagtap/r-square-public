import 'package:flutter/material.dart';
import 'package:tennis/admi_files/admin_slot_management.dart';
import 'package:tennis/attendance/screens/user_specific_attendance_view.dart';
import 'package:tennis/authentication/login_screen.dart';
import 'package:tennis/settings/settings.dart';
import 'package:tennis/slotbooking/timeslot_booking.dart';
import 'attendance/screens/attendance_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
