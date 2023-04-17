import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserGuide extends StatelessWidget {
  const UserGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Thông tin ứng dụng"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                    "Nút dấu +",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Thêm chi tiêu (đồ gia dụng/ đồ ăn)",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Nhập giá tiền, người mua, người sử dụng (hoặc người ăn), nhập ngày mua",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 20.0),
                Text(
                    "Trang Chung",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Tổng số tiền Đồ gia dụng/ Đồ ăn",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Một vài chi tiêu mới nhất (5 cái)",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 20.0),
                Text(
                    "Trang Thống kê",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Liệt kê các thông kê từ trước đến giờ",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Bấm vào từng chi tiêu để xem chi tiết",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 20.0),
                Text(
                    "Trang Tiền nhà",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Tiền nhà, điện nước, gửi xe để cuối tháng (cộng dồn cùng các chi tiêu khác)",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Tính riêng theo những người phải đóng tiền nhà, tiền xe",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Xem chi tiết sau khi nhập",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 20.0),
                Text(
                    "Trang Tổng kết",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Tổng kết số tiền phải đóng cho chủ nhà (Âm sẽ được nhận từ chủ nhà)",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Tổng kết được nhiều lần trong (Lưu tổng kết), chi tiêu tính lại từ đó đến cuối tháng",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Tổng kết lần cuối thì ấn (Tính tiền nhà) cho những ai phải đóng tiền nhà, điện nước, gửi xe",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 20.0),
                Text(
                    "LƯU Ý",
                    style: GoogleFonts.firaSans(
                        fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10.0),
                Text(
                    "Chưa có tính năng lọc theo filter",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "\"Tính tiền nhà\" chỉ bấm được 1 lần, nên nhập đầy đủ thông tin trước khi bấm",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),
                const SizedBox(height: 10.0),
                Text(
                    "Các records chưa có tính năng xoá hay chỉnh sửa",
                    style: GoogleFonts.firaSans(
                      fontSize: 20,)),

              ],
            ),
          ),
        ));
  }
}

