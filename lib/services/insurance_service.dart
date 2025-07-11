
import 'package:nossa_seguro_app/data/models/insurance_model.dart';

class InsuranceService {
  // Define available car brands and models with factors
  static List<CarBrand> getCarBrands() {
    return [
      CarBrand(
        name: 'Toyota',
        brandFactor: 1.0,
        models: [
          CarModel(
            name: 'Corolla', 
            engineSize: '1300 CC',
            cylinderCapacity: 1300,
            baseFactor: 1.0,
          ),
          CarModel(
            name: 'RAV4', 
            engineSize: '2000 CC',
            cylinderCapacity: 2000,
            baseFactor: 1.2,
          ),
        ],
      ),
      CarBrand(
        name: 'Hyundai',
        brandFactor: 1.0,
        models: [
          CarModel(
            name: 'Elantra', 
            engineSize: '1600 CC',
            cylinderCapacity: 1600,
            baseFactor: 1.1,
          ),
          CarModel(
            name: 'Tucson', 
            engineSize: '2200 CC',
            cylinderCapacity: 2200,
            baseFactor: 1.3,
          ),
        ],
      ),
    ];
  }

  // Get available capital tiers with factors
  static List<CapitalTier> getCapitalTiers() {
    return [
      CapitalTier(
        tier: 'A',
        amount: 13376000.00,
        displayText: 'A- 13.376.000,00 AKZ',
        factor: 1.0,
      ),
      CapitalTier(
        tier: 'B',
        amount: 26752000.00,
        displayText: 'B- 26.752.000,00 AKZ',
        factor: 1.1,
      ),
      CapitalTier(
        tier: 'C',
        amount: 40128000.00,
        displayText: 'C- 40.128.000,00 AKZ',
        factor: 1.2,
      ),
    ];
  }

  // Get payment frequency options with factors
  static List<String> getPaymentFrequencies() {
    return ['Mensal', 'Trimestral', 'Semestral', 'Anual'];
  }

  // Get payment frequency factor
  static double getPaymentFrequencyFactor(String frequency) {
    switch (frequency) {
      case 'Mensal':
        return 1.0;
      case 'Trimestral':
        return 0.95;
      case 'Semestral':
        return 0.9;
      case 'Anual':
        return 0.85;
      default:
        return 1.0;
    }
  }

  // Premium calculation matrix based on provided specification
  static List<PremiumMatrix> getPremiumMatrix() {
    return [
      PremiumMatrix(
        brand: 'Toyota',
        model: 'Corolla',
        cylinderCapacity: 1300,
        capitalAmount: 13376000.00,
        paymentFrequency: 'Mensal',
        baseFactor: 1.0,
        capitalFactor: 1.0,
        paymentFactor: 1.0,
        estimatedPremium: 10000.00,
      ),
      PremiumMatrix(
        brand: 'Toyota',
        model: 'RAV4',
        cylinderCapacity: 2000,
        capitalAmount: 26752000.00,
        paymentFrequency: 'Mensal',
        baseFactor: 1.2,
        capitalFactor: 1.1,
        paymentFactor: 1.0,
        estimatedPremium: 13200.00,
      ),
      PremiumMatrix(
        brand: 'Hyundai',
        model: 'Elantra',
        cylinderCapacity: 1600,
        capitalAmount: 26752000.00,
        paymentFrequency: 'Mensal',
        baseFactor: 1.1,
        capitalFactor: 1.1,
        paymentFactor: 1.0,
        estimatedPremium: 12100.00,
      ),
      PremiumMatrix(
        brand: 'Hyundai',
        model: 'Tucson',
        cylinderCapacity: 2200,
        capitalAmount: 40128000.00,
        paymentFrequency: 'Mensal',
        baseFactor: 1.3,
        capitalFactor: 1.2,
        paymentFactor: 1.0,
        estimatedPremium: 15600.00,
      ),
    ];
  }

  // Calculate premium based on the simulation data using the provided matrix
  // Formula: Prémio Estimado = Valor Base × Factor Base × Factor Escalão × Factor Fraccionamento
  static double calculatePremium(InsuranceSimulation simulation) {
    // Base value as specified in the requirements
    const double baseValue = 10000.0;
    
    // Get the car model to find base factor
    double baseFactor = 1.0;
    final brands = getCarBrands();
    for (final brand in brands) {
      if (brand.name == simulation.brand) {
        for (final model in brand.models) {
          if (model.name == simulation.model) {
            baseFactor = model.baseFactor;
            break;
          }
        }
        break;
      }
    }
    
    // Get capital tier factor
    double capitalFactor = simulation.capitalTier.factor;
    
    // Get payment frequency factor
    double paymentFactor = getPaymentFrequencyFactor(simulation.paymentFrequency);
    
    // Calculate premium using the formula
    double premium = baseValue * baseFactor * capitalFactor * paymentFactor;
    
    // Round to 2 decimal places
    return double.parse(premium.toStringAsFixed(2));
  }

  // Get detailed calculation breakdown for display
  static Map<String, dynamic> getPremiumCalculationBreakdown(InsuranceSimulation simulation) {
    const double baseValue = 10000.0;
    
    // Get the car model to find base factor
    double baseFactor = 1.0;
    final brands = getCarBrands();
    for (final brand in brands) {
      if (brand.name == simulation.brand) {
        for (final model in brand.models) {
          if (model.name == simulation.model) {
            baseFactor = model.baseFactor;
            break;
          }
        }
        break;
      }
    }
    
    double capitalFactor = simulation.capitalTier.factor;
    double paymentFactor = getPaymentFrequencyFactor(simulation.paymentFrequency);
    double premium = baseValue * baseFactor * capitalFactor * paymentFactor;
    
    return {
      'baseValue': baseValue,
      'baseFactor': baseFactor,
      'capitalFactor': capitalFactor,
      'paymentFactor': paymentFactor,
      'calculatedPremium': double.parse(premium.toStringAsFixed(2)),
      'formula': 'Prémio = $baseValue × $baseFactor × $capitalFactor × $paymentFactor = ${premium.toStringAsFixed(2)} AKZ',
    };
  }

  // Mock email sending function
  static Future<bool> sendSimulationEmail(String email, InsuranceSimulation simulation) async {
    // In a real app, this would connect to an email service
    // For this mock, we'll just simulate a delay and return success
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}