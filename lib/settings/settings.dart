import 'package:flutter/material.dart';
import 'package:tennis/authentication/login_screen.dart';
import 'package:tennis/authentication/profile_page.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String firstName = "John"; // Default values
  String lastName = "Doe";
  String email = "john.doe@example.com"; // Keep email static for now

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Settings Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // Profile Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage('assets/icons/profile.jpg'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstName $lastName", // Updated dynamically
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            email,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );

                        if (result != null && result is Map<String, String>) {
                          setState(() {
                            firstName = result['firstName'] ?? firstName;
                            lastName = result['lastName'] ?? lastName;
                          });
                        }
                      },
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              // Account & Security Section
              SettingsSection(title: "Account & Security", children: [
                SettingsTile(icon: Icons.lock, title: "Password & Security"),
                SettingsTile(icon: Icons.security, title: "Two-Factor Authentication"),
                SettingsTile(icon: Icons.privacy_tip, title: "Privacy Settings"),
                SettingsTile(icon: Icons.info, title: "Account Information"),
              ]),

              // Preferences Section
              SettingsSection(title: "Preferences", children: [
                SettingsTile(icon: Icons.notifications, title: "Notifications"),
                SettingsTile(icon: Icons.language, title: "Language & Region"),
                SettingsTile(icon: Icons.palette, title: "Theme"),
                SettingsTile(icon: Icons.volume_up, title: "Sound & Haptics"),
              ]),

              // App Settings Section
              SettingsSection(title: "App Settings", children: [
                SettingsTile(icon: Icons.storage, title: "Storage & Data"),
                SettingsTile(icon: Icons.help, title: "Help & Support"),
                SettingsTile(icon: Icons.info_outline, title: "About"),
                SettingsTile(icon: Icons.description, title: "Terms & Privacy"),
              ]),

              SizedBox(height: 20),

              // Version & Sign Out
              Text("Version 1.0.0", style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text("Sign Out", style: TextStyle(color: Colors.red)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


// Widget for Section Title
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
          ),
          Column(children: children),
        ],
      ),
    );
  }
}

// Widget for Individual Setting Item
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
