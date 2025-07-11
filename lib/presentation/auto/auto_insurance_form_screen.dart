import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nossa_seguro_app/data/models/insurance_model.dart';
import 'package:nossa_seguro_app/services/insurance_service.dart';
import 'package:action_slider/action_slider.dart';
import 'package:nossa_seguro_app/shared/custom/modern_widgets.dart';
import 'auto_insurance_confirmation_screen.dart';
import '../../shared/custom/custom_widgets.dart';

class AutoInsuranceFormScreen extends StatefulWidget {
  const AutoInsuranceFormScreen({super.key});

  @override
  State<AutoInsuranceFormScreen> createState() =>
      _AutoInsuranceFormScreenState();
}

class _AutoInsuranceFormScreenState extends State<AutoInsuranceFormScreen>
    with SingleTickerProviderStateMixin {
  // Form controllers
  final _licensePlateController = TextEditingController();
  final _scrollController = ScrollController();

  // Form values
  String? _selectedBrand;
  String? _selectedModel;
  String _category = 'Ligeiro Particular';
  String? _engineSize;
  DateTime? _registrationDate;
  CapitalTier? _selectedCapitalTier;
  String _paymentFrequency = 'Mensal';
  DateTime? _startDate;

  // Form validation
  final Map<String, String?> _errors = {};
  bool _isFormValid = false;
  bool _isLoading = false;

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();

    // Initialize start date to today
    _startDate = DateTime.now();

    // Add listener to validate form
    _licensePlateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      // Clear all errors first
      _errors.clear();

      // Validate brand
      if (_selectedBrand == null) {
        _errors['brand'] = 'Selecione uma marca';
      }

      // Validate model
      if (_selectedModel == null) {
        _errors['model'] = 'Selecione um modelo';
      }

      // Validate registration date
      if (_registrationDate == null) {
        _errors['registrationDate'] = 'Selecione a data de matrícula';
      }

      // Validate license plate
      if (_licensePlateController.text.isEmpty) {
        _errors['licensePlate'] = 'Introduza a matrícula';
      }

      // Validate capital tier
      if (_selectedCapitalTier == null) {
        _errors['capitalTier'] = 'Selecione um escalão de capital';
      }

      // Validate start date
      if (_startDate == null) {
        _errors['startDate'] = 'Selecione a data de início';
      }

      // Check if form is valid
      _isFormValid =
          _errors.isEmpty &&
          _selectedBrand != null &&
          _selectedModel != null &&
          _registrationDate != null &&
          _licensePlateController.text.isNotEmpty &&
          _selectedCapitalTier != null &&
          _startDate != null;

      // Update progress
      _updateProgress();
    });
  }

  void _updateProgress() {
    int completedFields = 0;
    int totalFields = 6;

    if (_selectedBrand != null) completedFields++;
    if (_selectedModel != null) completedFields++;
    if (_registrationDate != null) completedFields++;
    if (_licensePlateController.text.isNotEmpty) completedFields++;
    if (_selectedCapitalTier != null) completedFields++;
    if (_startDate != null) completedFields++;

    _currentStep = (completedFields / totalFields * _totalSteps).round();
  }

  void _updateBrand(String? brand) {
    setState(() {
      _selectedBrand = brand;
      _selectedModel = null; // Reset model when brand changes
      _engineSize = null; // Reset engine size
      _validateForm();
    });
  }

  void _updateModel(String? model) {
    if (model == null) return;
    // Find the selected model to get engine size
    final brands = InsuranceService.getCarBrands();
    for (final brand in brands) {
      if (brand.name == _selectedBrand) {
        for (final carModel in brand.models) {
          if (carModel.name == model) {
            setState(() {
              _selectedModel = model;
              _engineSize = carModel.engineSize;
              _validateForm();
            });
            break;
          }
        }
        break;
      }
    }
  }

  Future<void> _submitForm() async {
    _validateForm();
    if (!_isFormValid) {
      // Show error message with haptic feedback
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

    // Criar objeto de simulação
    final simulation = InsuranceSimulation(
      brand: _selectedBrand!,
      model: _selectedModel!,
      category: _category,
      engineSize: _engineSize!,
      registrationDate: _registrationDate!,
      licensePlate: _licensePlateController.text,
      capitalTier: _selectedCapitalTier!,
      paymentFrequency: _paymentFrequency,
      startDate: _startDate!,
    );

    // Navegar para tela de confirmação
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) =>
            AutoInsuranceConfirmationScreen(simulation: simulation),
      ),
    );

    if (confirmed != true) {
      setState(() => _isLoading = false);
      return;
    }

    // Calcular prêmio
    final premium = InsuranceService.calculatePremium(simulation);
    final result = simulation.copyWith(premium: premium);

    // Navegar para resultado
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushNamed('/simulation_result', arguments: result);
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
                'Progresso',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
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
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
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
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brands = InsuranceService.getCarBrands();
    final capitalTiers = InsuranceService.getCapitalTiers();
    final paymentFrequencies = InsuranceService.getPaymentFrequencies();

    // Get models for selected brand
    List<CarModel> models = [];
    if (_selectedBrand != null) {
      for (final brand in brands) {
        if (brand.name == _selectedBrand) {
          models = brand.models;
          break;
        }
      }
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
                // Custom App Bar - Reduzido
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
                              'Simulação de Seguro',
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
                              '2 min',
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
                        // Vehicle Information Section
                        SliverToBoxAdapter(
                          child: _buildSectionHeader(
                            'Dados do Veículo',
                            'Informações básicas sobre o seu automóvel',
                            Icons.directions_car_rounded,
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // Brand and Model Row
                              Row(
                                children: [
                                  Expanded(
                                    child: ModernDropdown<String>(
                                      label: 'Marca',
                                      value: _selectedBrand,
                                      items: brands.map((brand) {
                                        return DropdownMenuItem<String>(
                                          value: brand.name,
                                          child: Text(brand.name),
                                        );
                                      }).toList(),
                                      onChanged: _updateBrand,
                                      errorText: _errors['brand'],
                                      icon: Icons.business_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ModernDropdown<String>(
                                      label: 'Modelo',
                                      value: _selectedModel,
                                      items: models.map((model) {
                                        return DropdownMenuItem<String>(
                                          value: model.name,
                                          child: Text(model.name),
                                        );
                                      }).toList(),
                                      onChanged: _updateModel,
                                      errorText: _errors['model'],
                                      isEnabled: _selectedBrand != null,
                                      icon: Icons.car_rental_rounded,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Category and Engine Size Row
                              Row(
                                children: [
                                  Expanded(
                                    child: ModernTextField(
                                      label: 'Categoria',
                                      controller: TextEditingController(
                                        text: _category,
                                      ),
                                      isEnabled: false,
                                      icon: Icons.category_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ModernTextField(
                                      label: 'Cilindrada',
                                      controller: TextEditingController(
                                        text: _engineSize ?? '',
                                      ),
                                      isEnabled: false,
                                      icon: Icons.speed_rounded,
                                      suffix: 'cc',
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Registration Date and License Plate
                              ModernDatePicker(
                                label: 'Data da 1ª matrícula',
                                selectedDate: _registrationDate,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now(),
                                onDateSelected: (date) {
                                  setState(() {
                                    _registrationDate = date;
                                    _validateForm();
                                  });
                                },
                                errorText: _errors['registrationDate'],
                                icon: Icons.event_rounded,
                              ),

                              const SizedBox(height: 12),

                              ModernTextField(
                                label: 'Matrícula',
                                controller: _licensePlateController,
                                keyboardType: TextInputType.text,
                                errorText: _errors['licensePlate'],
                                placeholder: 'Ex: XX-XX-XX',
                                icon: Icons.confirmation_number_rounded,
                                textCapitalization:
                                    TextCapitalization.characters,
                              ),

                              const SizedBox(height: 20),
                            ]),
                          ),
                        ),

                        // Insurance Details Section
                        SliverToBoxAdapter(
                          child: _buildSectionHeader(
                            'Detalhes do Seguro',
                            'Configure as opções da sua apólice',
                            Icons.shield_rounded,
                          ),
                        ),

                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // Capital Tier
                              ModernDropdown<CapitalTier>(
                                label: 'Escalão de capital',
                                value: _selectedCapitalTier,
                                items: capitalTiers.map((tier) {
                                  return DropdownMenuItem<CapitalTier>(
                                    value: tier,
                                    child: Text(tier.displayText),
                                  );
                                }).toList(),
                                onChanged: (tier) {
                                  setState(() {
                                    _selectedCapitalTier = tier;
                                    _validateForm();
                                  });
                                },
                                errorText: _errors['capitalTier'],
                                icon: Icons.account_balance_rounded,
                              ),

                              const SizedBox(height: 12),

                              // Payment Frequency and Start Date Row
                              Row(
                                children: [
                                  Expanded(
                                    child: ModernDropdown<String>(
                                      label: 'Fraccionamento',
                                      value: _paymentFrequency,
                                      items: paymentFrequencies.map((
                                        frequency,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: frequency,
                                          child: Text(frequency),
                                        );
                                      }).toList(),
                                      onChanged: (frequency) {
                                        setState(() {
                                          _paymentFrequency = frequency!;
                                        });
                                      },
                                      icon: Icons.payment_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ModernDatePicker(
                                      label: 'Data de início',
                                      selectedDate: _startDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                      onDateSelected: (date) {
                                        setState(() {
                                          _startDate = date;
                                          _validateForm();
                                        });
                                      },
                                      errorText: _errors['startDate'],
                                      icon: Icons.play_circle_rounded,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Area - Reduzido
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
                      // Form Summary - Compacto
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
                                  'Formulário completo! Pronto para simular.',
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

                      // Submit Button - Altura reduzida
                      _isLoading
                          ? Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.1,
                                ),
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
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Processando...',
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
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
                                      Icons.rocket_launch_rounded,
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
                                    ? 'Deslize para Simular'
                                    : 'Complete o formulário',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: _isFormValid
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurface.withOpacity(
                                          0.5,
                                        ),
                                ),
                              ),
                              action: (controller) async {
                                if (!_isFormValid) {
                                  controller.reset();
                                  return;
                                }
                                controller.loading();
                                await _submitForm();
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
