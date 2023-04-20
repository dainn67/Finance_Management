import 'package:flutter/material.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/views/GeneralView.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Record_Provider()),
        ChangeNotifierProvider(create: (context) => State_Provider()),
      ],
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home:
              // LoginPage()
              // HomePageView()
              GeneralScreen()
              // PlannedPayment()
          ),
    );
  }
}
