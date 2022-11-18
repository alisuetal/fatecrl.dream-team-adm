import 'package:dream_team_adm/controllers/match.dart';
import 'package:dream_team_adm/controllers/player.dart';
import 'package:dream_team_adm/controllers/admin.dart';
import 'package:dream_team_adm/screens/tabs_screen.dart';
import 'package:dream_team_adm/screens/update_player_list_screen.dart';
import 'package:dream_team_adm/screens/update_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/log_in_screen.dart';
import 'tools/app_routes.dart';
import 'tools/color_utilities.dart';

void main() {
  runApp(const Providers());
}

class Providers extends StatelessWidget {
  const Providers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DreamTeam();
  }
}

class DreamTeam extends StatelessWidget {
  const DreamTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AdminController(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlayerController(),
        ),
        ChangeNotifierProvider(
          create: (_) => MatchController(),
        ),
      ],
      child: MaterialApp(
        title: "Dream Team Admin",
        theme: ThemeData(
          fontFamily: "Coolvetica",
          primarySwatch: ColorUtilities.createMaterialColor(
            const Color(0xffE56B44),
          ),
          backgroundColor: const Color(0xff222222),
          brightness: Brightness.dark,
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
            headline2: TextStyle(
              fontSize: 32,
              color: Colors.white,
            ),
            headline3: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
            headline4: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
            bodyText1: TextStyle(
              fontSize: 20,
              fontFamily: "Coolvetica",
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              fontFamily: "Coolvetica",
              color: Colors.white,
            ),
          ),
        ),
        home: LogInScreen(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.logIn,
        routes: {
          AppRoutes.logIn: (context) => LogInScreen(),
          AppRoutes.updatePlayerList: (context) =>
              const UpdatePlayerListScreen(),
          AppRoutes.updatePlayer: (context) => const UpdatePlayerScreen(),
          AppRoutes.tabsScreen: (context) => const TabsScreen(),
        },
      ),
    );
  }
}
