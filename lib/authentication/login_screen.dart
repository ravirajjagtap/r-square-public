import 'package:flutter/material.dart';
import 'package:tennis/attendance/screens/attendance_screen.dart';
import 'package:tennis/attendance/screens/user_specific_attendance_view.dart';
import 'package:tennis/authentication/reset_password_screen.dart';
import 'package:tennis/authentication/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (username == 'admin' && password == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AttendanceScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black87,
        body: SingleChildScrollView(
            child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/icons/logo.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign in to continue to your account',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(Icons.email, 'Email Address',
                      controller: _usernameController),
                  SizedBox(height: 10),
                  _buildTextField(Icons.lock, 'Password',
                      obscureText: true, controller: _passwordController),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFAB4824),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () => _login(context),
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ",
                          style: TextStyle(color: Colors.white70)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUpScreen()), // Directly go to SignUpScreen
                          );
                        },
                        child: Text('Sign Up',
                            style: TextStyle(color: Color(0xFFAB4824))),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordScreen()),
                      );
                    },
                    child: Text('Forgot Password?',
                        style: TextStyle(color: Color(0xFFAB4824))),
                  ),
                  SizedBox(height: 20),
                  Text('Or continue with',
                      style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton('Google', Icons.g_mobiledata),
                      SizedBox(width: 10),
                      _buildSocialButton('Apple', Icons.apple),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )));
  }

  Widget _buildTextField(IconData icon, String hintText,
      {bool obscureText = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white10,
        prefixIcon: Icon(icon, color: Colors.white70),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
