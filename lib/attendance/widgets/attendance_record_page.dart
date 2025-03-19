import 'package:flutter/material.dart';
import 'package:tennis/attendance/widgets/attendance_summary1.dart';
import 'attendance_summary.dart';
import 'attendance_calendar.dart';
import 'activity_card.dart';

class AttendanceRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Attendance Record',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/icons/profile.jpg'), // Change as needed
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanmay Bajaj',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Football Player',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Track your attendance history',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 16),
            AttendanceSummary1(),
            SizedBox(height: 16),
            AttendanceCalendar(),
            SizedBox(height: 16),
            Text(
              'Recent Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ActivityCard(
              date: 'Sep 15, 2023',
              location: 'Training Ground',
              inTime: '09:00 AM',
              outTime: '05:00 PM',
              status: 'Present',
              statusColor: Colors.green,
            ),
            ActivityCard(
              date: 'Sep 14, 2023',
              location: 'Training Ground',
              inTime: '08:55 AM',
              outTime: '05:30 PM',
              status: 'Present',
              statusColor: Colors.green,
            ),
            ActivityCard(
              date: 'Sep 13, 2023',
              location: '-',
              inTime: '-',
              outTime: '-',
              status: 'Absent',
              statusColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
