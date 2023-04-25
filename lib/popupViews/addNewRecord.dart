import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../data.dart';

class addNewRecordView extends StatefulWidget {
  const addNewRecordView({super.key});

  @override
  _addNewRecordViewState createState() => _addNewRecordViewState();
}

class _addNewRecordViewState extends State<addNewRecordView> {
  late TextEditingController cname, cmoney;
  DateTime _selectedDate = DateTime.now();
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();


  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  int type = 1;
  int buyer = 1;
  List<bool> people = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    cname = TextEditingController();
    cmoney = TextEditingController();
  }

  @override
  void dispose() {
    cname.dispose();
    cmoney.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
  }

  @override
  // Widget build(BuildContext context) {
  //   return Form(
  //     key: _form,
  //       child: Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: ListView(
  //       children: <Widget>[
  //         Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.lightBlueAccent,
  //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //           ),
  //           child: const Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Center(
  //               child: Text(
  //                 "NEW RECORD",
  //                 style: TextStyle(
  //                   fontSize: 20.0,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Record Name', err),
  //           textInputAction: TextInputAction.next,
  //           onFieldSubmitted: (_) {
  //             FocusScope.of(context).requestFocus(_priceFocusNode);
  //           },
  //           onSaved: (value) {
  //             print(value);
  //           },
  //           validator: (val) {
  //             if(val != null && val.isEmpty) return 'Enter name';
  //             else return null;
  //           },
  //         ),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Money'),
  //           keyboardType: TextInputType.number,
  //           textInputAction: TextInputAction.next,
  //           focusNode: _priceFocusNode,
  //           onFieldSubmitted: (_) {
  //             FocusScope.of(context).requestFocus(_descFocusNode);
  //           },
  //         ),
  //         TextFormField(
  //           decoration: const InputDecoration(labelText: 'Description'),
  //           maxLines: 3,
  //           keyboardType: TextInputType.multiline,
  //           focusNode: _descFocusNode,
  //         ),
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: <Widget>[
  //             Container(
  //               width: 100,
  //               height: 100,
  //               margin: const EdgeInsets.only(top: 8, right: 10),
  //               decoration: BoxDecoration(
  //                   border: Border.all(width: 1, color: Colors.grey)),
  //               child: _imgURLController.text.isEmpty
  //                   ? const Text("Enter an URL")
  //                   : FittedBox(
  //                       fit: BoxFit.cover,
  //                       child: Image.network(_imgURLController.text),
  //                     ),
  //             ),
  //             Expanded(
  //               child: TextFormField(
  //                 decoration: const InputDecoration(labelText: 'ImageURL'),
  //                 keyboardType: TextInputType.url,
  //                 textInputAction: TextInputAction.done,
  //                 controller: _imgURLController,
  //                 focusNode: _imgFocusNode,
  //                 onFieldSubmitted: (_) {
  //                   saveForm();
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //         Center(
  //           child: ElevatedButton(
  //               onPressed: () async {
  //                 // submit_done();
  //                 saveForm();
  //                 setState(() {});
  //               },
  //               child: const Text("Add")),
  //         ),
  //       ],
  //     ),
  //   ));
  // }
  // void saveForm() {
  //   bool isValid = false;
  //   if(_form.currentState?.validate() == null) isValid = false;
  //   else isValid = _form.currentState?.validate();
  //   if(isValid == true) _form.currentState?.save();
  //   else return;
  // }

  Widget build(BuildContext context) {

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
                  const Text("Purchaser",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 10),
                  payerSelection(),
                  const SizedBox(height: 20),
                  const Center(
                      child: Text("User(s)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20))),
                  selectUsers(),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Center(
                child: Row(
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
              ),
            ),
            const SizedBox(height: 1),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    submit_done().then((_) {
                    }).catchError((err) {
                      // Navigator.of(context).pop();
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
                'Stationery',
                style: TextStyle(color: Colors.purple),
              ),
            ),
          ),
        )
      },
      onValueChanged: (value) {
        setState(() {
          type = value!;
          if (value == 2) {
            setState(() {
              for (int i = 0; i < 5; i++) people[i] = true;
            });
          } else {
            setState(() {
              for (int i = 0; i < 5; i++) people[i] = false;
            });
          }
        });
      },
    );
  }

  CupertinoSlidingSegmentedControl payerSelection() {
    return CupertinoSlidingSegmentedControl(
      groupValue: buyer,
      children: {
        1: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Phong'),
          ),
        ),
        2: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Khánh'),
          ),
        ),
        3: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Tùng'),
          ),
        ),
        4: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Lâm'),
          ),
        ),
        5: SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          child: const Center(
            child: Text('Hiển'),
          ),
        ),
      },
      onValueChanged: (value) {
        setState(() {
          buyer = value!;
        });
      },
    );
  }

  Column selectUsers() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('Phong'),
          value: people[0],
          onChanged: (bool? value) {
            setState(() {
              people[0] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Khánh'),
          value: people[1],
          onChanged: (bool? value) {
            setState(() {
              people[1] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Tùng'),
          value: people[2],
          onChanged: (bool? value) {
            setState(() {
              people[2] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Lâm'),
          value: people[3],
          onChanged: (bool? value) {
            setState(() {
              people[3] = value!;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Hiển'),
          value: people[4],
          onChanged: (bool? value) {
            setState(() {
              people[4] = value!;
            });
          },
        ),
      ],
    );
  }

  Future<void> submit_done() async {
    try{
      final data = Provider.of<Record_Provider>(context, listen: false);
      int money = int.parse(cmoney.text
          .replaceAll(RegExp(r'\.\d+'), '')
          .replaceAll(',', '')
          .toString());

      String _people = "";
      for (int i = 0; i < people.length; i++) {
        if (people[i]) {
          _people = "${_people}1";
        } else {
          _people = '${_people}0';
        }
      }

      //SEND HTTP REQUEST & ADD RECORD LOCALLY
      final date = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      data.addRecord(cname.text, money, date, buyer, type, _people);

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