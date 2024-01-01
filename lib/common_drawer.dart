import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // Import your AuthProvider
import 'show_menu.dart';
import 'sign_in.dart';
import 'sign_up.dart';

class CommonDrawer extends StatelessWidget {
  CommonDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    bool isLoggedIn = authProvider.isLoggedIn;
    String? userName = authProvider.userName;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coffe Sayed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                if (isLoggedIn)
                  Text(
                    'Welcome, $userName!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  )
                else
                  Text(
                    'Please sign in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ShowMenus()));
            },
          ),
          if (isLoggedIn)
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Call the logout method in AuthProvider
                authProvider.logout();
                // Navigate back to the home page or any other page
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignInPage())
                );
              },
            ),
          if (!isLoggedIn)
            ListTile(
              title: const Text('Sign In'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignInPage()));
              },
            ),
          if (!isLoggedIn)
            ListTile(
              title: const Text('Sign Up'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SignUpPage()));
              },
            ),
        ],
      ),
    );
  }
}
