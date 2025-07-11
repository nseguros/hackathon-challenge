import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/componets/menu/menu_entity.dart';
import '../../../../utils/app_consts_utils.dart';

class MenuItemComponent extends StatelessWidget {
  final MenuEntity menu;
  final void Function()? onTap;
  final bool isSelected;
  const MenuItemComponent({super.key, required this.menu, this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isSelected ? 2 : 1,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: isSelected ? AppConstsUtils.secondaryColor : Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  menu.icon,
                  color: isSelected ? Colors.white : AppConstsUtils.primaryColor,
                ),
                SizedBox(width: isSelected ? 5 : 0),
                isSelected
                  ? Center(
                      child: Text(
                        menu.title,
                        style: TextStyle(
                        color: isSelected
                          ? Colors.white
                          : AppConstsUtils.primaryColor),
                        ),
                      )
                  : const SizedBox()
              ]
            ),
          ),
        ),
      ),
    );
  }
}
