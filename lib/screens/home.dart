import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';
import 'package:equitick/controller/controller.dart';
import 'package:equitick/models/models.dart';
import 'package:equitick/screens/second.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Controller _controller;

  final double width = 250.w;

  final _formkey = GlobalKey<FormState>();

  late final TextEditingController nameFieldController;
  late final TextEditingController emailFieldController;
  late final TextEditingController passFieldController;
  late final TextEditingController repassFieldController;
  late final TextEditingController phoneFieldController;
  late final TextEditingController codeFieldController;

  final RegExp regex = RegExp(
      r"(?=.*\d)(?=.*[A-Z])(?=.*\W).{7,}$"); // ? No condition requested for small letters

  final InputDecoration textDecoration = const InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
    ),
    labelText: "Enter Name",
  );

  Future<Country?> getCountryByIp() async {
    try {
      var response = await http.get(Uri.parse('https://ip-api.io/json'));

      var data = json.decode(response.body);

      return Country(data['country_name'], int.parse(data['callingCode']));
    } catch (error) {
      debugPrint("Something Went Wrong with ID!!");
      debugPrint(error.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = Get.put(Controller());

    nameFieldController = TextEditingController();
    emailFieldController = TextEditingController();
    passFieldController = TextEditingController();
    repassFieldController = TextEditingController();
    phoneFieldController = TextEditingController();
    codeFieldController = TextEditingController();

    _controller.loadCountries().then((_) => getCountryByIp().then(
          (value) {
            if (value != null) {
              if (!_controller.countries.contains(value)) {
                _controller.addCountry(value);
              }
            }
            _controller.sortCountries();

            _controller.updateUser(country: value ?? _controller.countries[0]);
            codeFieldController.text =
                (value?.phoneCode ?? _controller.countries[0].phoneCode)
                    .toString();

            _controller.setIsLoading(false);
          },
        ));
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    emailFieldController.dispose();
    passFieldController.dispose();
    repassFieldController.dispose();
    phoneFieldController.dispose();
    codeFieldController.dispose();

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Equitick Test",
          style: GoogleFonts.roboto(),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return _controller.isError.value
            ? Center(
                child: AlertDialog(
                  elevation: 5.0,
                  title: const Text("OOPS!"),
                  titleTextStyle: GoogleFonts.kadwa().copyWith(
                    color: Colors.red[800],
                    fontSize: 24.sp,
                  ),
                  content: const Text(
                    "Could'nt retrieve some data, please restart the app.",
                    textAlign: TextAlign.center,
                  ),
                  alignment: Alignment.center,
                ),
              )
            : _controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(
                          parent: NeverScrollableScrollPhysics()),
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 30.h,
                        ),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            validator: (value) => value?.trim().isEmpty ?? true
                                ? "Please enter your name"
                                : null,
                            decoration: textDecoration,
                            controller: nameFieldController,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                              validator: (value) =>
                                  value?.trim().isEmpty ?? true
                                      ? "Please enter an email address"
                                      : !EmailValidator.validate(value!)
                                          ? "Please enter a valid email address"
                                          : null,
                              controller: emailFieldController,
                              decoration: textDecoration.copyWith(
                                labelText: "Enter Email",
                              )),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            validator: (value) {
                              if (value?.trim().isEmpty ?? true) {
                                return "Please enter a password";
                              }
                              if (!regex.hasMatch(value!.trim())) {
                                return "Please enter a valid password";
                              }
                              return null;
                            },
                            controller: passFieldController,
                            decoration: textDecoration.copyWith(
                              labelText: "Enter Password",
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            toolbarOptions: const ToolbarOptions(
                              copy: false,
                              cut: false,
                              paste: false,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: width - 20.w,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 5.h, 0.0, 0.0),
                              child: Text(
                                "> Should be at least 7 characters long\n> Should contain at least one capital letter,\n  one number, and one special character",
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            )),
                        SizedBox(
                          height: 15.h,
                        ),
                        SizedBox(
                          width: width,
                          child: TextFormField(
                            controller: repassFieldController,
                            validator: (value) => value?.trim().isEmpty ?? true
                                ? "Please re-enter your password"
                                : value?.trim() != passFieldController.text
                                    ? "The two passwords do not match"
                                    : null,
                            decoration: textDecoration.copyWith(
                              labelText: "Confirm Password",
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            toolbarOptions: const ToolbarOptions(
                              copy: false,
                              cut: false,
                              paste: false,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Container(
                          width: 150.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 0.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey, width: 1.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Country>(
                              value: _controller.user.value.country,
                              items: _controller.countries
                                  .map((e) => DropdownMenuItem<Country>(
                                      value: e,
                                      child: Text(
                                        e.name,
                                      )))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  _controller.updateUser(country: val);
                                }
                              },
                              isExpanded: true,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              dropdownColor:
                                  Theme.of(context).primaryColorLight,
                              iconEnabledColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.w,
                            ),
                            SizedBox(
                              width: 55.0,
                              child: Padding(
                                padding:
                                    EdgeInsets.fromLTRB(0.0, 12.h, 0.0, 0.0),
                                child: Text(
                                  _controller.user.value.country.phoneCode
                                      .toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7.w,
                            ),
                            SizedBox(
                              width: 160.w,
                              child: TextFormField(
                                controller: phoneFieldController,
                                validator: (value) =>
                                    value?.trim().isEmpty ?? true
                                        ? "Please enter a phone number"
                                        : null,
                                decoration: const InputDecoration(
                                  hintText: "Enter Phone Number",
                                ),
                                keyboardType:
                                    TextInputType.number, // only accept numbers
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState?.validate() ?? false) {
                              _controller.updateUser(
                                  name: nameFieldController.text.trim(),
                                  email: emailFieldController.text.trim(),
                                  password: passFieldController.text.trim(),
                                  country: _controller.user.value.country,
                                  phoneNumber:
                                      phoneFieldController.text.trim());

                              Get.to(
                                () => SecondScreen(),
                                transition: Transition.zoom,
                                curve: Curves.easeInOut,
                                duration: const Duration(milliseconds: 400),
                              );
                            }

                            //primaryFocus?.unfocus();
                          },
                          child: const Text("Sign Up"),
                        ),
                      ]),
                    ),
                  );
      }),
    );
  }
}
