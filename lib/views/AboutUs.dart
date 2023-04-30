import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("App's information"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: const [
              ListTile(
                // leading: Image.asset("assets/images/wallet.png"),
                title: Text(
                    "YOUR EXPENSE TRACKER\n\nby Dai. Nguyen Nhu\nVersion 2.3.1",
                    style: TextStyle(fontSize: 20.0)),
              ),
              SizedBox(height: 20.0),
              ListTile(
                title: Text("All of your purchases in one small app",
                    style: TextStyle(fontSize: 24.0)),
              ),
              ListTile(
                title: Text("Help tracking what you purchase daily, creating budget targets, and a lot more",
                    style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ));
  }
}
