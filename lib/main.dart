import 'package:flutter/material.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/views/AuthenScreen.dart';
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
        ChangeNotifierProvider(create: (context) => Loading_State_Provider()),
        ChangeNotifierProvider.value(value: Authen_Provider())
      ],
      child: Consumer<Authen_Provider>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: auth.isAuth ? const GeneralScreen() : const AuthenView()),
      ),
    );
  }
}
