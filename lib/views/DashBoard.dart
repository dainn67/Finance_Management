import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data.dart';

class DashBoardView extends StatefulWidget {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  State<DashBoardView> createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  var currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  Widget build(BuildContext context) {
    final recordData = Provider.of<Record_Provider>(context);
    final records = recordData.records;

    final state = Provider.of<State_Provider>(context);
    final isLoading = state.getLoadingState();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(2, 6),
                        )
                      ]),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.fastfood_outlined),
                      const SizedBox(height: 10),
                      Text("Food",
                          style: GoogleFonts.firaSans(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20.0),
                      Text(currencyFormat.format(totalFood),
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(2, 6),
                        )
                      ]),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.home_work_outlined),
                      const SizedBox(height: 10),
                      Text(
                        "Household",
                        style: GoogleFonts.firaSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(currencyFormat.format(totalStationery),
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          records.isNotEmpty
              ? Center(
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Text("Recent record",
                          style: GoogleFonts.firaSans(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2),
                      Text("No recent expense",
                          style: GoogleFonts.firaSans(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
          getRecentRecords(isLoading, records),
        ],
      ),
    );
  }

  Widget getRecentRecords(bool isLoading, List<Record> records) {
    switch (isLoading) {
      case true:
        return const Center(child: CircularProgressIndicator());
      default:
        if (records.isNotEmpty) {
          return Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ListView.builder(
                  itemCount: records.length <= 5 ? records.length : 5,
                  itemBuilder: (context, id) {
                    return ListTile(
                      leading:
                          buildLeading(records[records.length - id - 1].by),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      subtitle: Text(
                          records[records.length - id - 1].date.toString()),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            records[records.length - id - 1].name.toString(),
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5.0),
                          Text(
                            "-${currencyFormat.format(records[records.length - id - 1].money)}",
                            style: const TextStyle(
                                fontSize: 16.0, color: Colors.purple),
                          ),
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
                    );
                  }),
            ),
          );
        } else {
          return Container();
        }
    }
  }
}

Widget buildLeading(int value) {
  switch (value) {
    case 1:
      return Text('Phong',
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ));
    case 2:
      return Text('Khánh',
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ));
    case 3:
      return Text('Tùng',
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ));
    case 4:
      return Text('Lâm',
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ));
    default:
      return Text('Hiển',
          style: GoogleFonts.firaSans(
            fontSize: 16,
          ));
  }
}
