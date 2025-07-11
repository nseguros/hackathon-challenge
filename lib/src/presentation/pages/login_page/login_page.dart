import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/components/custom_button_component.dart';
import 'package:nossa_app_hackton/src/presentation/pages/login_page/components/custom_texfield_component.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/navigator_util.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

import '../home_page/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<String> imgs = [
    AppConstsUtils.backgeoundTrabalho,
    AppConstsUtils.backgroundAutomovel,
    AppConstsUtils.backgroundSplash,
    AppConstsUtils.backgroundSaude
  ];
  int _indexCarrousel = 0;
  Timer? _timer;

  bool _isCreateAccount = false;

  final _txtPhone = TextEditingController();
  final _txtPassword = TextEditingController();

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _indexCarrousel = _indexCarrousel == imgs.length - 1 ? 0 : _indexCarrousel + 1;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstsUtils.primaryColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(60),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: context.sizeDevice.height / (_isCreateAccount ? 8 : 2),
                width: context.sizeDevice.width,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _isCreateAccount 
                    ? SizedBox() 
                    : AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: Image.asset(
                        imgs[_indexCarrousel],
                        height: context.sizeDevice.height / 2,
                        width: context.sizeDevice.width,
                        key: ValueKey(imgs[_indexCarrousel]),
                        fit: BoxFit.cover,
                      ),
                    ),
              
                    Container(
                      height: context.sizeDevice.height / 2,
                      width: context.sizeDevice.width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 40,
                        bottom: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppConstsUtils.primaryColor.withValues(alpha: _isCreateAccount ? 1 : .8),
                            AppConstsUtils.primaryColor,
                          ],
                        ),
                      ),
                      child: _isCreateAccount 
                        ? Row(
                          children: [
                            FloatingActionButton.small(
                              backgroundColor: Colors.white,
                              onPressed: () => setState(() => _isCreateAccount = !_isCreateAccount),
                              child: const Icon(
                                CupertinoIcons.arrow_left,
                                color: AppConstsUtils.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10,),

                            Text(
                              "Criar conta",
                              style: TextStyle(
                                fontSize: context.sizeDevice.height / 45,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppConstsUtils.fontBold
                              )
                            ),
                          ],
                        ) 
                        :  Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Hero(
                                tag: AppConstsUtils.logo,
                                child: Image.asset(
                                  AppConstsUtils.logoTextWhite,
                                  width: context.sizeDevice.width / 2,
                                ),
                              ),
                              Text(
                                "Vamos começa!",
                                style: TextStyle(
                                  fontSize: context.sizeDevice.height / 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstsUtils.fontBold
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: context.sizeDevice.height / (_isCreateAccount ? 1 : 2),
            width: context.sizeDevice.width,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 40,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                
                _isCreateAccount ? CustomTexfieldComponent(
                  labelText: "Nome completo", 
                  prefixIcon: CupertinoIcons.person,
                  keyboardType: TextInputType.text, 
                ) : SizedBox(),
                SizedBox(height: _isCreateAccount ? context.sizeDevice.height / 30 : 0,),

                CustomTexfieldComponent(
                  controller: _txtPhone,
                  labelText: "Telefone", 
                  prefixIcon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone, 
                ),
                SizedBox(height: context.sizeDevice.height / ( _isCreateAccount ? 30 : 20),),

                _isCreateAccount ? CustomTexfieldComponent(
                  labelText: "E-mail", 
                  prefixIcon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress, 
                ) : SizedBox(),
                SizedBox(height: _isCreateAccount ? context.sizeDevice.height / 30 : 0,),

                _isCreateAccount ? CustomTexfieldComponent(
                  labelText: "Data de nascimento", 
                  prefixIcon: CupertinoIcons.calendar,
                  keyboardType: TextInputType.datetime, 
                ) : SizedBox(),
                SizedBox(height: _isCreateAccount ? context.sizeDevice.height / 30 : 0,),

                CustomTexfieldComponent(
                  controller: _txtPassword,
                  labelText: "Palavra-passe", 
                  prefixIcon: CupertinoIcons.lock, 
                  isPasswordField: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: _isCreateAccount ? context.sizeDevice.height / 30 : 0,),

                _isCreateAccount ? CustomTexfieldComponent(
                  labelText: "Confirmar Palavra-passe", 
                  prefixIcon: CupertinoIcons.lock,
                  keyboardType: TextInputType.visiblePassword, 
                  isPasswordField: true,
                ) : SizedBox(),
                

                SizedBox(height: context.sizeDevice.height / 60,),
                _isCreateAccount ? const SizedBox() : Row(
                  children: [
                    const Spacer(),
                    Text(
                      "Esqueceu a palavra-passe?",
                      style: TextStyle(
                        color: Colors.grey,
                      )
                    ),
                  ],
                ),

                SizedBox(height: context.sizeDevice.height / 20,),

                CustomButtonComponent(
                  text: _isCreateAccount ? "Criar conta" : "Iniciar sessão",
                  onPressed: _txtPassword.text.trim().isNotEmpty && _txtPhone.text.trim().isNotEmpty ? login : null,
                ),

                SizedBox(height: context.sizeDevice.height / 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                     !_isCreateAccount ? "Ainda não tem conta ?" : "Já tem conta ?",
                      style: TextStyle(
                        color: Colors.grey,
                      )
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isCreateAccount = !_isCreateAccount),
                      child: Text(
                        !_isCreateAccount ? "CRIAR CONTA" : "INICIAR SESSÃO", 
                        style: TextStyle(
                          color: AppConstsUtils.secondaryColor,
                          fontFamily: AppConstsUtils.fontBold
                        )
                      ),
                    )
                  ],
                )



                
              ],
            ),
          )
        ],
      ),
    );
  }


  void _showSnackBar(String message, Color? backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
      ),
    );
  }

  void login() {
    if (_txtPhone.text.trim().isEmpty || _txtPassword.text.trim().isEmpty) {
      _showSnackBar("Por favor, preencha todos os campos.", Colors.red);
      return;
    }
    else if (_txtPhone.text.trim().length < 9) {
      _showSnackBar("Por favor, preencha um número de telefone válido.", Colors.red);
      return;
    }
    else if(_txtPassword.text.trim().length < 6) {
      _showSnackBar("Por favor, preencha uma palavra-passe válida.", Colors.red);
      return;
    }
    else if(_txtPhone.text.trim() == "999999999" && _txtPassword.text.trim() == "123456") {
      NavigatorUtils.gotoWithoutReturn(context, page: const HomePage());
    }
    else {
      _showSnackBar("Número de telefone ou palavra-passe incorretos.", Colors.red);
    }



  }
}
