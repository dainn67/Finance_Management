import 'package:flutter/material.dart';
import 'package:phongs_app/providers/AuthenProvider.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:phongs_app/providers/DisplaySummaryProvider.dart';
import 'package:phongs_app/providers/HousingProvider.dart';
import 'package:phongs_app/providers/LoadingStateProvider.dart';
import 'package:phongs_app/providers/OthersProvider.dart';
import 'package:phongs_app/providers/RecordProvider.dart';
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
        ChangeNotifierProxyProvider<Authen_Provider, Housing_Provider>(
          update: (context, auth, _) => Housing_Provider(auth.token),
            create: (context) => Housing_Provider('')),
        ChangeNotifierProxyProvider<Authen_Provider, Category_Provider>(
          update: (context, auth, _) => Category_Provider(auth.token),
            create: (context) => Category_Provider('')),
        ChangeNotifierProxyProvider<Authen_Provider, Balance_Provider>(
            update: (context, auth, _) => Balance_Provider(auth.token),
            create: (context) => Balance_Provider('')),
        ChangeNotifierProvider(create: (context) => Other_Provider()),
        ChangeNotifierProvider(create: (context) => Display_Summary_Provider()),
      ],
      child: Consumer<Authen_Provider>(
        builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            home:
                // GeneralScreen())
                auth.getIsAuth
                    ? const GeneralScreen()
                    : FutureBuilder(
                        future: auth.autoLogin(),
                        initialData: 'Loading...',
                        builder: (ctx, authResSnapShot) =>
                            authResSnapShot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashView()
                                : const AuthenView(),
                      )),
      ),
    );
  }
}
