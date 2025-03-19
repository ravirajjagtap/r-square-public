import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis/attendance/screens/user_specific_attendance_view.dart';
import 'package:tennis/slotbooking/timeslot_booking.dart';
import 'chart_widgets.dart';
import 'package:tennis/services/firebase_service.dart';


class PlayerDashboard extends StatefulWidget {
  const PlayerDashboard({super.key});

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  late String currentDate;
  late String currentTime;
  File? _image;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
  }

  void _updateDateTime() {
    setState(() {
      currentDate = DateFormat('yMMMMd').format(DateTime.now());
      currentTime = DateFormat('jm').format(DateTime.now());
    });
  }

  void _setImage(File? image) {
    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text('Dashboard',
                style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 10),
            PlayerInfoCard(
              image: _image,
              onImageChanged: _setImage,
              currentDate: currentDate,
              currentTime: currentTime,
            ),
            const SizedBox(height: 20),
            
            Row(
              children: const [
                StatCard('Attendance', '92%', Icons.people, Colors.green),
                StatCard('Matches Played', '24', Icons.bar_chart, Colors.blue),
              ],
            ),
            Row(
              children: const [
                StatCard(
                    'Agility Test Number', '16', Icons.star, Colors.orange),
                StatCard('Skill level', '8', Icons.show_chart, Colors.red),
              ],
            ),
            const SizedBox(height: 12),
            const LineChartWidget(),
            const SizedBox(height: 20),
            const BarChartWidget(),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('your coach',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
            Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.grey
                                      .shade200, // Optional background color
                                  child: const Icon(
                                    Icons.account_circle,
                                    size: 80, // Adjust size as needed
                                    color:
                                        Colors.grey, // Adjust color as needed
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alex Thompson',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerInfoCard extends StatelessWidget {
  final File? image;
  final void Function(File?) onImageChanged;
  final String currentDate;
  final String currentTime;

  const PlayerInfoCard({
    required this.image,
    required this.onImageChanged,
    required this.currentDate,
    required this.currentTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ImagePickerWidget(image: image, onImagePicked: onImageChanged),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alex Thompson',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Basic', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.notifications),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status', style: TextStyle(color: Colors.grey)),
                    Text('$currentDate, $currentTime',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 4),
                  ),
                  child: const Text('66.6%',
                      style: TextStyle(fontSize: 12, color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
