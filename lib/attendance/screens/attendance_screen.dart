import 'package:flutter/material.dart';
import '../widgets/player_list.dart';
import '../widgets/coach_list.dart';
import '../widgets/recent_history.dart';
import '../widgets/attendance_summary.dart';
import '../widgets/section_header.dart';
import '../../services/firebase_service.dart';

// Define attendance states
enum AttendanceState { present, absent, partialPresent }

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  final List<Map<String, dynamic>> players = [
    {
      'name': 'John Smith',
      'role': 'Forward',
      'attendance': AttendanceState.present
    },
    {
      'name': 'Michael Johnson',
      'role': 'Midfielder',
      'attendance': AttendanceState.present
    },
    {
      'name': 'David Williams',
      'role': 'Defender',
      'attendance': AttendanceState.absent
    },
    {
      'name': 'James Brown',
      'role': 'Forward',
      'attendance': AttendanceState.partialPresent
    },
    {
      'name': 'Robert Davis',
      'role': 'Goalkeeper',
      'attendance': AttendanceState.present
    },
    {
      'name': 'Chris Evans',
      'role': 'Midfielder',
      'attendance': AttendanceState.absent
    },
    {
      'name': 'Paul Walker',
      'role': 'Striker',
      'attendance': AttendanceState.present
    },
  ];

  final List<Map<String, dynamic>> coaches = [
    {
      'name': 'Alex Thompson',
      'role': 'Head Coach',
      'attendance': AttendanceState.present
    },
    {
      'name': 'Sarah Wilson',
      'role': 'Assistant Coach',
      'attendance': AttendanceState.present
    },
    {
      'name': 'Mark Anderson',
      'role': 'Fitness Coach',
      'attendance': AttendanceState.absent
    },
    {
      'name': 'Emily Davis',
      'role': 'Technical Coach',
      'attendance': AttendanceState.partialPresent
    },
  ];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _firebaseService.initialize();
  }

  void toggleAttendance(List<Map<String, dynamic>> list, int index) {
    setState(() {
      // Cycle through attendance states: present -> partial-present -> absent -> present
      switch (list[index]['attendance']) {
        case AttendanceState.present:
          list[index]['attendance'] = AttendanceState.partialPresent;
          break;
        case AttendanceState.partialPresent:
          list[index]['attendance'] = AttendanceState.absent;
          break;
        case AttendanceState.absent:
          list[index]['attendance'] = AttendanceState.present;
          break;
      }
    });
  }

  void saveAttendance() async {
    DateTime now = DateTime.now();
    String dateCollection =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

    String getSimpleAttendanceStatus(AttendanceState state) {
      switch (state) {
        case AttendanceState.present:
          return 'present';
        case AttendanceState.partialPresent:
          return 'partial-present';
        case AttendanceState.absent:
          return 'absent';
      }
    }

    try {
      // Save players attendance
      await _firebaseService.getCollection(dateCollection).doc('players').set({
        'timestamp': now,
        'attendance': players
            .map((player) => {
                  'name': player['name'],
                  'attendance': getSimpleAttendanceStatus(player['attendance']),
                })
            .toList(),
      });

      // Save coaches attendance
      await _firebaseService.getCollection(dateCollection).doc('coaches').set({
        'timestamp': now,
        'attendance': coaches
            .map((coach) => {
                  'name': coach['name'],
                  'attendance': getSimpleAttendanceStatus(coach['attendance']),
                })
            .toList(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      print('Error saving attendance: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save attendance'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color getAttendanceColor(AttendanceState state) {
    switch (state) {
      case AttendanceState.present:
        return Colors.green;
      case AttendanceState.partialPresent:
        return Colors.orange;
      case AttendanceState.absent:
        return Colors.red;
    }
  }

  int calculatePresentCount(
      List<Map<String, dynamic>> list, AttendanceState state) {
    return list.where((item) => item['attendance'] == state).length;
  }

  void showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Enter name to search'),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPlayers = players.length;
    final presentPlayers =
        calculatePresentCount(players, AttendanceState.present);
    final partialPresentPlayers =
        calculatePresentCount(players, AttendanceState.partialPresent);
    final totalCoaches = coaches.length;
    final presentCoaches =
        calculatePresentCount(coaches, AttendanceState.present);
    final partialPresentCoaches =
        calculatePresentCount(coaches, AttendanceState.partialPresent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Attendance'),
        actions: [
          IconButton(
            onPressed: showSearchDialog,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tuesday, February 4, 2025',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
            AttendanceSummary(
                presentPlayers: presentPlayers,
                partialPresentPlayers: partialPresentPlayers,
                totalPlayers: totalPlayers,
                presentCoaches: presentCoaches,
                partialPresentCoaches: partialPresentCoaches,
                totalCoaches: totalCoaches),
            const SizedBox(height: 20),
            SectionHeader(title: 'Players'),
            PlayerList(players: players, toggleAttendance: toggleAttendance),
            const SizedBox(height: 20),
            SectionHeader(title: 'Coaches'),
            CoachList(coaches: coaches, toggleAttendance: toggleAttendance),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: saveAttendance,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ).copyWith(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.blue[700];
                      }
                      return Colors.blue[500];
                    }),
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.green[600]?.withOpacity(0.1);
                      }
                      return null;
                    }),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: 'Recent History'),
            const RecentHistory(),
          ],
        ),
      ),
    );
  }
}
