import 'dart:convert';
import 'package:equitick/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  // Error Checking
  RxBool isError = false.obs;

  RxBool isLoading = true.obs;
  void setIsLoading(bool value) => isLoading.value = value;

  // User data
  Rx<User> user = User(
          name: "",
          email: "",
          password: "",
          country: Country("Lebanon", 961),
          phoneNumber: "")
      .obs;

  void updateUser(
      {String? name,
      String? email,
      String? password,
      required Country country,
      String? phoneNumber}) {
    user.update((user) {
      user?.name = name ?? "";
      user?.email = email ?? "";
      user?.password = password ?? "";
      user?.country = country;
      user?.phoneNumber = phoneNumber ?? "";
    });
  }

  // countries list
  RxList<Country> countries = <Country>[].obs;

  Future<void> loadCountries() async {
    try {
      final String response =
          await rootBundle.loadString('assets/jsons/countries.json');
      List list = json.decode(response)['countries'];

      for (var e in list) {
        countries.add(Country(e['name'], e['phone_code']));
      }
    } catch (error) {
      debugPrint("Something Went Wrong with Json!!");
      debugPrint(error.toString());
      countries.value = <Country>[];
      isError.value = true;
    }
  }

  void addCountry(Country c) {
    countries.add(c);
  }

  void sortCountries() {
    countries.sort(((a, b) => a.name.compareTo(b.name)));
  }
}
