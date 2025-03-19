import 'package:flutter/material.dart';

class AdminProfileCard extends StatelessWidget {
  final String name;

  const AdminProfileCard({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Card(
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
                          backgroundColor: Colors.grey.shade200, // Optional background color
                          child: const Icon(
                            Icons.account_circle,
                            size: 80, // Adjust size as needed
                          color: Colors.grey, // Adjust color as needed
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
    );
  }
}
