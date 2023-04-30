import 'package:flutter/material.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/AuthenProvider.dart';
import '../providers/HousingProvider.dart';
import '../providers/RecordProvider.dart';
import 'AboutUs.dart';
import 'UserGuide.dart';
import 'package:http/http.dart' as http;

class NavBarView extends StatefulWidget {
  const NavBarView({Key? key}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  @override
  Widget build(BuildContext context) {
    final authenData = Provider.of<Authen_Provider>(context);
    final mail = authenData.displayEmail;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Hello",
                style: TextStyle(color: Colors.white)),
            accountEmail: Text(mail,
                style: const TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/images/big_mouth_cat.jpg",
                    height: 90, width: 90, fit: BoxFit.cover),
              ),
            ),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/chill_background.jpg"),
                    fit: BoxFit.cover)),
          ),
          ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Reset"),
              onTap: () => reset()),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("User guide"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => UserGuide())),
          ),
          ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                setting();
              }),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("App's information"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AboutUs())),
          ),
          ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Log out"),
              onTap: () {
                logOut();
              }),
        ],
      ),
    );
    ;
  }

  void reset() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm action'),
            content: const Text('Are you sure you want to reset every thing?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Agree'),
                onPressed: () async {
                  final authToken = Provider.of<Authen_Provider>(context, listen: false).token;
                  for(int i = 4; i<=12; i++){
                    var uri = Uri.parse(
                        'https://phong-s-app-default-rtdb.firebaseio.com/records_${i}_${DateTime.now().year}.json?$authToken');
                    http.delete(uri).then((value) => print('Reset complete'));
                  }
                  Provider.of<Record_Provider>(context, listen: false).clearRecord();
                  Provider.of<Category_Provider>(context, listen: false).resetAll();
                  Provider.of<Balance_Provider>(context, listen: false).resetAll();
                  Provider.of<Housing_Provider>(context, listen: false).resetAll();
                  final prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void help() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('User guide'),
            content: const Text('Note debug: Cho file readme vào đây'),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void setting() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Settings'),
            content: const Text('No settings yet'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void logOut() => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm action'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Agree'),
            onPressed: () {
              Provider.of<Authen_Provider>(context, listen: false).logout();
              Navigator.of(context).pop();
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => const GeneralScreen()));

            },
          ),
        ],
      );
    },
  );
}
