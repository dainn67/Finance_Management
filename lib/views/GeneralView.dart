import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:phongs_app/views/DashBoard.dart';
import 'package:phongs_app/views/Housing.dart';
import 'package:phongs_app/views/Statistics.dart';
import 'package:phongs_app/views/Summary.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../popupViews/addNewRecord.dart';
import '../data.dart';
import 'NavBar.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({Key? key}) : super(key: key);

  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  final List<Widget> pages = [
    const DashBoardView(),
    const StatisticView(),
    const HousingView(),
    const SummaryView()
  ];

  int selectedId = 0;

  @override
  void initState() {
    Provider.of<Record_Provider>(context, listen: false).fetchRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          drawer: const NavBarView(),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.bug_report_outlined),
                onPressed: debug,
              ),
            ],
            elevation: 0.0,
            title: const Text("Welcome back, Đại"),
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
                Tab(icon: Icon(Icons.bar_chart), text: 'Statistics'),
                Tab(icon: Icon(Icons.home), text: 'Housing'),
                Tab(icon: Icon(Icons.summarize), text: 'Summary'),
              ],
            ),
          ),
          body:
              // pages[selectedId],
              const TabBarView(
            children: <Widget>[
              DashBoardView(),
              StatisticView(),
              HousingView(),
              SummaryView()
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addNewRecord();
            },
            // tooltip: 'Increment',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add),
          ),
        ));
  }

  void selectCategories(int id) {
    //id is automatically passed
    setState(() {
      selectedId = id;
    });
  }

  void addNewRecord() => showModalBottomSheet(
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
        return const addNewRecordView();
      });

  Future<void> debug() async{
    print('HI');
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
    final res = await http.post(uri,
        body: json.encode({
          'name': 'Dummy name',
          'money': 200000,
          'date': '20/4/2023',
          'by': 1,
          'type': 2,
          'people': '11111',
        }));

    var record = Record(
        json.decode(res.body)['name'],    //get the unique id back and use as id of record
        'Dummy name',
        200000,
        '20/4/2023',
        1,
        2,
        '11111');

    Provider.of<Record_Provider>(context, listen: false).addRecord(record);
  }
}
