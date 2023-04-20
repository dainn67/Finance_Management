import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/views/DashBoard.dart';
import 'package:phongs_app/views/Housing.dart';
import 'package:phongs_app/views/Statistics.dart';
import 'package:google_fonts/google_fonts.dart';
import '../popupViews/addNewRecord.dart';
import '../data.dart';
import 'Summary.dart';
import 'NavBar.dart';
import 'package:http/http.dart' as http;

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  var currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  var isLoading = false;

  //listen to change data

  @override
  Widget build(BuildContext context) {
    final recordData = Provider.of<Record_Provider>(context);
    final records = recordData.records;

    final state = Provider.of<State_Provider>(context);
    // bool isLoading = state.getLoadingState();

    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: const NavBarView(),
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });

              //THIS SHOULD BE PUT IN DATA.DART INSIDE RECORD_PROVIDER
              var uri = Uri.parse(
                  'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
              try {
                final res = await http.get(uri);
                setState(() {
                  isLoading = false;
                });
                final extractedData = json.decode(res.body) as Map<String,
                    dynamic>; //string is the uniqueID and dynamic is Record object
                final List<Record> records = [];
                extractedData.forEach((key, data) {
                  records.add(Record(key, data['name'], data['money'], data['date'],
                      data['by'], data['type'], data['people']));
                });
              } catch (err) {
                rethrow;
              }
            } /*ngoặc nhọn của onpressed*/,
          ),
        ],
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
//Categories select
          Container(
              height: 85.0,
              color: Colors.blue,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, id) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        cId = id;
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: Text(categories[id],
                            style: GoogleFonts.firaSans(
                                fontSize: 22,
                                color: id == cId ? Colors.white : Colors.black,
                                letterSpacing: 1))),
                  );
                },
              )),
          //Each category view
          getEachPageView(cId, isLoading),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   // shape: const CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.filter_list_alt),
      //         onPressed: () {
      //           filterOption();
      //         },
      //       ),
      //       IconButton(
      //         icon: const Icon(Icons.search),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget getEachPageView(int cId, bool isLoading) {
    if (isLoading)
      return const Center(
        child: CircularProgressIndicator(),
      );
    else {
      switch (cId) {
        case 0:
          return Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: DashBoardView(),
            ),
          );
        case 1:
          return Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: StatisticView(),
            ),
          );
        case 2:
          return Expanded(child: HousingView());
        default:
          return Expanded(child: SummaryView());
      }
    }
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
        return addNewRecordView();
      });

  void filterOption() => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lọc'),
            content: Column(
              children: <Widget>[
                RadioListTile<int>(
                  title: const Text('Tất cả'),
                  value: 1,
                  groupValue: filter,
                  onChanged: (int? value) {
                    setState(() {
                      filter = value!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Đồ gia dụng'),
                  value: 2,
                  groupValue: filter,
                  onChanged: (int? value) {
                    setState(() {
                      filter = value!;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Đồ ăn'),
                  value: 3,
                  groupValue: filter,
                  onChanged: (int? value) {
                    setState(() {
                      filter = value!;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Huỷ'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Lọc'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
