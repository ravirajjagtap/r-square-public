import 'package:intl/intl.dart';

class DateModel {
  String day;
  String date;

  DateModel({required this.day, required this.date});

  static List<DateModel> getNextFiveDays() {
    DateTime today = DateTime.now();
    return List.generate(5, (index) {
      DateTime date = today.add(Duration(days: index));
      return DateModel(
        day: DateFormat('EEE').format(date),  // "Mon", "Tue", etc.
        date: DateFormat('dd').format(date),  // "12 Feb", "13 Feb", etc.
      );
    });
  }
}
