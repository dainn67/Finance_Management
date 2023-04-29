import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/data.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:phongs_app/providers/HousingProvider.dart';
import 'package:provider/provider.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  int displayMonth = DateTime.now().month;
  int displayYear = DateTime.now().year;

  TextEditingController cwallet = TextEditingController();
  TextEditingController cbank = TextEditingController();

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void dispose() {
    cwallet.dispose();
    cbank.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tmpRecord = Provider.of<Record_Provider>(context).records;
    List<Record> f_d_records = [];
    List<Record> h_records = [];
    for(var record in tmpRecord){
      if(record.type == 1) {
        f_d_records.add(record);
      } else {
        h_records.add(record);
      }
    }
    final categoryData = Provider.of<Category_Provider>(context);
    final housingData = Provider.of<Housing_Provider>(context);
    final balanceData = Provider.of<Balance_Provider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white60,
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                editBalance(balanceData);
              }, child: getTileBold('Balance', balanceData.balance)),
          getTileBold(
              'Spending',
              categoryData.fAndD +
                  categoryData.household +
                  housingData.getTotal()),
          const Divider(),
          GestureDetector(
            onTap: () => showRecord(1, categoryData, f_d_records),
              child: getTileWithSub('Food & Drinks', categoryData.fAndD)),
          GestureDetector(
              onTap: () => showRecord(2, categoryData, h_records),
              child: getTileWithSub('Household appliances', categoryData.household)),
          getTile('Electricity bill', housingData.electric),
          getTile('Water bill', housingData.water),
          getTile('External fee', housingData.motorbike),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!(displayMonth == 1 && displayYear == 2023)) {
                            if (displayMonth == 1) {
                              displayMonth = 12;
                              displayYear--;
                            } else {
                              displayMonth--;
                            }
                          }
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(Icons.chevron_left))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text("Date: $displayMonth/$displayYear",
                        style: const TextStyle(fontSize: 22, color: Colors.blue)),
                  ),
                  GestureDetector(
                      onTap: () {
                        if ((displayMonth < DateTime.now().month &&
                                displayYear >= DateTime.now().year) ||
                            displayYear < DateTime.now().year) {
                          setState(() {
                            if (displayMonth == 12) {
                              displayYear++;
                              displayMonth = 1;
                            } else {
                              displayMonth++;
                            }
                          });
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: const Icon(Icons.chevron_right))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTileBold(String text, int value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(text,
                style: GoogleFonts.firaSans(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            trailing: Text(
              currencyFormatter.format(value),
              style: const TextStyle(fontSize: 20),
            ),
          )),
    );
  }

  Widget getTileWithSub(String text, int val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(text, style: GoogleFonts.firaSans(fontSize: 20)),
            subtitle: const Text('Tap for statistic'),
            trailing: Text(
              currencyFormatter.format(val),
              style: const TextStyle(fontSize: 20),
            ),
          )),
    );
  }

  Widget getTile(String text, int val) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            title: Text(text, style: GoogleFonts.firaSans(fontSize: 20)),
            trailing: Text(
              currencyFormatter.format(val),
              style: const TextStyle(fontSize: 20),
            ),
          )),
    );
  }

  void editBalance(Balance_Provider balanceData) => showDialog(
    context: context,
    builder: (BuildContext context) {
      int tmpWallet = 0, tmpBank = 0;

      return AlertDialog(
        title: const Text('Your balance'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: const Icon(Icons.wallet_outlined),
                title: const Text('Wallet'),
                trailing: Text(currencyFormatter.format(balanceData.wallet).toString()),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance_outlined),
                title: const Text('Bank'),
                trailing: Text(currencyFormatter.format(balanceData.bank).toString()),
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Change wallet\'s balance',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: cwallet,
                keyboardType: TextInputType.number,
                onChanged: (string) {
                  string = _formatNumber(string.replaceAll(',', ''));
                  if (string.isNotEmpty) {
                    cwallet.value = TextEditingValue(
                      text: string,
                      selection:
                      TextSelection.collapsed(offset: string.length),
                    );
                    print("TEXT:${cwallet.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                    tmpWallet = int.parse(cwallet.text
                        .replaceAll(RegExp(r'\.\d+'), '')
                        .replaceAll(',', ''));
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Change bank\'s balance',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: cbank,
                keyboardType: TextInputType.number,
                onChanged: (string) {
                  string = _formatNumber(string.replaceAll(',', ''));
                  if (string.isNotEmpty) {
                    cbank.value = TextEditingValue(
                      text: string,
                      selection:
                      TextSelection.collapsed(offset: string.length),
                    );
                    print(
                        "TEXT:${cbank.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                    tmpBank = int.parse(cbank.text
                        .replaceAll(RegExp(r'\.\d+'), '')
                        .replaceAll(',', ''));
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              cwallet.clear();
              cbank.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () {
              if(tmpWallet > 0) balanceData.setWallet(tmpWallet);
              if(tmpBank > 0) balanceData.setBank(tmpBank);
              balanceData.saveData();
              setState( () {
                tmpBank = -1;
                tmpWallet = -1;
              });
              cwallet.clear();
              cbank.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );

  void showRecord(int type, Category_Provider categoryData, List<Record> records) => showDialog(
    context: context,
    builder: (BuildContext context) {

      return AlertDialog(
        title: type == 1 ? const Text('Food & Drinks this month') : const Text('Appliances this month'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: type == 1 ? const Icon(Icons.food_bank_outlined) : const Icon(Icons.home_outlined),
                trailing: Text(currencyFormatter.format(categoryData.fAndD).toString()),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                      itemCount: records.length <= 5 ? records.length : 5,
                      itemBuilder: (context, id) {
                        return ListTile(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                          subtitle: Text(
                              '${records[records.length - id - 1].date.day}/${records[records.length - id - 1].date.month}/${records[records.length - id - 1].date.year}'),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                records[records.length - id - 1]
                                    .name
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                "-${currencyFormatter.format(records[records.length - id - 1].money)}",
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.purple),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
