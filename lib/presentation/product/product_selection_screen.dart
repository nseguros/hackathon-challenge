import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_images.dart';
import 'product_selection_controller.dart';

class ProductSelectionScreen extends StatelessWidget {
  const ProductSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductSelectionController(context),
      child: const _ProductSelectionScreenBody(),
    );
  }
}

class _ProductSelectionScreenBody extends StatefulWidget {
  const _ProductSelectionScreenBody({Key? key}) : super(key: key);

  @override
  State<_ProductSelectionScreenBody> createState() => _ProductSelectionScreenBodyState();
}

class _ProductSelectionScreenBodyState extends State<_ProductSelectionScreenBody> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Consumer<ProductSelectionController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'Logo da NOSSA Seguros',
                        child: Image.asset(
                          AppImages.logo,
                          width: size.width * 0.45 > 200 ? 300 : size.width * 0.75,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        'Simulador de Produtos',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Escolha o tipo de seguro que pretende simular.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final p = controller.products[index];
                          return _buildProductCard(
                            title: p.title,
                            icon: p.icon,
                            isActive: p.isActive,
                            onTap: p.isActive && p.onTap != null ? p.onTap! : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard({
    required String title,
    required IconData icon,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Hero(
      tag: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isActive ? onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary.withOpacity(0.08)
                  : theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.dividerColor,
                width: isActive ? 2 : 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                if (!isActive)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Em breve',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}