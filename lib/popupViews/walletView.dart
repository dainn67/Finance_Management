import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/providers/AuthenProvider.dart';
import 'package:phongs_app/providers/BalanceProvider.dart';
import 'package:provider/provider.dart';
import '../providers/LoadingStateProvider.dart';
import '../providers/RecordProvider.dart';

class WalletView extends StatefulWidget {
  int wallerOrBank;

  WalletView(this.wallerOrBank, {super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final TextEditingController _edit = TextEditingController();

  int tmpValue = 0;

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void dispose() {
    _edit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final balanceData = Provider.of<Balance_Provider>(context);
    final stateData = Provider.of<Loading_State_Provider>(context);
    final recordData = Provider.of<Record_Provider>(context);
    final tmpRecords = recordData.records;
    final authenData = Provider.of<Authen_Provider>(context);
    List<Record> records = [];
    for (var record in tmpRecords) {
      if(widget.wallerOrBank == 1) {
        if (record.source == 1) records.add(record);
      } else {
        if(record.source == 2) records.add(record);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: widget.wallerOrBank == 1 ? const Text('Your wallet') : const Text('Your bank account'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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
                    title: Text('Balance',
                        style: GoogleFonts.firaSans(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: widget.wallerOrBank == 1 ? Text(
                      currencyFormatter.format(balanceData.wallet),
                      style: const TextStyle(fontSize: 20),
                    ) : Text(
                      currencyFormatter.format(balanceData.bank),
                      style: const TextStyle(fontSize: 20),
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        editBalance(balanceData, authenData.token ?? '');
                      },
                      child: const Icon(Icons.edit_note_outlined),
                    ),
                  )),
            ),
            const SizedBox(height: 10),
            const Text('Recent records', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
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
                  child: !stateData.getLoadingState ? RefreshIndicator(
                    onRefresh: () {
                      stateData.changeState();
                      // print('START REFRESH:\nisLoading: ${stateData.getLoadingState}');
                      return refreshRecords(context, stateData);
                    },
                    child: ListView.builder(
                        itemCount: records.length <= 5 ? records.length : 5,
                        itemBuilder: (context, id) {
                          return ListTile(
                            leading: buildLeading(
                                records[records.length - id - 1].source),
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
                  ) : const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildLeading(int value) {
    switch (value) {
      case 1:
        return const Icon(Icons.account_balance_wallet_outlined);
      default:
        return const Icon(Icons.account_balance_outlined);
    }
  }

  Future<void> refreshRecords(BuildContext context, Loading_State_Provider stateData) async {
    await Provider.of<Record_Provider>(context, listen: false)
        .fetchRecord(true)
        .then((_) {

      stateData.changeState();
    }).catchError((err) {
      print('Refresh error: $err');
    });
  }

  void editBalance(Balance_Provider balanceData, String authToken) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update balance'),
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.height * 0.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter new value (VND)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _edit,
                keyboardType: TextInputType.number,
                onChanged: (string) {
                  string = _formatNumber(string.replaceAll(',', ''));
                  if (string.isNotEmpty) {
                    _edit.value = TextEditingValue(
                      text: string,
                      selection:
                      TextSelection.collapsed(offset: string.length),
                    );
                    print(
                        "TEXT:${_edit.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                    tmpValue = int.parse(_edit.text
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
              _edit.clear();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () {
              if(tmpValue > 0){
                if(widget.wallerOrBank == 1) {
                  balanceData.setWallet(tmpValue);
                } else {
                  balanceData.setBank(tmpValue);
                }
                balanceData.saveData();
              }
              _edit.clear();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
