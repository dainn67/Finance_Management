import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Record {
  String id;
  String name;
  int money;
  DateTime date;
  int source;
  int type;
  String note;

  Record(this.id, this.name, this.money, this.date, this.source, this.type,
      this.note);
}

class Record_Provider with ChangeNotifier {
  List<Record> _records = [];
  final String? authToken;
  final String? userId;

  Record_Provider(this.authToken, this._records, this.userId);

  List<Record> get records {
    return [..._records]; //return a copy of items only
  }

  int getSize() => _records.length;

  Future<void> addRecord(String recordName, int money, DateTime date, int source, int type, String note, BuildContext context) async {

    final addMonth = date.month;
    final addYear = date.year;

    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records_${addMonth}_$addYear.json?$authToken');
    final res = await http.post(uri,
        body: json.encode({
          'name': recordName,
          'money': money,
          'date': date.toIso8601String(),
          'source': source,
          'type': type,
          'note': note,
          'creatorId': userId
        }));
    var record = Record(
        json.decode(res.body)['name'],
        recordName,
        money,
        date,
        source,
        type,
        note);
    _records.add(record);
    notifyListeners();
  }

  Future<void> removeRecord(int id) async {
    var uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records/${_records[id].id}.json?$authToken');
    final backupRecord = _records[id];
    _records.removeAt(id);
    http.delete(uri).then((_) {
      // fetchRecord().then((_) {
      //   print('Fetch done after deletion');
      // });
      print('Send HTTP delete record $id finished');

      notifyListeners();
    }).catchError((err) {
      print('DELETE ERROR: $err');
      _records.insert(id, backupRecord);
      notifyListeners();
    });
  }

  Future<void> fetchRecord([bool filter = false]) async {
    print('UID: $userId');
    String filterUri = filter ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final uri = Uri.parse(
        'https://phong-s-app-default-rtdb.firebaseio.com/records_${DateTime.now().month}_${DateTime.now().year}.json?$authToken&$filterUri');
    try {
      _records.clear();

      final res = await http.get(uri);
      if (res.body == null) print('BODY IS NULL MF');
      if (res.body != null) {
        final extractedData = json.decode(res.body) as Map<String, dynamic>;
        print('EXTRACTED DATA: $extractedData');
        extractedData.forEach((key, data) {
          _records.add(Record(key, data['name'], data['money'], DateTime.parse(data['date']),
              data['source'], data['type'], data['note']));
        });
        print('FETCH (WITH TOKEN) DONE');
        notifyListeners();
      }
    } catch (err) {
      print('FETCH ERROR: $err\n');
      rethrow;
    }
  }

  Future<void> patchRecord(int index, String cnameText, cmoneyText, int money, DateTime date, int source, int type, String note) async {
    final uri = Uri.parse('https://phong-s-app-default-rtdb.firebaseio.com/records_${date.month}_${date.year}/${records[index].id}.json?$authToken');
    // final uri = Uri.parse('https://phong-s-app-default-rtdb.firebaseio.com/useronly/$userId/${data.records[index].id}.json?$authToken');
    //second url is for add favourite only, so it has /useronly/$userId
    http.patch(uri,
        body: json.encode({
          'name': cnameText.isNotEmpty ? cnameText : records[index].name,
          'money': cmoneyText.isNotEmpty ? money : records[index].money,
          'date': date.toIso8601String(),
          'source': source,
          'type': type,
          'note': note,
        }));
    print('Patch done');
    fetchRecord().then((value) => print('FETCH done after PATCH'));
  }

  void clearRecord() {
    _records.clear();
    notifyListeners();
  }
}
