import 'package:flutter/material.dart';
import 'stat_card.dart';
import 'student_card.dart';

class CoachDashboard extends StatefulWidget {
  const CoachDashboard({super.key});

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  final List<Map<String, dynamic>> students = [
    {
      'name': 'suajl pawar',
      'attendance': 92,
      'winLoss': [15, 3],
      'status': 'active',
      'image': 'assets/images/alex.png',
    },
    {
      'name': 'sarthak bangar',
      'attendance': 88,
      'winLoss': [12, 4],
      'status': 'active',
      'image': 'assets/images/sarah.png',
    },
    {
      'name': 'Sai bhargav',
      'attendance': 85,
      'winLoss': [10, 5],
      'status': 'inactive',
      'image': 'assets/images/emily.png',
    },
    {
      'name': 'Saurabh javir',
      'attendance': 85,
      'winLoss': [10, 5],
      'status': 'inactive',
      'image': 'assets/images/emily.png',
    },
  ];

  String currentFilter = 'All';
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredStudents {
    List<Map<String, dynamic>> filtered = students;

    if (currentFilter != 'All') {
      filtered = filtered
          .where((student) => student['status'] == currentFilter.toLowerCase())
          .toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((student) =>
              student['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void updateFilter(String filter) {
    setState(() {
      currentFilter = filter;
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  int get totalStudents => students.length;

  double get attendancePercentage {
    int activeStudents = students.where((s) => s['status'] == 'active').length;
    return students.isEmpty ? 0 : (activeStudents / totalStudents) * 100;
  }

  double get winRate => students.isEmpty
      ? 0
      : students.map((s) => s['winLoss'][0]).reduce((a, b) => a + b) /
          students
              .map((s) => s['winLoss'][0] + s['winLoss'][1])
              .reduce((a, b) => a + b) *
          100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoachCard(),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search students...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: updateSearchQuery,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterButton('All'),
                  _buildFilterButton('Active'),
                  _buildFilterButton('Inactive'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  StatCard(
                      title: 'Students',
                      value: totalStudents.toString(),
                      icon: Icons.people),
                  StatCard(
                      title: 'Attendance',
                      value: '${attendancePercentage.toStringAsFixed(1)}%',
                      icon: Icons.bar_chart),
                  StatCard(
                      title: 'Win Rate',
                      value: '${winRate.toStringAsFixed(1)}%',
                      icon: Icons.emoji_events),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Player List',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return StudentCard(
                    name: student['name'],
                    attendance: '${student['attendance']}%',
                    winLoss:
                        '${student['winLoss'][0]} / ${student['winLoss'][1]}',
                    status: student['status'],
                    image: student['image'],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoachCard() {
    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(
                    width: 20), // Add spacing between avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Coach Alex',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Position: Head Coach',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(Icons.notifications),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String filter) {
    final isSelected = currentFilter == filter;
    return ElevatedButton(
      onPressed: () => updateFilter(filter),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(filter),
    );
  }
}
