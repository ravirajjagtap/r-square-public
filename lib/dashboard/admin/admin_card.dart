import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final String attendance;
  final String winLoss;
  final String status;
  final String image;

  const StudentCard({
    super.key,
    required this.name,
    required this.attendance,
    required this.winLoss,
    required this.status,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: AssetImage(image)),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Attendance: $attendance  W/L: $winLoss'),
        trailing: Text(
          status,
          style: TextStyle(
            color: status == 'Advanced'
                ? Colors.green
                : status == 'Intermediate'
                    ? const Color.fromARGB(78, 30, 16, 136)
                    : status == 'Basic'
                        ? const Color.fromARGB(255, 202, 7, 7)
                        : Colors.red,
          ),
        ),
        onTap: () {
          
        },
      ),
    );
  }
}

