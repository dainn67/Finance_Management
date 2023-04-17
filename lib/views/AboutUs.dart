import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin ứng dụng"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: const [
              ListTile(
                // leading: Image.asset("assets/images/wallet.png"),
                title: Text(
                    "Ứng dụng quản lí chi tiêu\n\nby Dai. Nguyen Nhu\n\nBản hoàn thiện 1.1.2",
                    style: TextStyle(fontSize: 20.0)),
              ),
              SizedBox(height: 20.0),
              ListTile(
                title: Text("Tất cả các tính năng trong 1 ứng dụng",
                    style: TextStyle(fontSize: 24.0)),
              ),
              ListTile(
                title: Text("Giúp theo dõi các chi tiêu hàng tháng, tránh thất thoát tình bạn :)",
                    style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ));
  }
}
