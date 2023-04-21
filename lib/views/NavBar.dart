import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../data.dart';
import 'AboutUs.dart';
import 'UserGuide.dart';

class NavBarView extends StatefulWidget {
  const NavBarView({Key? key}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  @override
  Widget build(BuildContext context) {
    final recordData = Provider.of<Record_Provider>(context);
    final records = recordData.records;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:
                const Text("Dai. Nguyen", style: TextStyle(color: Colors.white)),
            accountEmail: const Text("nguyendai060703@gmail.com",
                style: TextStyle(color: Colors.white)),
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
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("Reset this month"),
              onTap: () => resetThisMonth()),
          ListTile(
            leading: const Icon(Icons.question_mark),
            title: const Text("User guide"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserGuide())),
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
                onPressed: () {
                  setState(() {
                    // records.clear();
                    totalFood = 0;
                    totalStationery = 0;

                    for (int i = 0; i < 4; i++) {
                      for (int j = 0; j <= 12; j++) {
                        check[i][j] = 0;
                        house[i][j] = 500000;
                        electric[i][j] = 0;
                        water[i][j] = 0;
                        motorFee[i][j] = 80000;
                        for (int k = 0; k <= 4; k++) {
                          moneyToPayy[i][j][k] = 0;
                          saved[i][j][k] = 0;
                        }
                      }
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void resetThisMonth() => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm action'),
        content: const Text('Are you sure you want to reset this month\'s data ?'),
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
              setState(() {
                int tmpFood = 0, tmpStationery = 0;
                int thisMonth = DateTime.now().month;
                int thisYearHashed = DateTime.now().year % 2020 - 3;

                //remove records of that month
                // for(int i=records.length-1; i>=0; i--){
                //   List<String> dateParts = records[i]["date"].split('/');
                //   int month = int.parse(dateParts[1]);
                //   int year = int.parse(dateParts[2]) % 2020 - 3;
                //   print("CUR MONTH: $month CUR YEAR: $year");
                //   if(month == thisMonth && year == thisYearHashed){
                //     if(records[i]["type"] == 1) {
                //       tmpFood += int.parse(records[i]["money"].toString());
                //     } else {
                //       tmpStationery += int.parse(records[i]["money"].toString());
                //     }
                //     print('DELETE ${records[i]}');
                //     records.remove(records[i]);
                //   }
                // }

                //refund the money of that month

                totalFood -= tmpFood;
                totalStationery -= tmpStationery;

                print("NEW FOOD: $totalFood NEW STA $totalStationery");

                check[thisYearHashed][thisMonth] = 0;
                house[thisYearHashed][thisMonth] = 500000;
                electric[thisYearHashed][thisMonth] = 0;
                water[thisYearHashed][thisMonth] = 0;
                motorFee[thisYearHashed][thisMonth] = 80000;
                for (int k = 0; k <= 4; k++) {
                  moneyToPayy[thisYearHashed][thisMonth][k] = 0;
                  saved[thisYearHashed][thisMonth][k] = 0;
                }
              });

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
}
