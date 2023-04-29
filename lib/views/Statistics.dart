import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../data.dart';
import '../popupViews/currentRecord.dart';
import 'DashBoard.dart';

class StatisticView extends StatefulWidget {
  const StatisticView({Key? key}) : super(key: key);

  @override
  State<StatisticView> createState() => _StatisticViewState();
}

class _StatisticViewState extends State<StatisticView> {
  var currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');


  @override
  Widget build(BuildContext context) {
    final recordData = Provider.of<Record_Provider>(context);
    final records = recordData.records;

    final stateData = Provider.of<Loading_State_Provider>(context);
    bool isLoading = stateData.getLoadingState;


    switch (isLoading) {
      case true:
        return const Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
            onRefresh: () {
              stateData.changeState();
              print('START REFRESH:\nisLoading: ${stateData.getLoadingState}');
              return refreshRecords(context, stateData);
            },
            child: records.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: records.length,
                        itemBuilder: (context, id) {
                          return Dismissible(
                            key: UniqueKey(),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child:
                              const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) {
                              return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text("Delete record"),
                                    content: const Text(
                                        "Are you sure you want to delete this record"),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                false); //return false so that confirmDismiss don't delete the record
                                          },
                                          child: const Text("Cancel")),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(
                                                true); //return true so that confirmDismiss delete the record
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                                color: Colors.red),
                                          ))
                                    ],
                                  ));
                            },
                            onDismissed: (_) {
                              // stateData.changeState();
                              // print('Start dismiss: ${stateData.getLoadingState}');
                              dismissRecord(recordData, stateData, records.length - id - 1);
                            },
                            child: ListTile(
                              onLongPress: () {
                                detail_edit(records, records.length - id - 1);
                              },
                              leading: buildLeading(records[records.length - id - 1].source),
                              subtitle:
                                  Text('${records[records.length - id - 1].date.day}/${records[records.length - id - 1].date.month}/${records[records.length - id - 1].date.year}'),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    records[records.length - id - 1].name,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5.0),
                                  Text(
                                      "-${currencyFormat.format(records[records.length - id - 1].money)}",
                                      style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.purple)),
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
                            ),
                          );
                        }),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'No expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ));
    }
  }

  void detail_edit(List<Record> records, int i) => showModalBottomSheet(
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
        int type = records[i].type;
        int source = records[i].source;
        String note = records[i].note;
        DateTime date = records[i].date;
        return currentRecordView(i, type, source, note, date);
      });

  Future<void> getAndSetRecords() async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records.json');
    try {
      final res = await http.get(uri);
      print(res);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> dismissRecord(Record_Provider recordData, Loading_State_Provider stateData, int id) async {
      recordData
          .removeRecord(id)
          .then((_) {
        stateData.changeState();
        print('isLoading: ${stateData.getLoadingState} - delete successfully');
      }).catchError((err) {
        stateData.changeState();
        print('isLoading: ${stateData.getLoadingState} - delete failed');
      });
      stateData.changeState();
  }
}

Future<void> refreshRecords(BuildContext context, Loading_State_Provider stateData) async {
  await Provider.of<Record_Provider>(context, listen: false)
      .fetchRecord(true)
      .then((_) {

    stateData.changeState();

    print('Loading state: ${stateData.getLoadingState}');
  }).catchError((err) {
    print('Refresh error: $err');
  });
}