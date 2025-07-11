import { Vehicle } from '../../entities/Vehicle';
import { InsuranceType, InsuranceSimulation, SimulationResult } from '../../entities/Insurance';
import { InsuranceRepository } from '../../repositories/InsuranceRepository';

export class InsuranceUseCase {
  constructor(private insuranceRepository: InsuranceRepository) {}

  async getInsuranceTypes(): Promise<InsuranceType[]> {
    return await this.insuranceRepository.getInsuranceTypes();
  }

  calculatePremium(vehicle: Vehicle): SimulationResult {
    this.validateVehicle(vehicle);
    
    const baseValue = this.getBaseValueByCapitalLevel(vehicle.capitalLevel);
    const brandMultiplier = this.getBrandMultiplier(vehicle.brand);
    const modelMultiplier = this.getModelMultiplier(vehicle.model);
    
    const monthlyPremium = Math.round((baseValue * 0.002 * brandMultiplier * modelMultiplier) / 12);
    
    return {
      premium: monthlyPremium,
      formattedPremium: monthlyPremium.toLocaleString('pt-AO'),
      vehicle,
    };
  }

  async saveSimulation(vehicle: Vehicle, premium: number): Promise<void> {
    const simulation: InsuranceSimulation = {
      vehicle,
      monthlyPremium: premium,
      calculatedAt: new Date(),
    };
    
    await this.insuranceRepository.saveSimulation(simulation);
  }

  async sendSimulationByEmail(vehicle: Vehicle, premium: number, email: string): Promise<void> {
    this.validateEmail(email);
    
    const simulation: InsuranceSimulation = {
      vehicle,
      monthlyPremium: premium,
      calculatedAt: new Date(),
    };
    
    await this.insuranceRepository.sendSimulationByEmail(simulation, email);
  }

  private validateVehicle(vehicle: Vehicle): void {
    const requiredFields = ['brand', 'model', 'registrationDate', 'plateNumber', 'capitalLevel', 'startDate'];
    
    for (const field of requiredFields) {
      if (!vehicle[field as keyof Vehicle]) {
        throw new Error(`Campo obrigatório não preenchido: ${field}`);
      }
    }
  }

  private validateEmail(email: string): void {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      throw new Error('Endereço de e-mail inválido');
    }
  }

  private getBaseValueByCapitalLevel(capitalLevel: string): number {
    const values = {
      'A': 13376000,
      'B': 26752000,
      'C': 40128000,
    };
    return values[capitalLevel as keyof typeof values] || 0;
  }

  private getBrandMultiplier(brand: string): number {
    return brand === 'Toyota' ? 1.2 : 1.0;
  }

  private getModelMultiplier(model: string): number {
    return ['RAV4', 'Tucson'].includes(model) ? 1.3 : 1.0;
  }
}