import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'package:nossa_seguro_app/data/models/insurance_model.dart';
import 'package:nossa_seguro_app/services/insurance_service.dart';
import 'package:action_slider/action_slider.dart';
import 'package:nossa_seguro_app/shared/custom/modern_widgets.dart';
import '../../../shared/custom/custom_widgets.dart';

class SubscriptionScreen extends StatefulWidget {
  final InsuranceSimulation simulation;

  const SubscriptionScreen({
    super.key,
    required this.simulation,
  });

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers
  final _nameController = TextEditingController();
  final _nifController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  // Form values
  String _paymentMethod = 'Transferência';
  bool _acceptTerms = false;

  // Form validation
  final Map<String, String?> _errors = {};
  bool _isFormValid = false;
  bool _isLoading = false;
  bool _showSuccessScreen = false;

  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Current step for progress indicator
  int _currentStep = 0;
  final int _totalSteps = 3;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();

    // Add listeners to validate form
    _nameController.addListener(_validateForm);
    _nifController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nifController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Clear all errors first
      _errors.clear();

      // Validate name
      if (_nameController.text.trim().isEmpty) {
        _errors['name'] = 'Nome é obrigatório';
      }

      // Validate NIF
      if (_nifController.text.trim().isEmpty) {
        _errors['nif'] = 'NIF é obrigatório';
      } else if (_nifController.text.trim().length < 9) {
        _errors['nif'] = 'NIF deve ter pelo menos 9 dígitos';
      }

      // Validate phone
      if (_phoneController.text.trim().isEmpty) {
        _errors['phone'] = 'Número de telefone é obrigatório';
      } else if (_phoneController.text.trim().length < 9) {
        _errors['phone'] = 'Número de telefone inválido';
      }

      // Validate email
      if (_emailController.text.trim().isEmpty) {
        _errors['email'] = 'E-mail é obrigatório';
      } else if (!EmailValidator.validate(_emailController.text.trim())) {
        _errors['email'] = 'Formato de e-mail inválido';
      }

      // Validate terms acceptance
      if (!_acceptTerms) {
        _errors['terms'] = 'Deve aceitar os Termos e Condições';
      }

      // Check if form is valid
      _isFormValid = _errors.isEmpty &&
          _nameController.text.trim().isNotEmpty &&
          _nifController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _emailController.text.trim().isNotEmpty &&
          _acceptTerms;

      // Update progress
      _updateProgress();
    });
  }

  void _updateProgress() {
    int completedFields = 0;
    int totalFields = 5;

    if (_nameController.text.trim().isNotEmpty) completedFields++;
    if (_nifController.text.trim().isNotEmpty) completedFields++;
    if (_phoneController.text.trim().isNotEmpty) completedFields++;
    if (_emailController.text.trim().isNotEmpty) completedFields++;
    if (_acceptTerms) completedFields++;

    _currentStep = (completedFields / totalFields * _totalSteps).round();
  }

  Future<void> _submitSubscription() async {
    _validateForm();
    if (!_isFormValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Por favor, preencha todos os campos obrigatórios.',
                ),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.all(12),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuccessScreen = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao processar subscrição: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso da Subscrição',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              Text(
                '${(_currentStep / _totalSteps * 100).round()}%',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Subscrição Concluída!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.green.withOpacity(0.3),
              ),
            ),
            child: Text(
              'A sua subscrição foi concluída com sucesso. Receberá a apólice por e-mail nas próximas horas.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Voltar à Página Inicial',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paymentMethods = ['Transferência', 'Referência Multicaixa', 'BAI Paga'];

    // Format premium for display
    final premiumFormatted = NumberFormat.currency(
      locale: 'pt_AO',
      symbol: '',
      decimalDigits: 2,
    ).format(widget.simulation.premium);

    if (_showSuccessScreen) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: _buildSuccessScreen(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
      child: FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
        // Custom App Bar
        Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
            children: [
        IconButton(
        icon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.arrow_back_ios_new,
          color: theme.colorScheme.primary,
          size: 18,
        ),
      ),
      onPressed: () => Navigator.of(context).pop(),
    ),
    const SizedBox(width: 8),
    Expanded(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Subscrição de Seguro',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      Text(
        'Automóvel',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
    ),
    ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '3 min',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
        ),
      ),

        // Progress Indicator
        _buildProgressIndicator(),

        // Form Content
        Expanded(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Premium Summary Section
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
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
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 48,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'O seu prémio está estimado em $premiumFormatted AKZ/mês.',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adira já, em 3 minutos, e evite constrangimentos.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onPrimary.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Personal Information Section
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    'Dados Pessoais',
                    'Informações do tomador do seguro',
                    Icons.person_rounded,
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ModernTextField(
                        label: 'Nome completo',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        errorText: _errors['name'],
                        placeholder: 'Ex: João Silva Santos',
                        icon: Icons.person_rounded,
                        textCapitalization: TextCapitalization.words,
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: ModernTextField(
                              label: 'NIF',
                              controller: _nifController,
                              keyboardType: TextInputType.number,
                              errorText: _errors['nif'],
                              placeholder: 'Ex: 123456789',
                              icon: Icons.badge_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernTextField(
                              label: 'Telefone',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              errorText: _errors['phone'],
                              placeholder: 'Ex: 923456789',
                              icon: Icons.phone_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ModernTextField(
                        label: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        errorText: _errors['email'],
                        placeholder: 'Ex: joao@email.com',
                        icon: Icons.email_rounded,
                      ),

                      const SizedBox(height: 20),
                    ]),
                  ),
                ),

                // Payment Information Section
                SliverToBoxAdapter(
                  child: _buildSectionHeader(
                    'Método de Pagamento',
                    'Escolha como pretende pagar',
                    Icons.payment_rounded,
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ModernDropdown<String>(
                        label: 'Método de pagamento',
                        value: _paymentMethod,
                        items: paymentMethods.map((method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (method) {
                          setState(() {
                            _paymentMethod = method!;
                          });
                        },
                        icon: Icons.payment_rounded,
                      ),

                      const SizedBox(height: 20),

                      // Terms and Conditions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _errors['terms'] != null
                                ? theme.colorScheme.error
                                : theme.colorScheme.outline.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.gavel_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Termos e Condições',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                      _validateForm();
                                    });
                                  },
                                  activeColor: theme.colorScheme.primary,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: RichText(
                                      text: TextSpan(
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text: 'Aceito os ',
                                          ),
                                          TextSpan(
                                            text: 'Termos e Condições',
                                            style: TextStyle(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' e a ',
                                          ),
                                          TextSpan(
                                            text: 'Política de Privacidade',
                                            style: TextStyle(
                                              color: theme.colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' da Nossa Seguro.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_errors['terms'] != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _errors['terms']!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom Action Area
        Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                // Form Summary
                if (_isFormValid) ...[
        Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Dados completos! Pronto para subscrever.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
          const SizedBox(height: 12),
          ],

      // Submit Button
      _isLoading
      ? Container(
      height: 48,
      decoration: BoxDecoration(
      color: theme.colorScheme.primary.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    SizedBox(
    width: 18,
    height: 18,
    child: CircularProgressIndicator(
    strokeWidth: 2,
    valueColor: AlwaysStoppedAnimation<Color>(
    theme.colorScheme.primary,
    ),
    ),
    ),
    const SizedBox(width: 8),
    Text(
    'Processando pagamento...',
    style: theme.textTheme.labelMedium?.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w600,
    ),
    ),
    ],
    ),
    ),
    )
        : ActionSlider.standard(
    sliderBehavior: SliderBehavior.stretch,
    rolling: true,
    toggleColor: _isFormValid
    ? theme.colorScheme.primary
        : theme.colorScheme.outline,
    icon: _isFormValid
    ? const Icon(
    Icons.credit_card_rounded,
    color: Colors.white,
    size: 20,
    )
        : const Icon(
    Icons.lock_rounded,
    color: Colors.white,
    size: 20,
    ),
    child: Text(
    _isFormValid
    ? 'Deslize para Confirmar Subscrição'
        : 'Complete os dados obrigatórios',
    style: theme.textTheme.labelMedium?.copyWith(
    fontWeight: FontWeight.w600,
    color: _isFormValid
    ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withOpacity(0.5),
    ),
    ),
    action: (controller) async {
    if (!_isFormValid) {
    controller.reset();
    return;
    }
    controller.loading();
    await _submitSubscription();
    controller.success();
    await Future.delayed(
      const Duration(seconds: 1),
    );
    },
        backgroundColor: _isFormValid
            ? Colors.white
            : theme.colorScheme.surface,
        height: 48,
      ),
                ],
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