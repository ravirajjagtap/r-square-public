import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications;

  const NotificationPage({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body:
          notifications.isEmpty
              ? const Center(child: Text('No notifications yet.'))
              : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  DateTime timestamp = DateTime.parse(
                    notifications[index]['timestamp']!,
                  );
                  String formattedDate = DateFormat(
                    'EEEE, dd MMM yyyy, HH:mm a',
                  ).format(timestamp);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Colors.blue,
                      ),
                      title: Text(
                        notifications[index]['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notifications[index]['message']!),
                          const SizedBox(height: 5),
                          Text(
                            "📅 $formattedDate",
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
