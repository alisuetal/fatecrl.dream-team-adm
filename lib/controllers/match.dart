import 'dart:convert';
import 'package:dream_team_adm/models/match.dart';
import 'package:dream_team_adm/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MatchController with ChangeNotifier {
  late MatchModel matchModel;

  setMatch(MatchModel matchModel) {
    this.matchModel = matchModel;
    notifyListeners();
  }

  Future<bool> selectMatch() async {
    const url = "${Constants.baseUrl}Match/SelectMatch";
    final response = await http.post(
      Uri.parse(url),
      body: {},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      for (var u in data) {
        MatchModel matchModel = MatchModel(
          id: u['id'],
          startDate: DateTime.parse(u['startDate']),
          endDate: DateTime.parse(u['endDate']),
        );
        setMatch(matchModel);
      }
      return true;
    }
    return false;
  }

  Future<int> passMatch(int match, int admin) async {
    const url = "${Constants.baseUrl}Match/PassMatch";
    final response = await http.post(
      Uri.parse(url),
      body: {
        'rodada': match.toString(),
        'admin': admin.toString(),
      },
    );
    return response.statusCode;
  }

  String parseDate(DateTime? birthday) {
    if (birthday != null) {
      return "${birthday.year}-${birthday.month < 10 ? "0${birthday.month}" : birthday.month}-${birthday.day < 10 ? "0${birthday.day}" : birthday.day}";
    }
    return "";
  }
}
