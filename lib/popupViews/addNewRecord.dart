import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../data.dart';

class addNewRecordView extends StatefulWidget {
  const addNewRecordView({super.key});

  @override
  _addNewRecordViewState createState() => _addNewRecordViewState();
}

class _addNewRecordViewState extends State<addNewRecordView> {
  late TextEditingController cname, cmoney, cnote;
  DateTime _selectedDate = DateTime.now();
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  int type = 1;
  int source = 1;
  String note = '';

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void initState() {
    super.initState();
    cname = TextEditingController();
    cmoney = TextEditingController();
    cnote = TextEditingController();
  }

  @override
  void dispose() {
    cname.dispose();
    cmoney.dispose();
    cnote.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = Provider.of<Category_Provider>(context, listen: false);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: Text("New record",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.lightBlue[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  typeSelection(),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Record\'s name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cname,
                    onChanged: (string) {
                      print("CNAME TEXT: ${cname.text}");
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Amount (vnd)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cmoney,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        cmoney.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "CMONEY TEXT:${cmoney.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text("Source",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  sourceSelector(),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cnote,
                    onChanged: (val) {
                      note = val ?? '';
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(
                          "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(width: 16.0),
                      TextButton(
                          onPressed: () async {
                            _selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2025),
                            ) as DateTime;
                            // setState(() {});
                          },
                          child: const Text(
                            "Change",
                            style: TextStyle(fontSize: 18.0),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    submit_done(dashboardData).then((_) {
                    }).catchError((err) {
                      Navigator.of(context).pop();
                      print("ERROR HERE 2: $err");
                    });
                  },
                  child: const Text("Add")),
            ),
          ],
        ));
  }

  CupertinoSlidingSegmentedControl typeSelection() {
    return CupertinoSlidingSegmentedControl(
      groupValue: type,
      children: {
        1: Builder(
          builder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const Center(
              child: Text(
                'Food & Drinks',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
        ),
        2: Builder(
          builder: (context) => SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: const Center(
              child: Text(
                'Household',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
        )
      },
      onValueChanged: (value) {
        setState(() {
          type = value!;
        });
      },
    );
  }

  CupertinoSlidingSegmentedControl sourceSelector() {
    return CupertinoSlidingSegmentedControl(
      groupValue: source,
      children: {
        1: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Wallet'),
          ),
        ),
        2: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Bank'),
          ),
        ),
      },
      onValueChanged: (value) {
        setState(() {
          source = value!;
        });
      },
    );
  }

  Future<void> submit_done(Category_Provider dashboardData) async {
    try{
      final data = Provider.of<Record_Provider>(context, listen: false);
      final balanceData = Provider.of<Balance_Provider>(context, listen: false);
      final categoryData = Provider.of<Category_Provider>(context, listen: false);

      int money = int.parse(cmoney.text
          .replaceAll(RegExp(r'\.\d+'), '')
          .replaceAll(',', '')
          .toString());

      if(source == 1) {
        balanceData.addToWallet(money);
      } else {
        balanceData.addToBank(money);
      }

      if(type == 1){
        categoryData.addToFAD(money);
      }else{
        categoryData.addToHousehold(money);
      }

      //SEND HTTP REQUEST & ADD RECORD LOCALLY
      // final date = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      data.addRecord(cname.text, money, _selectedDate , source, type, note, context);

      cname.clear();
      cmoney.clear();
    } catch (err){
      print(err);
      rethrow;
    } finally {
      Navigator.of(context).pop();
    }
  }
}