import 'package:flutter/material.dart';

/// Modelo para produto exibido na seleção
class ProductItem {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  ProductItem({
    required this.title,
    required this.icon,
    required this.isActive,
    this.onTap,
  });
}

/// Controller responsável pela lógica da tela de seleção de produtos
class ProductSelectionController extends ChangeNotifier {
  final BuildContext context;

  ProductSelectionController(this.context);

  List<ProductItem> get products => [
        ProductItem(
          title: 'Seguro Automóvel',
          icon: Icons.directions_car,
          isActive: true,
          onTap: () => _navigateToAutoInsurance(),
        ),
        ProductItem(
          title: 'Seguro de Saúde',
          icon: Icons.health_and_safety,
          isActive: false,
        ),
        ProductItem(
          title: 'Seguro de Vida',
          icon: Icons.favorite,
          isActive: false,
        ),
      ];

  void _navigateToAutoInsurance() {
    Navigator.of(context).pushNamed('/auto_insurance');
  }
} 