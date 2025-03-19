import 'package:flutter/material.dart';
import 'package:notification/screens/admin_notification.dart';
import 'admin_notification_page.dart';
import 'notification_page.dart';
import '../widgets/notification_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> notifications = [];
  int unreadCount = 0;

  void _addNotification(String title, String message) {
    setState(() {
      notifications.add({
        'title': title,
        'message': message,
        'timestamp': DateTime.now().toString(),
      });
      unreadCount++; // Update unread count
    });
  }

  void _markNotificationsAsRead() {
    setState(() {
      unreadCount = 0; // Reset unread count when opened
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          NotificationIcon(
            notifications: notifications,
            unreadCount: unreadCount,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          NotificationPage(notifications: notifications),
                ),
              ).then((_) => _markNotificationsAsRead());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome! Click the notification icon to see updates.',
              style: TextStyle(color: Colors.white), // White text
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => AdminNotificationPage(
                          onNotificationAdded: _addNotification,
                        ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Go to Admin Page",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
