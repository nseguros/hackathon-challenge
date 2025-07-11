export interface InsuranceType {
  id: string;
  name: string;
}

export interface InsuranceSimulation {
  vehicle: any; // Replace 'any' with Vehicle if you want to import it
  monthlyPremium: number;
  calculatedAt: Date;
}

export interface SimulationResult {
  premium: number;
  formattedPremium: string;
  vehicle: any; // Replace 'any' with Vehicle if you want to import it
} 