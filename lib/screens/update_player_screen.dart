import 'package:dream_team_adm/components/app_bar_widget.dart';
import 'package:dream_team_adm/components/button_widget.dart';
import 'package:dream_team_adm/components/leonitas_market_widget.dart';
import 'package:dream_team_adm/components/player_team_card_widget.dart';
import 'package:dream_team_adm/components/round_icon_widget.dart';
import 'package:dream_team_adm/components/screen_holder_widget.dart';
import 'package:dream_team_adm/controllers/admin.dart';
import 'package:dream_team_adm/controllers/match.dart';
import 'package:dream_team_adm/models/player.dart';
import 'package:dream_team_adm/screens/update_player_screen.dart';
import 'package:dream_team_adm/tools/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../components/pop_up_widget.dart';
import '../components/textfield_with_label_widget.dart';
import '../controllers/player.dart';
import '../utils/validator.dart';

class UpdatePlayerScreen extends StatefulWidget {
  const UpdatePlayerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdatePlayerScreen> createState() => _UpdatePlayerScreenState();
}

class _UpdatePlayerScreenState extends State<UpdatePlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _teamController = TextEditingController();
  final _positionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _reboundController = TextEditingController();
  final _stumpController = TextEditingController();
  final _recoveredController = TextEditingController();
  final _assistController = TextEditingController();
  final _wrongShotController = TextEditingController();
  final _turnOverController = TextEditingController();
  final _imageController = TextEditingController();

  Future<bool> _updatePlayer(
    PlayerController playerController,
    AdminController adminController,
    Player player,
    MatchController matchController,
    BuildContext context,
  ) async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      showAlertDialog(
        context,
        "Erro",
        "Algum(ns) dado(s) pode(m) estar errado(s).",
        false,
      );
      return false;
    }

    _formKey.currentState?.save();

    final bool update = await playerController.updatePlayer(
      player.id.toString(),
      _pointsController.text,
      _reboundController.text,
      _stumpController.text,
      _recoveredController.text,
      _assistController.text,
      _wrongShotController.text,
      _turnOverController.text,
      adminController.admin.id!.toString(),
      matchController.matchModel.id!.toString(),
    );

    if (update) {
      Navigator.of(context).pop();
    } else {
      showAlertDialog(
        context,
        "Erro",
        "Algo deu errado. Revise os dados e tente novamente, por favor.",
        false,
      );
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    PlayerController playerController = Provider.of<PlayerController>(
      context,
      listen: false,
    );
    AdminController adminController = Provider.of<AdminController>(
      context,
      listen: false,
    );
    MatchController matchController = Provider.of<MatchController>(
      context,
      listen: false,
    );
    Player? player = ModalRoute.of(context)!.settings.arguments as Player?;

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppBarWidget(
                        title: "Jogador",
                        leftWidget: RoundIconWidget(
                          icon: Icons.arrow_back_ios_new_rounded,
                          function: () => Navigator.of(context).pop(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Time",
                          style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Nome do jogador",
                          blocked: true,
                          text: player != null ? player.name : "",
                          controller: _nameController,
                          validator: (e) => null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Time",
                          blocked: true,
                          text: player != null ? player.team : "",
                          controller: _teamController,
                          validator: (e) => null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Posição",
                          blocked: true,
                          text: player != null ? player.position : "",
                          controller: _positionController,
                          validator: (e) => null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Imagem",
                          blocked: true,
                          text: player != null ? player.urlImage : "",
                          controller: _imageController,
                          validator: (e) => null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Pontos",
                          text: player != null ? player.point.toString() : "",
                          controller: _pointsController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Rebotes",
                          text: player != null ? player.rebound.toString() : "",
                          controller: _reboundController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Tocos",
                          text: player != null ? player.block.toString() : "",
                          controller: _stumpController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Bola Recuperada",
                          text: player != null ? player.steal.toString() : "",
                          controller: _recoveredController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Assistências",
                          text: player != null ? player.assist.toString() : "",
                          controller: _assistController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Arremesso Errado",
                          text:
                              player != null ? player.missShot.toString() : "",
                          controller: _wrongShotController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: TextfieldWithLabelWidget(
                          hint: "Turnover",
                          text:
                              player != null ? player.turnOver.toString() : "",
                          controller: _turnOverController,
                          validator: (e) => Validators.playerAttributes(e),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: ButtonWidget(
                          text: "Enviar",
                          function: () => _updatePlayer(
                            playerController,
                            adminController,
                            player!,
                            matchController,
                            context,
                          ),
                          enabled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
