import 'dart:convert';
import 'package:dream_team_adm/models/player.dart';
import 'package:dream_team_adm/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PlayerController with ChangeNotifier {
  List<Player> _players = [];

  Future<int> loadPlayers(int match) async {
    _players.clear();
    const url = "${Constants.baseUrl}Player/SelectNotUpdated";
    final response = await http.post(
      Uri.parse(url),
      body: {
        'rodada': match.toString(),
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      for (var p in data) {
        Player player = Player(
          id: int.parse(p['id']),
          name: p['name'],
          position: p['position'],
          point: int.parse(p['point']),
          rebound: int.parse(p['rebound']),
          block: int.parse(p['block']),
          steal: int.parse(p['steal']),
          assist: int.parse(p['assist']),
          missShot: int.parse(p['missShot']),
          turnOver: int.parse(p['turnOver']),
          urlImage: p['imgUrl'],
          price: int.parse(p['price']),
          team: p['team'],
        );
        _players.add(player);
      }
    }
    notifyListeners();
    return sizePlayers();
  }

  Future<bool> updatePlayer(
    String id,
    String points,
    String rebounds,
    String block,
    String steal,
    String assist,
    String missShot,
    String turnOver,
    String admin,
    String match,
  ) async {
    const url = "${Constants.baseUrl}Player/Update";

    final response = await http.post(
      Uri.parse(url),
      body: {
        'cd_jogador': id,
        'qt_ponto': points,
        'qt_rebote': rebounds,
        'qt_toco': block,
        'qt_bola_recuperada': steal,
        'qt_assistencia': assist,
        'qt_arremesso_errado': missShot,
        'qt_turn_over': turnOver,
        'cd_admin': admin,
        'cd_rodada': match,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 204) {
      return true;
    }
    return false;
  }

  int sizePlayers() {
    return _players.length;
  }

  String getImageUrl(int index) {
    return _players.elementAt(index).urlImage;
  }

  int getPrice(int index) {
    return _players.elementAt(index).price;
  }

  String getName(int index) {
    return _players.elementAt(index).name;
  }

  double getPoints(int index) {
    return double.parse(_players.elementAt(index).point.toString());
  }

  String getTeam(int index) {
    return _players.elementAt(index).team;
  }

  double getVariation(int index) {
    final player = _players.elementAt(index);

    final point = player.point;
    final rebound = player.rebound;
    final block = player.block;
    final steal = player.steal;
    final assist = player.assist;

    final positive = point + rebound + block + steal + assist;

    final negative = player.missShot + player.turnOver;

    return (positive - negative) / 100;
  }

  Player getPlayer(int index) {
    return _players.elementAt(index);
  }

  List<Player> getPlayersList() {
    return _players;
  }
}
