import 'package:equitick/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: ScreenUtilInit(
        designSize: const Size(360, 960),
        builder: (_, __) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Equitick Test',
          theme: ThemeData(
            primarySwatch: Colors.purple,
          ),
          home: const Home(),
        ),
      ),
    );
  }
}
