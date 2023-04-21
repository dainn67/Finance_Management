import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../popupViews/currentRecord.dart';
import 'DashBoard.dart';

class StatisticView extends StatefulWidget {
  const StatisticView({Key? key}) : super(key: key);

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> {
  var currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  bool localIsLoading = false;


  @override
  Widget build(BuildContext context) {
    final recordData = Provider.of<Record_Provider>(context);
    final records = recordData.records;

    final stateData = Provider.of<Loading_State_Provider>(context);
    bool isLoading = stateData.getLoadingState;


    switch (isLoading) {
      case true:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
            onRefresh: () {
              stateData.changeState();
              localIsLoading = true;
              print('Refresh:\nisLoading: ${stateData.getLoadingState}\nLocal Loading state: $localIsLoading');
              return refreshRecords(context, stateData).then((value) {
                print('RES: $localIsLoading');
              });
            },
            child: records.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, id) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                              const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) {
                              return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Delete record"),
                                    content: const Text(
                                        "Are you sure you want to delete this record"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); //return false so that confirmDismiss don't delete the record
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); //return true so that confirmDismiss delete the record
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.red),
                                          ))
                                    ],
                                  ));
                            },
                            onDismissed: (_) {
                              // stateData.changeState();
                              // print('Start dismiss: ${stateData.getLoadingState}');
                              dismissRecord(recordData, stateData, records.length - id - 1);
                            },
                            child: ListTile(
                              onTap: () {
                                detail_edit(records, records.length - id - 1);
                              },
                              leading: buildLeading(
                                  records[records.length - id - 1].by),
                              subtitle:
                                  Text(records[records.length - id - 1].date),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    records[records.length - id - 1].name,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                      "-${currencyFormat.format(records[records.length - id - 1].money)}",
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.purple)),
                                ],
                              ),
                              trailing: (() {
                                switch (records[records.length - id - 1].type) {
                                  case 2:
                                    return const Icon(Icons.home_work_outlined);
                                  case 1:
                                    return const Icon(Icons.fastfood_outlined);
                                }
                              })(),
                            ),
                          );
                        }),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'No expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ));
    }
  }

  void detail_edit(List<Record> records, int i) => showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        side: BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        int type = records[i].type;
        int buyer = records[i].by;
        String people = records[i].people;
        String date = records[i].date;
        return currentRecordView(i, type, buyer, people, date);
      });

  void detailAndEdit(List<Record> records, int id) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Detail'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(records[id].name,
                        style: GoogleFonts.firaSans(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    title: Text("Amount",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(currencyFormat.format(records[id].money),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Purchaser",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(getBuyer(records[id].by),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Users",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    subtitle: Text(getPeople(records[id].people)),
                    trailing: Text(getNumberOfPeople(records[id].people)),
                  ),
                  ListTile(
                    title:
                        Text("Date", style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(records[id].date,
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                  ListTile(
                    title: Text("Each pay",
                        style: GoogleFonts.firaSans(fontSize: 22)),
                    trailing: Text(
                        currencyFormat.format(getEqualMoney(
                            records[id].money, records[id].people)),
                        style: GoogleFonts.firaSans(fontSize: 22)),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Change'),
                onPressed: () {
                  // _electric.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () async {
                  // electric[hashYear(displayYear)][displayMonth] = int.parse(
                  //     _electric.text
                  //         .replaceAll(RegExp(r'\.\d+'), '')
                  //         .replaceAll(',', ''));
                  // final fileElectric = await _localElectric;
                  // fileElectric.writeAsStringSync(jsonEncode(electric));
                  // _electric.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  String getBuyer(int i) {
    switch (i) {
      case 1:
        return "Phong";
      case 2:
        return "Khánh";
      case 3:
        return "Tùng";
      case 4:
        return "Lâm";
      default:
        return "Hiển";
    }
  }

  String getPeople(String s) {
    String res = "";
    if (s[0] == '1') res = res + "Phong";
    if (s[1] == '1') res = res + " Khánh";
    if (s[2] == '1') res = res + " Tùng";
    if (s[3] == '1') res = res + " Lâm";
    if (s[4] == '1') res = res + " Hiển";
    return res;
  }

  String getNumberOfPeople(String s) {
    int count = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == '1') count++;
    }
    return "$count";
  }

  int getEqualMoney(int money, String s) {
    return money ~/ int.parse(getNumberOfPeople(s));
  }

  Future<void> refund(
      int money, int buyer, String people, String date, int type) async {
    List<String> dateParts = date.split('/');
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    int hashYear = 0;
    switch (year) {
      case 2023:
        hashYear = 0;
        break;
      case 2024:
        hashYear = 1;
        break;
      case 2025:
        hashYear = 2;
        break;
      case 2026:
        hashYear = 3;
        break;
    }

    //tính tiền hoàn lại mọi người
    if (type == 1) {
      totalFood -= money;
    } else {
      totalStationery -= money;
    }
    int equal = getEqualMoney(money, people);
    if (buyer == 2) {
      if (people[0] == '1') moneyToPayy[hashYear][month][1] -= equal;
      for (int i = 2; i <= 4; i++) {
        if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
      }
    } else {
      if (people[buyer - 1] == '0') {
        if (buyer == 1) {
          moneyToPayy[hashYear][month][1] += money;
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
          }
        } else {
          moneyToPayy[hashYear][month][buyer - 1] += money;
          if (people[0] == '1') moneyToPayy[hashYear][month][1] -= equal;
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1' && i != buyer - 1)
              moneyToPayy[hashYear][month][i] -= equal;
          }
        }
      } else {
        if (buyer == 1) {
          moneyToPayy[hashYear][month][1] +=
              equal * (int.parse(getNumberOfPeople(people)) - 1);
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1') moneyToPayy[hashYear][month][i] -= equal;
          }
        } else {
          moneyToPayy[hashYear][month][buyer - 1] +=
              equal * (int.parse(getNumberOfPeople(people)) - 1);
          for (int i = 2; i <= 4; i++) {
            if (people[i] == '1' && i != buyer - 1)
              moneyToPayy[hashYear][month][i] -= equal;
          }
        }
      }
    }
  }

  Future<void> getAndSetRecords() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
    try {
      final res = await http.get(uri);
      print(res);
    } catch (err) {
      rethrow;
    }
  }

  // Future<void> refreshRecords(BuildContext context, Loading_State_Provider stateData) async {
  //   await Provider.of<Record_Provider>(context, listen: false)
  //       .fetchRecord()
  //       .then((_) {
  //
  //     stateData.changeState();
  //     localIsLoading = false;
  //
  //     print('Loading state: ${stateData.getLoadingState}\nLocal Loading State: $localIsLoading');
  //   }).catchError((err) {
  //     print('Refresh error: $err');
  //   });
  // }

  Future<void> dismissRecord(Record_Provider recordData, Loading_State_Provider stateData, int id) async {
      recordData
          .removeRecord(id)
          .then((_) {
        stateData.changeState();
        print('isLoading: ${stateData.getLoadingState} - delete successfully');
      }).catchError((err) {
        stateData.changeState();
        print('isLoading: ${stateData.getLoadingState} - delete failed');
      });
      stateData.changeState();
  }
}

Future<void> refreshRecords(BuildContext context, Loading_State_Provider stateData) async {
  await Provider.of<Record_Provider>(context, listen: false)
      .fetchRecord()
      .then((_) {

    stateData.changeState();

    print('Loading state: ${stateData.getLoadingState}');
  }).catchError((err) {
    print('Refresh error: $err');
  });
}