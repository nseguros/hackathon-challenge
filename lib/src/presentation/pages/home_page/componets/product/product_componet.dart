import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/componets/product/product_entity.dart';
import 'package:nossa_app_hackton/src/presentation/utils/size_device_util.dart';
import '../../../../utils/app_consts_utils.dart';

class ProductComponet extends StatelessWidget {
  final ProductEntity product;
  final void Function()? onTap;
  const ProductComponet({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: .2), 
                blurRadius: 10
              )
            ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                product.image,
                height: context.sizeDevice.height / 10,
                width: context.sizeDevice.width / 5,
                //fit: BoxFit.cover,
              ),
              Text(
                product.title,
                style: TextStyle(
                  fontSize: context.sizeDevice.height / 65,
                  fontWeight: FontWeight.bold,
                  color: AppConstsUtils.primaryColor,
              )
            ),
          ],
        )
      ),
    );
  }
}
