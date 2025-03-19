import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class AttendanceCalendar extends StatefulWidget {
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  DateTime _currentDate = DateTime.now();
  Map<int, Color> attendanceMap = {};

  @override
  void initState() {
    super.initState();
    _generateRandomAttendance();
  }

  void _generateRandomAttendance() {
    Random random = Random();
    int daysInMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    
    attendanceMap.clear();
    
    for (int day = 1; day <= daysInMonth; day++) {
      int randomValue = random.nextInt(3); // 0, 1, or 2
      attendanceMap[day] = randomValue == 0
          ? Colors.blue // Present
          : randomValue == 1
              ? Colors.red // Absent
              : Colors.orange; // Partially Present
    }
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + offset, 1);
      _generateRandomAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    String monthYear = DateFormat('MMMM yyyy').format(_currentDate);
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    int firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1).weekday;
    int prevMonthDaysToShow = firstDayOfMonth == 7 ? 0 : firstDayOfMonth - 1;
    int prevMonthDays = DateTime(_currentDate.year, _currentDate.month, 0).day;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                monthYear,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekDays.map((day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )).toList(),
          ),
          SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(42, (index) {
              int day = index - prevMonthDaysToShow + 1;
              Color dayColor = Colors.black;
              BoxDecoration decoration = BoxDecoration(color: Colors.transparent);
              int daysInCurrentMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;

              if (day <= 0) {
                day = prevMonthDays + day;
                dayColor = Colors.grey;
              } else if (day > daysInCurrentMonth) {
                day = day - daysInCurrentMonth;
                dayColor = Colors.grey;
              } else {
                decoration = BoxDecoration(
                  color: attendanceMap[day], // Get the assigned color
                  shape: BoxShape.circle,
                );
              }

              return Center(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: decoration,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: dayColor == Colors.red ? Colors.white : Colors.black, // Red text needs white color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
