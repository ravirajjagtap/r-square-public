import 'package:flutter/material.dart';
import 'package:tennis/services/firebase_service.dart';

class CourtSlotManagementScreen extends StatefulWidget {
  const CourtSlotManagementScreen({super.key});

  @override
  _CourtSlotManagementScreenState createState() =>
      _CourtSlotManagementScreenState();
}

class _CourtSlotManagementScreenState extends State<CourtSlotManagementScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  int selectedCourt = 1;

  Map<int, List<Slot>> courtSlots = {
    1: List.generate(4, (index) => Slot()),
    2: List.generate(4, (index) => Slot()),
    3: List.generate(4, (index) => Slot()),
  };

  void initState() {
    super.initState();
    _firebaseService.initialize();
  }


Future<void> _saveSlotsToFirebase() async {
  String courtId = "Court_$selectedCourt";

  
  List<Map<String, dynamic>> slotsData = courtSlots[selectedCourt]!.map((slot) {
    return {
      "startTime": slot.startTime.format(context),
      "endTime": slot.endTime.format(context),
      "ratePerHour": slot.ratePerHour,
    };
  }).toList();

  try {
    // Check if the court document exists
    var documentSnapshot = await _firebaseService.getCollection("courtSlots").doc(courtId).get();

    if (!documentSnapshot.exists) {
      // Create court document if it doesn't exist
      await _firebaseService.getCollection("courtSlots").doc(courtId).set({
        'slots': slotsData, // Directly store slots in court document
      });
    } else {
      // Update existing court document with new slots data
      await _firebaseService.getCollection("courtSlots").doc(courtId).update({
        'slots': slotsData, // Update the slots array inside the court document
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Slots saved successfully!"), backgroundColor: Colors.green),
    );
  } catch (error) {
    print('Error saving slots: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save slots: $error"), backgroundColor: Colors.red),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Court Slot Management",
            style: TextStyle(fontSize: 18),
            overflow: TextOverflow.visible,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _saveSlotsToFirebase,
            child: const Text("Save",
                style: TextStyle(color: Colors.blue, fontSize: 16)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _courtTab(1, "Court 1"),
              _courtTab(2, "Court 2"),
              _courtTab(3, "Court 3"),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _numberOfSlotsWidget(),
                    ...courtSlots[selectedCourt]!.asMap().entries.map((entry) {
                      int index = entry.key;
                      Slot slot = entry.value;
                      return _slotWidget(index, slot);
                    }).toList(),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _addNewSlot,
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Slot"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _courtTab(int courtNumber, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCourt = courtNumber;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              selectedCourt == courtNumber ? Colors.blue : Colors.grey.shade300,
          foregroundColor:
              selectedCourt == courtNumber ? Colors.white : Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _numberOfSlotsWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Number of Slots", style: TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  if (courtSlots[selectedCourt]!.length > 1) {
                    setState(() {
                      courtSlots[selectedCourt]!.removeLast();
                    });
                  }
                },
              ),
              Text(courtSlots[selectedCourt]!.length.toString(),
                  style: const TextStyle(fontSize: 18)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    courtSlots[selectedCourt]!.add(Slot());
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slotWidget(int index, Slot slot) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Slot ${index + 1}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete), // Removed red color
                  onPressed: () {
                    if (courtSlots[selectedCourt]!.length > 1) {
                      setState(() {
                        courtSlots[selectedCourt]!.removeAt(index);
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: _timePickerField("Start Time", slot.startTime,
                        (newTime) => setState(() => slot.startTime = newTime))),
                const SizedBox(width: 8),
                Expanded(
                    child: _timePickerField("End Time", slot.endTime,
                        (newTime) => setState(() => slot.endTime = newTime))),
              ],
            ),
            const SizedBox(height: 8),
            _rateField(slot),
          ],
        ),
      ),
    );
  }

  Widget _timePickerField(
      String label, TimeOfDay time, Function(TimeOfDay) onTimePicked) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.access_time),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      controller: TextEditingController(text: time.format(context)),
      onTap: () async {
        TimeOfDay? pickedTime =
            await showTimePicker(context: context, initialTime: time);
        if (pickedTime != null) onTimePicked(pickedTime);
      },
    );
  }

  Widget _rateField(Slot slot) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Rate per hour",
        prefixText: "\$ ",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      initialValue: slot.ratePerHour.toString(),
      onChanged: (value) {
        setState(() {
          slot.ratePerHour = double.tryParse(value) ?? slot.ratePerHour;
        });
      },
    );
  }

  void _addNewSlot() {
    setState(() {
      courtSlots[selectedCourt]!.add(Slot());
    });
  }
}

class Slot {
  TimeOfDay startTime;
  TimeOfDay endTime;
  double ratePerHour;

  Slot(
      {this.startTime = const TimeOfDay(hour: 9, minute: 0),
      this.endTime = const TimeOfDay(hour: 10, minute: 0),
      this.ratePerHour = 30.0});
}
