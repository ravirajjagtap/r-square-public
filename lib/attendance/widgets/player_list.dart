import 'package:flutter/material.dart';
import 'package:tennis/feedback/feedback_by_coach.dart';
import '../screens/attendance_screen.dart';

class PlayerList extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  final Function(List<Map<String, dynamic>>, int) toggleAttendance;

  const PlayerList(
      {super.key, required this.players, required this.toggleAttendance});

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
      children: players.map((player) {
        final index = players.indexOf(player);
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(player['name'][0]),
            ),
            title: Text(
              player['name'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(player['role']),
            trailing: IconButton(
              icon: _getAttendanceIcon(player['attendance']),
              onPressed: () => toggleAttendance(players, index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerFeedbackPage()),
              );
            },
          )
        );
      }).toList(),
    );
  }
}
