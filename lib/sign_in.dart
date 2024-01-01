import 'dart:convert' as convert;
import 'dart:convert';
import 'package:alsayed/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'show_menu.dart';

const String _baseURL = 'https://alsayedcoffee.000webhostapp.com/';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _loading ? null : () => _handleSubmitted(context),
                    child: const Text('Sign In'),
                  ),
                  const SizedBox(height: 15),
                  TextButton(onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  }, child: const Text("Don't have an account? Create one")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmitted(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      // Call your authentication method
      await signInUser(
        context,
        update,
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _loading = false;
      });

      var authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Check if login was successful
      if (authProvider.isLoggedIn) {
        // Navigate to ShowMenus page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShowMenus(),
          ),
        );
      }
    }
  }
}

Future<void> signInUser(BuildContext context, Function(String text) updateUser, String email, String password) async {
  var authProvider = Provider.of<AuthProvider>(context, listen: false);
  // Define the POST data
  var data = {
    'email': email,
    'password': password,
  };

  // Send the POST request to 'loginValidation.php'
  final response = await http.post(
    Uri.parse('$_baseURL/loginValidation.php'),
    body: json.encode(data),
  );

  if (response.statusCode == 200) {
    final jsonResponse = convert.jsonDecode(response.body);
    if (jsonResponse['status'] == 'success') {
      // User authentication successful
      final user_name = jsonResponse['user_name'];
      authProvider.login(user_name);
    }
    updateUser(jsonResponse['message']);
  } else {
    updateUser('Failed to Login. Please try again later.');
  }
}
