import 'package:alsayed/show_menu.dart';
import 'package:alsayed/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffe Sayed',
        home: authProvider.isLoggedIn ? ShowMenus() : SignInPage());
  }
}
