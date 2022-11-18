import 'package:dream_team_adm/components/app_bar_widget.dart';
import 'package:dream_team_adm/components/leonitas_market_widget.dart';
import 'package:dream_team_adm/components/player_team_card_widget.dart';
import 'package:dream_team_adm/components/round_icon_widget.dart';
import 'package:dream_team_adm/components/screen_holder_widget.dart';
import 'package:dream_team_adm/controllers/admin.dart';
import 'package:dream_team_adm/controllers/match.dart';
import 'package:dream_team_adm/models/match.dart';
import 'package:dream_team_adm/screens/update_player_screen.dart';
import 'package:dream_team_adm/tools/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../components/button_widget.dart';
import '../components/pop_up_widget.dart';
import '../controllers/player.dart';

class UpdatePlayerListScreen extends StatefulWidget {
  const UpdatePlayerListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdatePlayerListScreen> createState() => _UpdatePlayerListScreenState();
}

class _UpdatePlayerListScreenState extends State<UpdatePlayerListScreen> {
  Future<bool> _passMatch(
    MatchController matchController,
    int admin,
    BuildContext context,
  ) async {
    final int pass = await matchController.passMatch(
      matchController.matchModel.id!,
      admin,
    );

    if (pass == 204) {
      showAlertDialog(
        context,
        "Sucesso",
        "Rodada atualizada com sucesso!",
        true,
      );
    }

    if (pass == 400) {
      showAlertDialog(
        context,
        "Erro",
        "A rodada já foi passada.",
        false,
      );
    }

    if (pass == 500) {
      showAlertDialog(
        context,
        "Erro",
        "Algo de errado aconteceu. Tente novamente mais tarde, por favor.",
        false,
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MatchController matchController =
        Provider.of<MatchController>(context, listen: false);

    final PlayerController playerController =
        Provider.of<PlayerController>(context, listen: true);

    final AdminController adminController =
        Provider.of<AdminController>(context, listen: false);

    return ScreenHolderWidget(
      content: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/svg/background.svg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppBarWidget(
                      title: "Atualizar jogadores",
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Rodada de ${matchController.parseDate(matchController.matchModel.startDate)} a ${matchController.parseDate(matchController.matchModel.endDate)}",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xff888888),
                        ),
                      ),
                    ),
                    if (playerController.sizePlayers() > 0)
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: playerController.sizePlayers(),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: PlayerCardWidget(
                              imgSrc: playerController.getImageUrl(index),
                              name: playerController.getName(index),
                              team: playerController.getTeam(index),
                              variation: playerController.getVariation(index),
                              points: playerController.getPoints(index).toInt(),
                              rightWidget: RoundIconWidget(
                                icon: Icons.edit_rounded,
                                function: () {
                                  Navigator.of(context)
                                      .pushNamed(
                                        AppRoutes.updatePlayer,
                                        arguments:
                                            playerController.getPlayer(index),
                                      )
                                      .then(
                                        (value) => setState(
                                          () {
                                            playerController.loadPlayers(
                                              matchController.matchModel.id!,
                                            );
                                          },
                                        ),
                                      );
                                },
                              ),
                              price: playerController.getPrice(index),
                            ),
                          );
                        },
                      ),
                    if (playerController.sizePlayers() == 0)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 64.0),
                          child: Column(
                            children: const [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white70,
                                size: 40,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "Todos os jogadores foram atualizados!",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (playerController.sizePlayers() == 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ButtonWidget(
                          text: "Passar rodada",
                          function: () {
                            _passMatch(
                              matchController,
                              adminController.admin.id!,
                              context,
                            );
                          },
                          enabled: true,
                        ),
                      ),
                    const SizedBox(
                      height: 160,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
