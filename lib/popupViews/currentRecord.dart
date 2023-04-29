import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data.dart';

class currentRecordView extends StatefulWidget {
  int index, type, source;
  String note;
  DateTime date;

  // currentRecordView(i, type, source, note, date);
  currentRecordView(this.index, this.type, this.source, this.note, this.date, {super.key});

  @override
  _currentRecordViewState createState() => _currentRecordViewState();
}

class _currentRecordViewState extends State<currentRecordView> {
  late TextEditingController cname, cmoney, cnote;
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  static const _locale = 'en';

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();

  bool isChanged = false;

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  String note = '';
  late int type;
  late int source;
  late DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    type = widget.type;
    source = widget.source;
    note = widget.note;
    _selectedDate = widget.date;
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
    final records = Provider.of<Record_Provider>(context, listen: false).records;

    final authData = Provider.of<Authen_Provider>(context, listen: false);
    final authToken = authData.token;
    final userId = authData.userId;

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: Text("Record detail",
                  style: GoogleFonts.firaSans(fontSize: 22, fontWeight: FontWeight.bold)),
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
                      hintText: 'Name: ${records[widget.index].name}',
                      // labelText: 'Record\'s name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cname,
                    onChanged: (string) {
                      isChanged = true;
                      // print("CNAME TEXT: ${cname.text}");
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText:
                          'Amount: ${_formatNumber(records[widget.index].money.toString())}',
                      // labelText: 'Amount (vnd)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cmoney,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      isChanged = true;
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        // print("STRING: $string");
                        cmoney.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print("CMONEY TEXT:${cmoney.text}");
                      }
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text("Purchaser",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  sourceSelector(),
                  const SizedBox(height: 20),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Note: $note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: cnote,
                    onChanged: (val) {
                      note = val ?? '';
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            displayDate(),
            const SizedBox(height: 1),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    // state.changeLoading();
                    update_record(widget.index, authToken!, userId!);
                    // .then((_) {
                    //   // state.changeLoading();
                    // }).catchError((err) {
                    //   // Navigator.of(context).pop();
                    //   print("ERROR (ELEVATED BUTTON): $err");
                    // });
                  },
                  child: isChanged ? const Text("Change") : const Text("OK")),
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
          isChanged = true;
          type = value!;
          print('type: $type');
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
          isChanged = true;
          source = value!;
          setState(() {});
          print('source: $source');
        });
      },
    );
  }

  Center displayDate() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 8),
          Text(
              "Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16.0),
          TextButton(
              onPressed: () async {
                _selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                ) as DateTime;
                setState(() {
                  isChanged = true;
                });
              },
              child: const Text(
                "Change",
                style: TextStyle(fontSize: 18.0),
              )),
        ],
      ),
    );
  }

  void update_record(int index, String authToken, String userId) {
    print(
        'DATA:\n$type\n${cname.text}\n${cmoney.text}\n$source\n${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}\n$note');
    try{
      final data = Provider.of<Record_Provider>(context, listen: false);

      int money = 0;
      if(cmoney.text.isNotEmpty) {
        money = int.parse(cmoney.text
            .replaceAll(RegExp(r'\.\d+'), '')
            .replaceAll(',', '')
            .toString());
      }

      //SEND HTTP REQUEST
      final uri = Uri.parse('https://phong-s-app-default-rtdb.firebaseio.com/records/${data.records[index].id}.json?$authToken');
      // final uri = Uri.parse('https://phong-s-app-default-rtdb.firebaseio.com/useronly/$userId/${data.records[index].id}.json?$authToken');
      //second url is for add favourite only, so it has /useronly/$userId
      http.patch(uri,
          body: json.encode({
            'name': cname.text.isNotEmpty ? cname.text : data.records[widget.index].name,
            'money': cmoney.text.isNotEmpty ? money : data.records[widget.index].money,
            'date': _selectedDate.toIso8601String(),
            'source': source,
            'type': type,
            'note': note,
          }));
      print('Patch done');
      data.fetchRecord().then((value) => print('FETCH done after PATCH'));

      cname.clear();
      cmoney.clear();
      // Navigator.of(context).pop();
    } catch (err){
      print(err);
      rethrow;
    } finally {
      Navigator.of(context).pop();
    }
  }
}
