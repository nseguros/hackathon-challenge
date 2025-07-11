import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nossa_seguros/utils/constants/app_colors.dart';

import '../../../utils/utils.dart';
import '../home/home.dart';
import 'controllers/auth_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var controller = Get.put(AuthController());

  var willBeContinued = false.obs;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                    left: 16.0, right: 16.0, bottom: 16.0, top: 50.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bem vindo",
                        style: TextStyle(fontSize: size.height / 26),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Faça gestão dos teus seguros aqui",
                          maxLines: 3,
                          style: TextStyle(fontSize: size.width / 26),
                        ),
                        width: size.width,
                        height: size.height / 6,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller:
                                controller.usernameFieldController.value,
                            decoration: InputDecoration(
                              hintText: "Telefone",
                              contentPadding: EdgeInsets.only(bottom: 10),
                              focusColor: Color(0xff000000),
                              filled: true,
                              prefixIcon: Icon(
                                CupertinoIcons.phone,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              labelStyle: TextStyle(color: Color(0xff000000)),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Preencha o campo";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (controller.usernameFieldController.value.text
                                      .isNotEmpty &&
                                  controller.passwordFieldController.value.text
                                      .isNotEmpty) {
                                willBeContinued.value = true;
                              } else {
                                willBeContinued.value = false;
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return Container(
                          width: size.width,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: TextFormField(
                              controller:
                                  controller.passwordFieldController.value,
                              obscureText: controller.showPassword.value,
                              onChanged: (value) {
                                if (controller.usernameFieldController.value
                                        .text.isNotEmpty &&
                                    controller.passwordFieldController.value
                                        .text.isNotEmpty) {
                                  willBeContinued.value = true;
                                } else {
                                  willBeContinued.value = false;
                                }
                              },
                              decoration: InputDecoration(
                                  hintText: "Palavra passe",
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  focusColor: Color(0xff000000),
                                  filled: true,
                                  prefixIcon: Icon(
                                    CupertinoIcons.padlock,
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      print("Show pass...");

                                      controller.showPassword.value =
                                          !controller.showPassword.value;

                                      print("Show pass...");
                                    },
                                    child: Icon(
                                      controller.showPassword.value
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  labelStyle:
                                      TextStyle(color: Color(0xff000000)),
                                  border: OutlineInputBorder()),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(onTap: () async {
                        debugPrint("Clicked on Login");

                        if (willBeContinued.value) {
                          if (controller.formKey.currentState!.validate()) {
                            controller.setLoading(true);
                            var user = await controller.loginAccount(context);
                            if (user != null) {
                              debugPrint("User logged in: ${user.phoneNumber}");
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (ctx) => Home()),
                                  (route) => false);
                            } else {
                              controller.setLoading(false);
                              Utils.showSnackBar(
                                  "Erro",
                                  "Utilizador não encontrado",
                                  Icon(Icons.info),
                                  Colors.red);
                            }
                          } else {
                            Utils.showSnackBar(
                                "Erro",
                                "Preencha todos os campos",
                                Icon(Icons.info),
                                Colors.red);
                          }
                        }
                      }, child: Obx(() {
                        return Container(
                          width: size.width,
                          height: 55,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: willBeContinued.value
                                  ? SECONDARYCOLOR
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: controller.loading.value
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(PRIMARYCOLOR),
                                    )
                                  : Text(
                                      "Iniciar sessão",
                                      style: TextStyle(color: Colors.black),
                                    )),
                        );
                      })),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ainda não tem uma conta? "),
                          GestureDetector(
                            onTap: () {
                              debugPrint("Clicked on Register...");
                            },
                            child: Text(
                              "Registar-se ",
                              style: TextStyle(color: PRIMARYCOLOR),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
