import 'package:dream_team_adm/components/app_bar_widget.dart';
import 'package:dream_team_adm/components/button_widget.dart';
import 'package:dream_team_adm/components/pop_up_widget.dart';
import 'package:dream_team_adm/components/screen_holder_widget.dart';
import 'package:dream_team_adm/components/textfield_with_label_widget.dart';
import 'package:dream_team_adm/controllers/admin.dart';
import 'package:dream_team_adm/controllers/match.dart';
import 'package:dream_team_adm/controllers/player.dart';
import 'package:dream_team_adm/tools/app_routes.dart';
import 'package:dream_team_adm/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _submitSignIn(
      AdminController adminController,
      MatchController matchController,
      PlayerController playerController,
      BuildContext context) async {
    final bool isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return false;
    }

    _formKey.currentState?.save();

    final bool signIn = await adminController.signIn(
        _emailController.text, _passwordController.text);

    if (signIn) {
      final bool getMatch = await matchController.selectMatch();
      if (getMatch) {
        await playerController.loadPlayers(matchController.matchModel.id!);
        return true;
      } else {
        showAlertDialog(context, "Erro", "Não há partidas acontecendo.", false);
      }
    } else {
      showAlertDialog(context, "Erro", "Email ou senha incorretos", false);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final AdminController adminController =
        Provider.of<AdminController>(context, listen: false);

    final MatchController matchController =
        Provider.of<MatchController>(context, listen: false);

    final PlayerController playerController =
        Provider.of<PlayerController>(context, listen: false);

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const AppBarWidget(
                            title: "Login",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: TextfieldWithLabelWidget(
                              text: null,
                              hint: "E-mail:",
                              controller: _emailController,
                              validator: (email) => Validators.email(email),
                              keyboardtype: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: TextfieldWithLabelWidget(
                              text: null,
                              hint: "Senha:",
                              controller: _passwordController,
                              obscure: true,
                              validator: (password) =>
                                  Validators.password(password),
                              keyboardtype: TextInputType.visiblePassword,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: ButtonWidget(
                              enabled: true,
                              function: () {
                                _submitSignIn(adminController, matchController,
                                        playerController, context)
                                    .then((value) => value
                                        ? Navigator.of(context).popAndPushNamed(
                                            AppRoutes.tabsScreen)
                                        : null);
                              },
                              text: "Enviar",
                              materialIcon: null,
                            ),
                          ),
                        ],
                      ),
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
