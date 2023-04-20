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
                onPressed: () async {
                  Provider.of<State_Provider>(context, listen: false).changeLoading();

                  //THIS SHOULD BE PUT IN DATA.DART INSIDE RECORD_PROVIDER
                  var uri = Uri.parse(
                      'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
                  try {
                    final res = await http.get(uri);

                    final extractedData = json.decode(res.body) as Map<String,
                        dynamic>; //string is the uniqueID and dynamic is Record object
                    final List<Record> records = [];
                    extractedData.forEach((key, data) {
                      records.add(Record(
                          key,
                          data['name'],
                          data['money'],
                          data['date'],
                          data['by'],
                          data['type'],
                          data['people']));
                    });

                    Provider.of<State_Provider>(context, listen: false).changeLoading();
                  } catch (err) {
                    rethrow;
                  }
                } /*ngoặc nhọn của onpressed*/,
              ),
            ],
            elevation: 0.0,
            title: const Text("Finance management"),
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
          // bottomNavigationBar: BottomNavigationBar(
          //   onTap: selectCategories,
          //   unselectedItemColor: Colors.white60,
          //   selectedItemColor: Colors.white,
          //   currentIndex: selectedId,
          //   type: BottomNavigationBarType.shifting,
          //   items: const [
          //     BottomNavigationBarItem(
          //         backgroundColor: Colors.lightBlue,
          //         icon: Icon(Icons.dashboard),
          //         label: 'Dashboard'),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.bar_chart),
          //         label: 'Statistics'),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.home),
          //         label: 'Housing'),
          //     BottomNavigationBarItem(
          //         icon: Icon(Icons.summarize),
          //         label: 'Summary'),
          //   ],
          // ),
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
}
