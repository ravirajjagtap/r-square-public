
import 'package:flutter/material.dart';
import 'admin_stat_card.dart';
import 'admin_card.dart';
import 'admin_profile.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> students = [
    {
      'name': 'suajl pawar',
      'attendance': 92,
      'winLoss': [15, 3],
      'level': 'Basic',
      'image': 'assets/images/alex.png',
    },
    {
      'name': 'sarthak bangar',
      'attendance': 88,
      'winLoss': [12, 4],
      'level': 'Intermediate',
      'image': 'assets/images/sarah.png',
    },
    {
      'name': 'Sai bhargav',
      'attendance': 85,
      'winLoss': [10, 5],
      'level': 'Advanced',
      'image': 'assets/images/emily.png',
    },
    {
      'name': 'Saurabh javir',
      'attendance': 85,
      'winLoss': [10, 5],
      'level': 'Basic',
      'image': 'assets/images/emily.png',
    },
  ];

  final List<Map<String, dynamic>> coaches = [
    {
      'name': 'John Doe',
      'position': 'Head Coach',
      'contact': 'john.doe@email.com',
      'image': 'assets/images/coach1.png',
    },
    {
      'name': 'Jane Smith',
      'position': 'Assistant Coach',
      'contact': 'jane.smith@email.com',
      'image': 'assets/images/coach2.png',
    },
  ];

  String currentFilter = 'All';
  String searchQuery = '';

  List<Map<String, dynamic>> get filteredStudents {
    List<Map<String, dynamic>> filtered = students;

    if (currentFilter != 'All') {
      filtered = filtered
          .where((student) => student['level'] == currentFilter)
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

  List<Map<String, dynamic>> get filteredCoaches {
    if (searchQuery.isEmpty) return coaches;
    return coaches
        .where((coach) =>
            coach['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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

  int get basicCount => students.where((s) => s['level'] == 'Basic').length;

  int get intermediateCount =>
      students.where((s) => s['level'] == 'Intermediate').length;

  int get advancedCount =>
      students.where((s) => s['level'] == 'Advanced').length;

  bool _isCoachListVisible = false;

  void _toggleCoachList() {
    setState(() {
      _isCoachListVisible = !_isCoachListVisible;
    });
  }

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
              AdminProfileCard(name: 'Alex thomson',),
              const SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterButton('All'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Basic'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Intermediate'),
                    const SizedBox(width: 8),
                    _buildFilterButton('Advanced'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  StatCard(
                      title: 'Players',
                      value: totalStudents.toString(),
                      icon: Icons.people),
                  StatCard(
                      title: 'Basic',
                      value: basicCount.toString(),
                      icon: Icons.school),
                ],
              ),
              Row(
                children: [
                  StatCard(
                      title: 'Intermediate',
                      value: intermediateCount.toString(),
                      icon: Icons.timeline),
                  StatCard(
                      title: 'Advanced',
                      value: advancedCount.toString(),
                      icon: Icons.emoji_events),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search students or coaches...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _toggleCoachList,
                child: const Text('Coach List',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              if (_isCoachListVisible)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: filteredCoaches.length,
                  itemBuilder: (context, index) {
                    final coach = filteredCoaches[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(coach['image']!),
                      ),
                      title: Text(coach['name']),
                      subtitle:
                          Text('${coach['position']}\n${coach['contact']}'),
                    );
                  },
                ),
              const SizedBox(height: 20),
              const Text('Player List',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return StudentCard(
                    name: student['name'],
                    attendance: '${student['attendance']}%',
                    winLoss:
                        '${student['winLoss'][0]} / ${student['winLoss'][1]}',
                    status: student['level'],
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
