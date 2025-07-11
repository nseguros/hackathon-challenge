import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/componets/menu/menu_entity.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/tabs/apolices_tab.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/tabs/home_tab.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/tabs/profile_tab.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/tabs/simulations_tab.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

import 'componets/menu/menu_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<MenuEntity> _menu = [
    MenuEntity(icon: CupertinoIcons.home, title: 'Home'),
    MenuEntity(icon: CupertinoIcons.briefcase, title: 'Simulações'),
    MenuEntity(icon: CupertinoIcons.collections, title: 'Apólices'),
    MenuEntity(icon: CupertinoIcons.person, title: 'Perfil'),
  ];
  int indexSelected = 0;

  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: indexSelected);
    pageController.addListener(() {
      setState(() {
        indexSelected = pageController.page!.toInt();
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            const HomeTab(),
            const SimulationsTab(),
            const ApolicesTab(),
            const ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin:  EdgeInsets.only(
          bottom: Platform.isIOS ? 20 : 10,
        ),
        height: 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: context.sizeDevice.width * 0.07,
          children: _menu.map((e) => MenuItemComponent(
            menu: e, 
            isSelected: indexSelected == _menu.indexOf(e),
            onTap: () {
              setState(() => indexSelected = _menu.indexOf(e));
              pageController.jumpToPage(_menu.indexOf(e));
            },
          )).toList(),
        ),
      ),
    );
  }
}