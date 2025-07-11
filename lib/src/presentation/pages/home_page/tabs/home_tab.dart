import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/componets/product/product_componet.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/componets/product/product_entity.dart';
import 'package:nossa_app_hackton/src/presentation/pages/simulation_page/simulation_page.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/navigator_util.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  List<ProductEntity> products = [
    ProductEntity(
      image: AppConstsUtils.iconAutomovel,
      title: 'Seguro Automóvel',
    ),
    ProductEntity(
      image: AppConstsUtils.iconSaude,
      title: 'Seguro Saúde',
    ),
    ProductEntity(
      image: AppConstsUtils.iconVida,
      title: 'Seguro Vida',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                AppConstsUtils.logo,
                height: context.sizeDevice.height / 10,
                width: context.sizeDevice.width / 3,
              ),

              CircleAvatar(
                radius: context.sizeDevice.height / 35,
                backgroundColor: AppConstsUtils.secondaryColor,
                child: Center(
                  child: Text(
                    "D",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
              )
            ],
          ),

          const Divider(),
          const SizedBox(height: 15,),

          Text(
            "Simulador de Produtos".toUpperCase(),
            style: TextStyle(
              fontSize: context.sizeDevice.height / 30,
              fontWeight: FontWeight.bold,
              color: AppConstsUtils.primaryColor,
              fontFamily: AppConstsUtils.fontBold,
              height: 1,
            )
          ),
          const SizedBox(height: 30,),


          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: products.map(
                (p) => ProductComponet(
                  product: p,
                  onTap: products.indexOf(p) == 0 ? () => NavigatorUtils.goTo(context, page: SimulationPage()) : null,
                )
              ).toList()
            ),
          )
        ],
      ),
    );
  }
}