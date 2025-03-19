import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:tennis/authentication/login_screen.dart';
import 'package:tennis/services/firebase_service.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String selectedRole = 'Coach';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  // Add a GlobalKey for the form
  final _formKey = GlobalKey<FormState>();

  bool _isEmailAvailable = true;
  bool _isCheckingEmail = false;
  String _emailStatusMessage = '';
  Color _emailStatusColor = Colors.transparent;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password to bytes
    var digest = sha256.convert(bytes); // Create SHA-256 hash
    return digest.toString(); // Convert hash to string
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  Future<void> _checkEmailAvailability(String email) async {
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailStatusMessage = '';
        _emailStatusColor = Colors.transparent;
      });
      return;
    }

    setState(() {
      _emailStatusMessage = 'Checking email availability...';
      _emailStatusColor = Colors.blue;
    });

    try {
      await _firebaseService.initialize();
      final emailQuery = await _firebaseService
          .getCollection('users')
          .where('Email_Address', isEqualTo: email)
          .get();

      setState(() {
        if (emailQuery.docs.isEmpty) {
          _emailStatusMessage = 'Email verified successfully';
          _emailStatusColor = Colors.green;
        } else {
          _emailStatusMessage =
              'An account with this email already exists please try with a different email';
          _emailStatusColor = Colors.red;
        }
      });
    } catch (e) {
      setState(() {
        _emailStatusMessage = 'Error checking email availability';
        _emailStatusColor = Colors.red;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    if (!_isEmailAvailable) {
      return 'This email is already registered';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _registerUser() async {
    // Validate all fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await _firebaseService.initialize();

      // Check if email already exists
      final email = _emailController.text;
      final emailQuery = await _firebaseService
          .getCollection('users')
          .where('Email_Address', isEqualTo: email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An account with this email already exists'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userData = {
        'User_Id': Uuid().v4(),
        'User_Type': selectedRole,
        'First_Name': _firstNameController.text,
        'Last_Name': _lastNameController.text,
        'Email_Address': email,
        'Password': _hashPassword(_passwordController.text),
        'Active': true,
        'Created_By': 'System',
        'Created_Date': DateTime.now().toIso8601String(),
        'Modified_By': null,
        'Modified_Date': null,
        'Contact_Number': null,
        'Birth_Date': null,
        'Gender': null,
        'Weight': null,
        'Height': null,
      };

      // Use email as document ID
      await _firebaseService.getCollection('users').doc(email).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account successfully created!'),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Your account creation has been failed please try again after some time: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: const AssetImage('assets/icons/logo.png'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please fill in the details below to get started',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildRoleButton('Coach'),
                      const SizedBox(width: 10),
                      _buildRoleButton('Player'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('First Name', Icons.person,
                      controller: _firstNameController,
                      validator: _validateName),
                  _buildTextField('Last Name', Icons.person,
                      controller: _lastNameController,
                      validator: _validateName),
                  _buildTextField('Email Address', Icons.email,
                      controller: _emailController,
                      validator: _validateEmail, onChanged: (value) {
                    _checkEmailAvailability(value);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailStatusMessage,
                        style: TextStyle(
                          color: _emailStatusColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  _buildTextField('Password', Icons.lock,
                      obscureText: true,
                      controller: _passwordController,
                      validator: _validatePassword),
                  _buildTextField('Confirm Password', Icons.lock,
                      obscureText: true,
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFAB4824),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _registerUser,
                      child: const Text('Create Account',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(color: Colors.white)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                              color: Color(0xFFAB4824),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("or continue with",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text('Sign up with Google',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon,
      {bool obscureText = false,
      TextEditingController? controller,
      String? Function(String?)? validator,
      ValueChanged<String>? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white70, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[900],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: Colors.red[400]),
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    bool isSelected = selectedRole == role;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFFAB4824) : Colors.grey[800],
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(() {
            selectedRole = role;
          });
        },
        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
