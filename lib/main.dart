import 'package:fit_tracker/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
   await Supabase.initialize(
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sYmh1aGJtbXNmZnllcG9rdXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE4ODAyODQsImV4cCI6MjA2NzQ1NjI4NH0.1DOyTJfSFCIP2Rbj0mKrBUcbN1HFdv1QKyKNmQLUsWw",
    url: "https://nlbhuhbmmsffyepokuso.supabase.co",
    );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Tracker',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}


