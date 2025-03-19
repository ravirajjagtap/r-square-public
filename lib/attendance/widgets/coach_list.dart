import 'package:flutter/material.dart';
import '../screens/attendance_screen.dart';

class CoachList extends StatelessWidget {
  final List<Map<String, dynamic>> coaches;
  final Function(List<Map<String, dynamic>>, int) toggleAttendance;

  const CoachList(
      {super.key, required this.coaches, required this.toggleAttendance});

  Icon _getAttendanceIcon(AttendanceState state) {
    switch (state) {
      case AttendanceState.present:
        return const Icon(Icons.check_circle, color: Colors.green);
      case AttendanceState.partialPresent:
        return const Icon(Icons.check_circle, color: Colors.orange);
      case AttendanceState.absent:
        return const Icon(Icons.cancel, color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: coaches.map((coach) {
        final index = coaches.indexOf(coach);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Text(coach['name'][0])),
            title: Text(coach['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(coach['role']),
            trailing: IconButton(
              icon: _getAttendanceIcon(coach['attendance']),
              onPressed: () => toggleAttendance(coaches, index),
            ),
          ),
        );
      }).toList(),
    );
  }
}
