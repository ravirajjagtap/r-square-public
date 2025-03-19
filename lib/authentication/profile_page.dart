import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isPlayerDetailsExpanded = false;

  Map<String, String> personalInfo = {
    'First Name': 'Alex',
    'Last Name': 'Thompson',
    'Email Address': 'thompson.alex@gmail.com',
    'Phone Number': '+91',
    'Date of Birth': '',
    'Gender': 'Male',
  };

  Map<String, String> playerDetails = {
    'Player Type': 'Player',
    'Skill Level': 'Intermediate',
    'Height (cm)': '',
    'Weight (kg)': '',
    'Status': 'Active',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            child: Text(
              isEditing ? 'Save' : 'Edit',
              style: const TextStyle(color: Color(0xFFAB4824)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage:
                  NetworkImage('https://randomuser.me/api/portraits/men/1.jpg'),
            ),
            const SizedBox(height: 20),
            buildSection('Personal Information', personalInfo),
            const SizedBox(height: 20),
            buildSection(
              'Player Details',
              playerDetails,
              isExpandable: true,
              isExpanded: isPlayerDetailsExpanded,
              onToggle: () {
                setState(() {
                  isPlayerDetailsExpanded = !isPlayerDetailsExpanded;
                });
              },
            ),
            const SizedBox(height: 20),
            buildSecuritySection(),
          ],
        ),
      ),
    );
  }

  Widget buildSection(String title, Map<String, String> data,
      {bool isExpandable = false,
      bool isExpanded = true,
      VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (isExpandable)
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.black,
                ),
              ),
          ],
        ),
        if (isExpanded)
          Card(
            color: const Color(0xFFF5F5F5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: data.keys
                    .map((key) => buildInfoField(key, data[key]!))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildInfoField(String label, String value) {
    bool isEditable = [
      'First Name',
      'Last Name',
      'Phone Number',
      'Date of Birth',
      'Height (cm)',
      'Weight (kg)'
    ].contains(label);

    bool isNumericField = ['Height (cm)', 'Weight (kg)'].contains(label);
    bool isDOB = label == 'Date of Birth';
    bool isPhoneNumber = label == 'Phone Number';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: isDOB
          ? InkWell(
              onTap: isEditing
                  ? () async {
                      var pickedDate = await DatePicker.showSimpleDatePicker(
                        context,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        dateFormat: "dd-MMMM-yyyy",
                        locale: DateTimePickerLocale.en_us,
                        looping: true,
                      );

                      if (pickedDate != null) {
                        setState(() {
                          personalInfo['Date of Birth'] =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                        });
                      }
                    }
                  : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isEditing ? Colors.white : const Color(0xFFE0E0E0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: isEditing ? Colors.black : Colors.black54,
                  ),
                ),
                child: Text(
                  value.isEmpty ? 'Date of Birth' : value,
                  style: TextStyle(
                    fontSize: 16,
                    color: isEditing ? Colors.black : Colors.black54,
                  ),
                ),
              ),
            )
          : isPhoneNumber
              ? IntlPhoneField(
                  initialValue: value,
                  initialCountryCode: 'IN',
                  enabled: isEditing,
                  disableLengthCheck: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isEditing ? Colors.white : const Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    labelText: label,
                    labelStyle: TextStyle(
                        color: isEditing ? Colors.black : Colors.black54),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (phone) {
                    if (phone == null ||
                        phone.number.length < 10 ||
                        phone.number.length > 10) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                  onChanged: (phone) {
                    setState(() {
                      personalInfo[label] = phone.completeNumber;
                    });
                  },
                )
              : TextFormField(
                  initialValue: value,
                  keyboardType: isNumericField
                      ? TextInputType.number
                      : TextInputType.text,
                  inputFormatters: isNumericField
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [],
                  enabled: isEditing && isEditable,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isEditing ? Colors.white : const Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    labelText: label,
                    labelStyle: TextStyle(
                        color: isEditing ? Colors.black : Colors.black54),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      if (isNumericField) {
                        playerDetails[label] = newValue;
                      } else {
                        personalInfo[label] = newValue;
                      }
                    });
                  },
                ),
    );
  }

  Widget buildSecuritySection() {
    return Card(
      color: const Color(0xFFF5F5F5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.lock, color: Colors.black54),
        title: const Text('Change Password',
            style: TextStyle(color: Colors.black)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black54),
        onTap: () {},
      ),
    );
  }
}
