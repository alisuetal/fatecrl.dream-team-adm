import 'dart:convert';
import 'package:dream_team_adm/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import '../models/admin.dart';
import 'package:http/http.dart' as http;

class AdminController with ChangeNotifier {
  late Admin admin;

  setAdmin(Admin admin) {
    this.admin = admin;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    const url = "${Constants.baseUrl}Admin/SignIn";
    final response = await http.post(
      Uri.parse(url),
      body: {
        'email': email,
        'password': password,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var u in data) {
        Admin admin = Admin(
          id: u['id'],
          name: u['name'],
          email: u['email'],
          birthday: DateTime.parse(u['birthday']),
          password: u['password'],
        );
        setAdmin(admin);
      }
      return true;
    }
    return false;
  }

  @override
  String toString() {
    final name = admin.name ?? "";
    final email = admin.email ?? "";
    final birthday = parseDate(admin.birthday);
    final password = admin.password ?? "";
    return name + email + birthday + password;
  }

  String parseDate(DateTime? birthday) {
    if (birthday != null) {
      return "${birthday.year}-${birthday.month < 10 ? "0${birthday.month}" : birthday.month}-${birthday.day < 10 ? "0${birthday.day}" : birthday.day}";
    }
    return "";
  }
}
