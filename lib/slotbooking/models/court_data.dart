class Court {
  final String name;
  final String iconPath;
  bool isAvailable;
  List<Timing> timings;

  Court({
    required this.name,
    required this.iconPath,
    required this.isAvailable,
    required this.timings,
  });
}

class Timing {
  final String startTime;
  final String endTime;
  final int rate;
  bool isCourtAvailable;

  Timing({
    required this.startTime,
    required this.endTime,
    required this.rate,
    required this.isCourtAvailable,
  });
}

Court? selectedCourt;
Timing? selectedTiming;

List<Court> getCourtsForSelectedDate(int selectedDay) {
  DateTime now = DateTime.now();
  DateTime selectedDateTime = DateTime(now.year, now.month, selectedDay);

  return [
    Court(
      name: 'Court 1',
      iconPath: 'assets/icons/Court 1.jpg',
      isAvailable: selectedDateTime.day % 2 == 0,
      timings: [
        Timing(startTime: '08:00 AM', endTime: '09:00 AM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '09:00 AM', endTime: '10:00 AM', rate: 600, isCourtAvailable: false),
        Timing(startTime: '10:00 AM', endTime: '11:00 AM', rate: 500, isCourtAvailable: true),
        Timing(startTime: '11:00 AM', endTime: '12:00 PM', rate: 500, isCourtAvailable: true),
        Timing(startTime: '12:00 PM', endTime: '01:00 PM', rate: 500, isCourtAvailable: false),
        Timing(startTime: '01:00 PM', endTime: '02:00 PM', rate: 500, isCourtAvailable: true),
        Timing(startTime: '02:00 PM', endTime: '03:00 PM', rate: 500, isCourtAvailable: true),
        Timing(startTime: '03:00 PM', endTime: '04:00 PM', rate: 500, isCourtAvailable: false),
        Timing(startTime: '04:00 PM', endTime: '05:00 PM', rate: 700, isCourtAvailable: true),
      ],
    ),
    Court(
      name: 'Court 2',
      iconPath: 'assets/icons/Court 2.jpg',
      isAvailable: selectedDateTime.day % 3 != 0,
      timings: [
        Timing(startTime: '08:00 AM', endTime: '09:00 AM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '09:00 AM', endTime: '10:00 AM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '10:00 AM', endTime: '11:00 AM', rate: 600, isCourtAvailable: false),
        Timing(startTime: '11:00 AM', endTime: '12:00 PM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '12:00 PM', endTime: '01:00 PM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '01:00 PM', endTime: '02:00 PM', rate: 600, isCourtAvailable: false),
        Timing(startTime: '02:00 PM', endTime: '03:00 PM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '03:00 PM', endTime: '04:00 PM', rate: 600, isCourtAvailable: true),
        Timing(startTime: '04:00 PM', endTime: '05:00 PM', rate: 600, isCourtAvailable: false),
      ],
    ),
    Court(
      name: 'Court 3',
      iconPath: 'assets/icons/Court 3.jpg',
      isAvailable: selectedDateTime.day % 5 != 0,
      timings: [
        Timing(startTime: '08:00 AM', endTime: '09:00 AM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '09:00 AM', endTime: '10:00 AM', rate: 700, isCourtAvailable: false),
        Timing(startTime: '10:00 AM', endTime: '11:00 AM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '11:00 AM', endTime: '12:00 PM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '12:00 PM', endTime: '01:00 PM', rate: 700, isCourtAvailable: false),
        Timing(startTime: '01:00 PM', endTime: '02:00 PM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '02:00 PM', endTime: '03:00 PM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '03:00 PM', endTime: '04:00 PM', rate: 700, isCourtAvailable: true),
        Timing(startTime: '04:00 PM', endTime: '05:00 PM', rate: 700, isCourtAvailable: true),
      ],
    ),
  ];
}

