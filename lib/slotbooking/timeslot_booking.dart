import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:tennis/attendance/screens/attendance_screen.dart';
import 'package:tennis/slotbooking/models/court_data.dart';
import 'package:tennis/slotbooking/models/date_model.dart';

class DateContainerScreen extends StatefulWidget {
  const DateContainerScreen({super.key});

  @override
  _DateContainerScreenState createState() => _DateContainerScreenState();
}

class _DateContainerScreenState extends State<DateContainerScreen> {
  List<DateModel> dates = DateModel.getNextFiveDays();
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  List<Timing> timings = selectedCourt != null ? selectedCourt!.timings : [];
  int selectedIndex = 0;
  List<Court> courts = [];
  String? customSelectedDate;
  Court? _selectedCourt;
  bool showBookingContainer = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    courts = getCourtsForSelectedDate(selectedDate.day);
    _selectedCourt = courts.isNotEmpty ? courts.first : null;

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout() {
    var options = {
      'key': 'rzp_test_OUhYW8lBKQ0NP0',
      'amount': (selectedTiming!.rate * 100).toInt(), // Flat rate for now
      'currency': 'INR',
      'name': 'Tennis Court Booking',
      'description': 'Booking for ${_selectedCourt?.name}',
      'prefill': {'contact': '7286094304', 'email': 'user@example.com'},
      'theme': {'color': '#2563EB'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint("Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint("Payment Failed: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet Selected: ${response.walletName}");
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        customSelectedDate = "${picked.day} ${_getMonthName(picked.month)}";
        selectedIndex = -1;
        courts = getCourtsForSelectedDate(selectedDate.day);
        _selectedCourt = courts.isNotEmpty ? courts.first : null;
      });
    }
  }

  void selectCourt(Court court) {
    setState(() {
      _selectedCourt = court;
      showBookingContainer = true;
    });
  }

  String _getMonthName(int month) {
    return [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ][month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(children: [
        dateSelection(context),
        courtSelection(),
        availableSlots(_selectedCourt),
        if (showBookingContainer && selectedTiming != null) bookingContainer(),
      ]),
    );
  }

  Container availableSlots(Court? selectedCourt) {
    if (selectedCourt == null && courts.isNotEmpty) {
      selectedCourt =
          courts[0]; // Set the initial selected court to the first one
    }

    int rowCount = (selectedCourt!.timings.length / 3).ceil();
    double heightPerRow = 100.0;
    double totalHeight = rowCount * heightPerRow;

    return Container(
      width: double.infinity,
      height: totalHeight,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(padding: EdgeInsets.only(top: 12)),
          Align(
            alignment: AlignmentDirectional(-1, -1),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(17, 0, 0, 0),
              child: Text(
                'Available Slots',
                style: TextStyle(
                  fontFamily: 'Inter Tight',
                  letterSpacing: 0.0,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Container(
              width: 360,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.7,
                  mainAxisSpacing: 8,
                ),
                shrinkWrap: true,
                itemCount: selectedCourt.timings.length,
                itemBuilder: (context, index) {
                  final timing = selectedCourt!.timings[index];
                  bool isSelected = selectedTiming == timing;
                  return GestureDetector(
                      onTap: () {
                        if (timing.isCourtAvailable) {
                          setState(() {
                            if (isSelected) {
                              selectedTiming = null; // Deselect timing
                              showBookingContainer =
                                  false; // Hide booking container
                            } else {
                              selectedTiming = timing; // Select timing
                              showBookingContainer = true;
                            }
                          });
                        }
                      },
                      child: Align(
                        alignment: AlignmentDirectional(-1, -1),
                        child: Container(
                          width: 110,
                          height: 68,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF2563EB)
                                : timing.isCourtAvailable
                                    ? Color(0xFFF0FDF4)
                                    : Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Color(0xFF2563EB)
                                  : timing.isCourtAvailable
                                      ? Color(0xFF22C55E)
                                      : Color(0xFFF3F4F6),
                              width: isSelected ? 2.0 : 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 11, 0, 0),
                                child: Text(
                                  timing.startTime,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: isSelected
                                        ? Colors.white
                                        : timing.isCourtAvailable
                                            ? Color(0xFF15803D)
                                            : Color(0xFF9CA3AF),
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
                                child: Text(
                                  timing.isCourtAvailable
                                      ? 'Rs. ${timing.rate}/hr'
                                      : 'Booked',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: isSelected
                                        ? Colors.white
                                        : timing.isCourtAvailable
                                            ? Color(0xFF15803D)
                                            : Color(0xFF9CA3AF),
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container courtSelection() {
    return Container(
        width: double.infinity,
        alignment: Alignment.center,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(17, 0, 0, 0),
                  child: Text(
                    'Select Court',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Inter Tight',
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(17, 15, 0, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 569.3,
                                height: 135,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: courts
                                          .map((court) => CourtCard(
                                                court: court,
                                                onCourtSelected:
                                                    (Court selectedCourt) {
                                                  setState(() {
                                                    _selectedCourt =
                                                        selectedCourt;
                                                  });
                                                },
                                              ))
                                          .toList(),
                                    )),
                              )
                            ]),
                      )))
            ]));
  }

  Center dateSelection(BuildContext context) {
    return Center(
      child: Container(
        height: 120,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scrolling
          child: Row(
            children: [
              SizedBox(width: 23), // Padding at start
      
              // Generate first five date containers
              ...List.generate(dates.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedDate = DateTime.now().add(Duration(days: index));
                      customSelectedDate = null;
                      courts = getCourtsForSelectedDate(selectedDate.day);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 72,
                    width: 55,
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? Color(0xFF2563EB) // Selected = Blue
                          : Color(0xFFF9FAFB), // Unselected = Grey
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dates[index].day, // Show day
                          style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Color(0xFF111827),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          dates[index].date, // Show date
                          style: TextStyle(
                            color: selectedIndex == index
                                ? Colors.white
                                : Color(0xFF4B5563),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
      
              // Sixth container to open calendar
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 72,
                  width: 55,
                  decoration: BoxDecoration(
                    color: selectedIndex == -1
                        ? Color(0xFF2563EB) // Custom selected = Blue
                        : Color(0xffF9FAFB), // Default = Grey
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today,
                          color: selectedIndex == -1
                              ? Colors.white
                              : Color(0xFF111827),
                          size: 20),
                      SizedBox(height: 5),
                      Text(
                        customSelectedDate ?? "Pick",
                        style: TextStyle(
                          color: selectedIndex == -1
                              ? Colors.white
                              : Color(0xFF111827),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      
              SizedBox(width: 23), // Padding at end
            ],
          ),
        ),
      ),
    );
  }

  Container bookingContainer() {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selected Time',
                          style: TextStyle(fontFamily: 'Inter')),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          'Today, ${selectedTiming!.startTime} - ${selectedTiming!.endTime}',
                          style: TextStyle(
                            fontFamily: 'Inter Tight',
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 60,
                decoration: BoxDecoration(color: Colors.white),
                alignment: Alignment.centerRight,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('Total Price', style: TextStyle(fontFamily: 'Inter')),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        'Rs. ${selectedTiming!.rate}',
                        style: TextStyle(
                          fontFamily: 'Inter Tight',
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _openCheckout, // ✅ Fixed: Passing function reference
            child: Container(
              width: 360,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Book Now',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter Tight',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourtCard extends StatelessWidget {
  final Court court;
  final Function(Court) onCourtSelected;

  const CourtCard({
    super.key,
    required this.court,
    required this.onCourtSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCourtSelected(court);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 13),
        child: Container(
          width: 175,
          height: 135,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Color(0xFFE5E7EB),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 175,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.asset(
                        court.iconPath,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(1, -1),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 4, 2, 0),
                        child: SizedBox(
                          width: 81.2,
                          height: 28,
                          child: Stack(
                            alignment: AlignmentDirectional(1, -1),
                            children: [
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: court.isAvailable
                                        ? Color(0xFFDCFCE7)
                                        : Color.fromARGB(255, 232, 151, 151),
                                    borderRadius: BorderRadius.circular(50),
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                      court.isAvailable
                                          ? "Available"
                                          : "Booked",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: court.isAvailable
                                            ? Color(0xFF16A34A)
                                            : Color.fromARGB(255, 209, 62, 62),
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 175,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(12, 6, 0, 0),
                        child: Container(
                          width: 120,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Text(
                            court.name,
                            style: TextStyle(
                              fontFamily: 'Inter Tight',
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AppBar appBar() {
  return AppBar(
    title: Text(
      "Court Bookings",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    ),
    backgroundColor: Color(0xffF9FAFB),
    centerTitle: true,
    leading: Builder(
    builder: (context) => GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/Arrow - Left 2.svg',
          height: 20,
          width: 20,
        ),
      ),
    )),
    actions: [
      GestureDetector(
        onTap: () {},
        child: Container(
          margin: EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
          alignment: Alignment.center,
          width: 37,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/filters.svg',
            height: 30,
          ),
        ),
      )
    ],
  );
}
