import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:alsayed/sign_in.dart';
import 'package:http/http.dart' as http;

const String _baseURL = 'https://alsayedcoffee.000webhostapp.com/';
String username = '';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  void _handleSubmitted() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState!.validate()) {

      // Send the POST request to createUser.php with the updated values
      createUser(
            (text) {
          update(text);
          if (text == 'Sign up successful!') {
            // Reset controllers after successful signup
            _nameController.clear();
            _usernameController.clear();
            _phoneController.clear();
            _addressController.clear();
            _emailController.clear();
            _passwordController.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInPage()),
            );
          }
        },
        _nameController.text,
        _usernameController.text,
        _phoneController.text,
        _addressController.text,
        _emailController.text,
        _passwordController.text,
        userRole: 0,
        targetFile: 'targetFile',
      );
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration:
                const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _loading ? null : _handleSubmitted,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 15),
              TextButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInPage(),
                  ),
                );
              }, child: const Text("already have an account? SignIn")),

            ],
          ),
        ),
      ),
    );
  }
}

Future<void> createUser(
    Function(String text) updateUser,
    String name,
    String username,
    String phone_number,
    String address,
    String email,
    String password, {
      int? userRole,
      String? targetFile,
    }) async {
  // Define the POST data
  var data = {
    'name': name,
    'username': username,
    'phone_number': phone_number,
    'address': address,
    'email': email,
    'password': password,
    'userRole': userRole,
    'targetFile': targetFile,
    'key': 'your_key'
  };
  print(data);
  // Send the POST request to 'createUser.php'
  final response = await http.post(
    Uri.parse('$_baseURL/createUser.php'),
    body: json.encode(data),
  );

  // Update the UI with the response from the server
  if (response.statusCode == 200) {
    updateUser(response.body);
  } else {
    updateUser('Failed to create user. Please try again later.');
  }
}
