import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/popupViews/walletView.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import 'Statistics.dart';

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

    final stateData = Provider.of<Loading_State_Provider>(context);
    var isLoading = stateData.getLoadingState;

    final dashboardData = Provider.of<Category_Provider>(context);
    dashboardData.loadData();

    final balanceData = Provider.of<Balance_Provider>(context);

    return RefreshIndicator(
      onRefresh: () {
        stateData.changeState();
        print('Refresh:\nisLoading: ${stateData.getLoadingState}');
        return refreshRecords(context, stateData);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WalletView(1)));
                  },
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
                        const Icon(Icons.account_balance_wallet_outlined),
                        const SizedBox(height: 10),
                        Text("Wallet",
                            style: GoogleFonts.firaSans(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20.0),
                        Text(currencyFormat.format(balanceData.wallet),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WalletView(2)));
                  },
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
                        const Icon(Icons.account_balance_outlined),
                        const SizedBox(height: 10),
                        Text(
                          "Bank",
                          style: GoogleFonts.firaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(currencyFormat.format(balanceData.bank),
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            getTitle(records, isLoading),
            getRecentRecords(isLoading, records),
          ],
        ),
      ),
    );
  }

  Widget getTitle(List<Record> records, bool isLoading) {
    if (isLoading) {
      return Container();
    } else {
      if (records.isNotEmpty) {
        return Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text("Recent records",
                  style: GoogleFonts.firaSans(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            ],
          ),
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              Text("No recent expenses",
                  style: GoogleFonts.firaSans(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        );
      }
    }
  }

  Widget getRecentRecords(bool isLoading, List<Record> records) {
    switch (isLoading) {
      case true:
        return Column(
          children: const [
            SizedBox(height: 200),
            Center(child: CircularProgressIndicator()),
          ],
        );
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
                          buildLeading(records[records.length - id - 1].source),
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      subtitle: Text('${records[records.length - id - 1].date.day}/${records[records.length - id - 1].date.month}/${records[records.length - id - 1].date.year}'),
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
                          case 1:
                            return const Icon(Icons.fastfood_outlined);
                          case 2:
                            return const Icon(Icons.home_work_outlined);
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
      return const Icon(Icons.account_balance_wallet_outlined);
    default:
      return const Icon(Icons.account_balance_outlined);
  }
}
