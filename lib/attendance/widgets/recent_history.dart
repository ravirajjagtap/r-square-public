import 'package:flutter/material.dart';

class RecentHistory extends StatelessWidget {
  const RecentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Jan 21', 'Jan 20', 'Jan 19'].map((date) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  date == 'Jan 21' ? '92%' : date == 'Jan 20' ? '88%' : '95%',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
