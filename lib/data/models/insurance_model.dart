class CarBrand {
  final String name;
  final List<CarModel> models;
  final double brandFactor;

  CarBrand({
    required this.name, 
    required this.models,
    required this.brandFactor,
  });
}

class PremiumMatrix {
  final String brand;
  final String model;
  final int cylinderCapacity;
  final double capitalAmount;
  final String paymentFrequency;
  final double baseFactor;
  final double capitalFactor;
  final double paymentFactor;
  final double estimatedPremium;

  PremiumMatrix({
    required this.brand,
    required this.model,
    required this.cylinderCapacity,
    required this.capitalAmount,
    required this.paymentFrequency,
    required this.baseFactor,
    required this.capitalFactor,
    required this.paymentFactor,
    required this.estimatedPremium,
  });
}

class CarModel {
  final String name;
  final String engineSize;
  final int cylinderCapacity;
  final double baseFactor;

  CarModel({
    required this.name, 
    required this.engineSize,
    required this.cylinderCapacity,
    required this.baseFactor,
  });
}

class CapitalTier {
  final String tier;
  final double amount;
  final String displayText;
  final double factor;

  CapitalTier({
    required this.tier, 
    required this.amount, 
    required this.displayText,
    required this.factor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CapitalTier &&
          runtimeType == other.runtimeType &&
          tier == other.tier &&
          amount == other.amount &&
          displayText == other.displayText &&
          factor == other.factor;

  @override
  int get hashCode => Object.hash(tier, amount, displayText, factor);
}

class InsuranceSimulation {
  final String brand;
  final String model;
  final String category;
  final String engineSize;
  final DateTime registrationDate;
  final String licensePlate;
  final CapitalTier capitalTier;
  final String paymentFrequency;
  final DateTime startDate;
  
  // Calculated premium
  double? premium;

  InsuranceSimulation({
    required this.brand,
    required this.model,
    required this.category,
    required this.engineSize,
    required this.registrationDate,
    required this.licensePlate,
    required this.capitalTier,
    required this.paymentFrequency,
    required this.startDate,
    this.premium,
  });

  // Create a copy with modified fields
  InsuranceSimulation copyWith({
    String? brand,
    String? model,
    String? category,
    String? engineSize,
    DateTime? registrationDate,
    String? licensePlate,
    CapitalTier? capitalTier,
    String? paymentFrequency,
    DateTime? startDate,
    double? premium,
  }) {
    return InsuranceSimulation(
      brand: brand ?? this.brand,
      model: model ?? this.model,
      category: category ?? this.category,
      engineSize: engineSize ?? this.engineSize,
      registrationDate: registrationDate ?? this.registrationDate,
      licensePlate: licensePlate ?? this.licensePlate,
      capitalTier: capitalTier ?? this.capitalTier,
      paymentFrequency: paymentFrequency ?? this.paymentFrequency,
      startDate: startDate ?? this.startDate,
      premium: premium ?? this.premium,
    );
  }

  // Convert to a map for display or storage
  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'category': category,
      'engineSize': engineSize,
      'registrationDate': registrationDate.toIso8601String(),
      'licensePlate': licensePlate,
      'capitalTier': capitalTier.displayText,
      'paymentFrequency': paymentFrequency,
      'startDate': startDate.toIso8601String(),
      'premium': premium,
    };
  }
}