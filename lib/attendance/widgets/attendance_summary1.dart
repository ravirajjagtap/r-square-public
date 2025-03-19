import 'package:flutter/material.dart';

class AttendanceSummary1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SummaryColumn(title: 'Attendance Rate', value: '85%', color: Colors.blue),
          SummaryColumn(title: 'Present', value: '17', color: Colors.green),
          SummaryColumn(title: 'Absent', value: '3', color: Colors.red),
        ],
      ),
    );
  }
}

class SummaryColumn extends StatelessWidget {
  final String title, value;
  final Color color;
  SummaryColumn({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}
