// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _loginController.dispose();
    super.dispose();
  }

  // Search for a user by login
  void _searchUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user =
          await ApiService.getUserByLogin(_loginController.text.trim());

      // Only update state if the widget is still mounted
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          // Navigate to profile screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(user: user),
            ),
          );
        }
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (e.toString().contains('User not found')) {
            _errorMessage =
                'User not found. Please check the login and try again.';
          } else if (e.toString().contains('Failed to load user')) {
            _errorMessage =
                'Error connecting to 42 API. Please try again later.';
          } else {
            _errorMessage = 'An error occurred: ${e.toString()}';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swifty Companion'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: Image.asset(
                      'assets/42_logo.png',
                      height: 120,
                    ),
                  ),

                  Text(
                    'Search for 42 Students',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  SizedBox(height: 32),

                  // Login input field
                  TextFormField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      labelText: 'Enter 42 login',
                      hintText: 'e.g., jdoe',
                      prefixIcon: Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (_) => _searchUser(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a login';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Error message
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[700]),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Search button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _searchUser,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : Text('Search'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
