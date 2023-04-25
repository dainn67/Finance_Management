import 'package:flutter/material.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/providers/CategoriesTitleProvider.dart';
import 'package:phongs_app/views/AuthenScreen.dart';
import 'package:phongs_app/views/GeneralView.dart';
import 'package:phongs_app/views/SpashLoading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Authen_Provider()),
        ChangeNotifierProxyProvider<Authen_Provider, Record_Provider>(
          update: (context, auth, previousProduct) => Record_Provider(
              auth.token,
              previousProduct == null ? [] : previousProduct.records,
              auth.userId),
          create: (context) => Record_Provider('Hi', [], ''),
        ),
        ChangeNotifierProvider(create: (context) => Loading_State_Provider()),
      ],
      child: Consumer<Authen_Provider>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home: auth.getIsAuth
                ? const GeneralScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    initialData: 'Loading...',
                    builder: (ctx, authResSnapShot) =>
                        authResSnapShot.connectionState == ConnectionState.waiting
                            ? const SplashView()
                            : const AuthenView(),
                  )),
      ),
    );
  }
}
