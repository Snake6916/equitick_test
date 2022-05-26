import 'package:equitick/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({Key? key}) : super(key: key);

  final Controller controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Equitick Test",
          style: GoogleFonts.roboto(),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Name: ${controller.user.value.name}"),
            const SizedBox(
              height: 5.0,
            ),
            Text("Email: ${controller.user.value.email}"),
            const SizedBox(
              height: 5.0,
            ),
            Text("Password: ${controller.user.value.password}"),
            const SizedBox(
              height: 5.0,
            ),
            Text("Country: ${controller.user.value.country.name}"),
            const SizedBox(
              height: 5.0,
            ),
            Text("PhoneCode: ${controller.user.value.country.phoneCode}"),
            const SizedBox(
              height: 5.0,
            ),
            Text("phone number: ${controller.user.value.phoneNumber}"),
          ],
        ),
      ),
    );
  }
}
