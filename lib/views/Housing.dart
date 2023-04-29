import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:phongs_app/providers/CategoriesProvider.dart';
import 'package:phongs_app/providers/HousingProvider.dart';
import 'package:provider/provider.dart';

enum EditOption { house, electric, water, parking }

class HousingView extends StatefulWidget {
  const HousingView({Key? key}) : super(key: key);

  @override
  State<HousingView> createState() => _HousingViewState();
}

class _HousingViewState extends State<HousingView> {
  final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  final TextEditingController _tmpController = TextEditingController();

  int displayMonth = DateTime.now().month;
  int displayYear = DateTime.now().year;

  int tmpValue = 0;

  late EditOption editOption;

  static const _locale = 'en';

  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));

  @override
  void dispose() {
    _tmpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final housingData = Provider.of<Housing_Provider>(context);
    final dashboardData = Provider.of<Category_Provider>(context);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              editOption = EditOption.house;
              edit(housingData);
            },
            child: ListTile(
              leading: const Icon(Icons.house_outlined),
              title: Text("House rental",
                  style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Tap to change"),
              trailing: Text(
                currencyFormatter.format(housingData.house),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              editOption = EditOption.electric;
              edit(housingData);
            },
            child: ListTile(
              leading: const Icon(Icons.electric_bolt),
              title: Text("Electricity bill",
                  style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Tap to change"),
              trailing: Text(
                currencyFormatter.format(housingData.electric),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              editOption = EditOption.water;
              edit(housingData);
            },
            child: ListTile(
              leading: const Icon(Icons.water_drop_outlined),
              title:
                  Text("Water bill", style: GoogleFonts.firaSans(fontSize: 20)),
              subtitle: const Text("Tap to change"),
              trailing: Text(
                currencyFormatter.format(housingData.water),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ListTile(
            onTap: () {
              editOption = EditOption.parking;
              edit(housingData);
            },
            leading: const Icon(Icons.pedal_bike_outlined),
            title:
                Text("Parking fee", style: GoogleFonts.firaSans(fontSize: 20)),
            subtitle: const Text("Tap to change"),
            trailing: Text(
              currencyFormatter.format(housingData.motorbike),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          GestureDetector(
            onTap: () {
              showTotal(dashboardData, housingData);
            },
            child: ListTile(
              leading: const Icon(Icons.done_all),
              title: Text("Total this month",
                  style: GoogleFonts.firaSans(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: const Text("Tap for detail"),
              trailing: Text(
                currencyFormatter.format(housingData.getTotal()),
                style: const TextStyle(fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  void edit(Housing_Provider hData) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: getEditTitle(editOption),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: getEditLabelText(editOption),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    controller: _tmpController,
                    keyboardType: TextInputType.number,
                    onChanged: (string) {
                      string = _formatNumber(string.replaceAll(',', ''));
                      if (string.isNotEmpty) {
                        _tmpController.value = TextEditingValue(
                          text: string,
                          selection:
                              TextSelection.collapsed(offset: string.length),
                        );
                        print(
                            "TEXT:${_tmpController.text.replaceAll(RegExp(r'\.\d+'), '').replaceAll(',', '')}");
                        tmpValue = int.parse(_tmpController.text
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
                  _tmpController.clear();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  updateHousing(editOption, hData);
                  hData.saveHousing();
                  _tmpController.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

  void showTotal(Category_Provider dashboardProvider, Housing_Provider hData) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Total expenses of this month'),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: const Icon(Icons.food_bank_outlined),
                      title: const Text("Food & drinks"),
                      trailing: Text(currencyFormatter
                          .format(dashboardProvider.fAndD)
                          .toString())),
                  ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Household appliance"),
                      trailing: Text(currencyFormatter
                          .format(dashboardProvider.household)
                          .toString())),
                  ListTile(
                      leading: const Icon(Icons.house_outlined),
                      title: const Text("Housing"),
                      trailing: Text(currencyFormatter
                          .format(hData.getTotal())
                          .toString())),
                  const Divider(),
                  ListTile(
                      leading: const Icon(Icons.summarize_outlined),
                      title: const Text("Total"),
                      trailing: Text(currencyFormatter
                          .format(dashboardProvider.fAndD +
                              dashboardProvider.household +
                              hData.getTotal())
                          .toString())),
                ],
              ),
            ),
          );
        },
      );

  void updateHousing(EditOption editOption, Housing_Provider hData) {
    switch (editOption) {
      case EditOption.house:
        hData.changeHouse(tmpValue);
        break;
      case EditOption.electric:
        hData.changeElectric(tmpValue);
        break;
      case EditOption.water:
        hData.changeWater(tmpValue);
        break;
      case EditOption.parking:
        hData.changeMotorFee(tmpValue);
        break;
    }
  }

  Text getEditTitle(EditOption editOption) {
    switch (editOption) {
      case EditOption.house:
        return const Text('House rental');
      case EditOption.electric:
        return const Text('Electric bill');
      case EditOption.water:
        return const Text('Water bill');
      case EditOption.parking:
        return const Text('Parking fee');
    }
  }

  String getEditLabelText(EditOption editOption) {
    switch (editOption) {
      case EditOption.house:
        return 'Enter house\'s rental value (VND)';
      case EditOption.electric:
        return 'Enter bill\'s value (VND)';
      case EditOption.water:
        return 'Enter bill\'s value (VND)';
      case EditOption.parking:
        return 'Enter fee (VND)';
    }
  }
}
