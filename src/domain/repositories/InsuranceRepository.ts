import { InsuranceType, InsuranceSimulation } from '../entities/Insurance';
import { Vehicle } from '../entities/Vehicle';

export abstract class InsuranceRepository {
  abstract getInsuranceTypes(): Promise<InsuranceType[]>;
  abstract saveSimulation(simulation: InsuranceSimulation): Promise<void>;
  abstract sendSimulationByEmail(simulation: InsuranceSimulation, email: string): Promise<void>;
} 