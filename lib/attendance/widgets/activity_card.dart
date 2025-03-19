import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String date, location, inTime, outTime, status;
  final Color statusColor;

  const ActivityCard({
    required this.date,
    required this.location,
    required this.inTime,
    required this.outTime,
    required this.status,
    required this.statusColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Location: $location"),
              Text("In: $inTime | Out: $outTime"),
            ],
          ),
          Text(status,
              style: TextStyle(
                  color: statusColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
