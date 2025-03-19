import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final List<Map<String, String>> notifications;
  final int unreadCount;
  final VoidCallback onTap;

  const NotificationIcon({
    super.key,
    required this.notifications,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: onTap,
          ),
        ),
        if (unreadCount > 0)
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$unreadCount', // Show unread count
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
