class User {
  String? name, email, password, phoneNumber;
  Country country;

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.country,
      required this.phoneNumber});
}

class Country {
  String name;
  int phoneCode;

  Country(this.name, this.phoneCode);

  @override
  operator ==(other) =>
      other is Country && other.name == name && other.phoneCode == phoneCode;

  @override
  int get hashCode => name.hashCode + phoneCode.hashCode;
}
