import 'package:flutter/material.dart';

class AttendanceSummary extends StatelessWidget {
  final int presentPlayers;
  final int partialPresentPlayers;
  final int totalPlayers;
  final int presentCoaches;
  final int partialPresentCoaches;
  final int totalCoaches;

  const AttendanceSummary({
    super.key,
    required this.presentPlayers,
    required this.partialPresentPlayers,
    required this.totalPlayers,
    required this.presentCoaches,
    required this.partialPresentCoaches,
    required this.totalCoaches,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummary(
              'Players', presentPlayers, partialPresentPlayers, totalPlayers),
          _buildSummary(
              'Coaches', presentCoaches, partialPresentCoaches, totalCoaches),
        ],
      ),
    );
  }

  Widget _buildSummary(
      String label, int present, int partialPresent, int total) {
    final double attendance =
        ((present + (partialPresent * 0.5)) / total) * 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          '${attendance.toStringAsFixed(0)}%',
          style: const TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '$present full + $partialPresent partial',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
