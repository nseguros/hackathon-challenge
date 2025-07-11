import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nossa_seguro_app/data/models/insurance_model.dart';
import 'package:nossa_seguro_app/presentation/subscription/subscription_screen.dart';
import 'package:nossa_seguro_app/services/insurance_service.dart';

import '../../shared/custom/custom_widgets.dart';

class SimulationResultScreen extends StatefulWidget {
  const SimulationResultScreen({super.key});

  @override
  State<SimulationResultScreen> createState() => _SimulationResultScreenState();
}

class _SimulationResultScreenState extends State<SimulationResultScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  String? _emailError;
  bool _isLoading = false;
  bool _showSuccessAnimation = false;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Introduza um email válido';
      } else if (!EmailValidator.validate(email)) {
        _emailError = 'Formato de email inválido';
      } else {
        _emailError = null;
      }
    });
  }

  Future<void> _sendEmail(InsuranceSimulation simulation) async {
    _validateEmail();

    if (_emailError != null) return;

    setState(() => _isLoading = true);

    try {
      // Simulate sending email
      await InsuranceService.sendSimulationEmail(
          _emailController.text,
          simulation
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccessAnimation = true;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Simulação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset animation and success state after delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() => _showSuccessAnimation = false);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _navigateToSubscription(InsuranceSimulation simulation) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SubscriptionScreen(simulation: simulation),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final simulation = ModalRoute.of(context)?.settings.arguments as InsuranceSimulation;

    // Format premium for display
    final premiumFormatted = NumberFormat.currency(
      locale: 'pt_AO',
      symbol: '',
      decimalDigits: 2,
    ).format(simulation.premium);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Resultado da Simulação',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Expanded(
          child: SingleChildScrollView(
          child: Column(
            children: [
            FadeTransition(
            opacity: _fadeInAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.7),
                      theme.colorScheme.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Resultado da Simulação de Seguro Automóvel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'O seu prémio está estimado em $premiumFormatted AKZ/mês. Adira já, em 3 minutos, e evite constrangimentos.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Add subscription button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navigateToSubscription(simulation),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.onPrimary,
                          foregroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shield_rounded,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Aderir',
                              style: theme.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _fadeInAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalhes do Veículo',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Marca', simulation.brand),
                  _buildDetailRow('Modelo', simulation.model),
                  _buildDetailRow('Categoria', simulation.category),
                  _buildDetailRow('Cilindrada', simulation.engineSize),
                  _buildDetailRow('Matrícula', simulation.licensePlate),
                  _buildDetailRow('Escalão de Capital', simulation.capitalTier.displayText),
                  _buildDetailRow('Fraccionamento', simulation.paymentFrequency),
                  _buildDetailRow(
                    'Data de Início',
                    DateFormat('dd/MM/yyyy').format(simulation.startDate),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _fadeInAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.secondary.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Cálculo do Prémio',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCalculationBreakdown(simulation, theme),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          FadeTransition(
            opacity: _fadeInAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Envie a simulação por e-mail',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  errorText: _emailError,
                  onChanged: (_) => _validateEmail(),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 24),
    FadeTransition(
    opacity: _fadeInAnimation,
    child: Row(
    children: [
    Expanded(
    child: OutlinedButton(
    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
    style: OutlinedButton.styleFrom(
    side: BorderSide(color: theme.colorScheme.primary),
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: Text(
    'Sair',
    style: theme.textTheme.labelLarge?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ),
    const SizedBox(width: 16),
    Expanded(
    child: _isLoading
    ? Center(child: CircularProgressIndicator())
        : _showSuccessAnimation
    ? _buildSuccessButton(theme)
        : ElevatedButton(
    onPressed: () => _sendEmail(simulation),
    style: ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    padding: const EdgeInsets.symmetric(vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8),
    ),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(
    Icons.send,
    size: 18,
    color: theme.colorScheme.onPrimary,
    ),
    const SizedBox(width: 8),
      Text(
        'Enviar',
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withOpacity(0.8),
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Voltar ao Início',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCalculationBreakdown(InsuranceSimulation simulation, ThemeData theme) {
    final breakdown = InsuranceService.getPremiumCalculationBreakdown(simulation);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fórmula Utilizada:',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: Text(
            'Prémio = Valor Base × Factor Base × Factor Escalão × Factor Fraccionamento',
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCalculationRow('Valor Base', '${breakdown['baseValue'].toStringAsFixed(2)} AKZ', theme),
        _buildCalculationRow('Factor Base', '${breakdown['baseFactor']}', theme),
        _buildCalculationRow('Factor Escalão', '${breakdown['capitalFactor']}', theme),
        _buildCalculationRow('Factor Fraccionamento', '${breakdown['paymentFactor']}', theme),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prémio Calculado:',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                '${breakdown['calculatedPremium'].toStringAsFixed(2)} AKZ',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalculationRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
