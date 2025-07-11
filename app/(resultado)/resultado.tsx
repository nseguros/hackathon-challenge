import EmailCard from '@/components/Beneficios/EmailCard/EmailCard';
import { router, useLocalSearchParams } from 'expo-router';
import React from 'react';
import { ScrollView, StyleSheet, TouchableOpacity, View } from 'react-native';
import { Card, Text } from 'react-native-paper';

// Oculta da TabBar
export const options = {
  tabBarStyle: { display: 'none' },
  tabBarButton: () => null,
};

// Matriz de simulação com fatores
const matrizSimulacao = [
  {
    marca: 'Toyota',
    modelo: 'Corolla',
    escalao: 'A - 13.376.000 AKZ',
    fatorBase: 1,
    fatorEscalao: 1,
    fatorFracionamento: 1,
  },
  {
    marca: 'Toyota',
    modelo: 'RAV4',
    escalao: 'B - 26.752.000 AKZ',
    fatorBase: 1.2,
    fatorEscalao: 1.1,
    fatorFracionamento: 1,
  },
  {
    marca: 'Hyundai',
    modelo: 'Elantra',
    escalao: 'B - 26.752.000 AKZ',
    fatorBase: 1.1,
    fatorEscalao: 1.1,
    fatorFracionamento: 1,
  },
  {
    marca: 'Hyundai',
    modelo: 'Tucson',
    escalao: 'C - 40.128.000 AKZ',
    fatorBase: 1.3,
    fatorEscalao: 1.2,
    fatorFracionamento: 1,
  },
];

function calcularPremio(marca: string, modelo: string, escalao: string): number | null {
  const entrada = matrizSimulacao.find(
    (linha) =>
      linha.marca === marca &&
      linha.modelo === modelo &&
      linha.escalao === escalao
  );
  if (!entrada) return null;

  const valorBase = 10000;
  return valorBase * entrada.fatorBase * entrada.fatorEscalao * entrada.fatorFracionamento;
}

export default function Resultado() {
  const params = useLocalSearchParams();

  const matricula = params.matricula as string;
  const modelo = params.modelo as string;
  const marca = params.marca as string;
  const categoria = params.categoria as string;
  const cilindrada = params.cilindrada as string;
  const dataInicio = params.dataInicio as string;
  const dataPrimeiraMatricula = params.dataPrimeiraMatricula as string;
  const escalaoCapital = params.escalaoCapital as string;
  const fracionamento = params.fracionamento as string;

  const premioEstimado = calcularPremio(marca, modelo, escalaoCapital);

  return (
    <ScrollView contentContainerStyle={styles.container}>
      <Text style={styles.title}>Resultado da Simulação automovel</Text>

      {premioEstimado !== null ? (
       <Card style={styles.highlightCard}>
        <Card.Content style={styles.highlightContent}>
          <View style={{ alignItems: 'center' }}>
            <Text style={styles.highlightLabel}>Prêmio Estimado</Text>
            <Text style={styles.highlightValue}>
              {premioEstimado.toLocaleString('pt-AO', {
                style: 'currency',
                currency: 'AOA',
                minimumFractionDigits: 2,
              })}
              /mês
            </Text>
          </View>
        </Card.Content>
      </Card>

      ) : 
      
      <Card style={styles.highlightCard}>
        <Card.Content style={styles.highlightContent}>
          <View style={{ alignItems: 'center' }}>
            <Text style={styles.highlightLabel}>Prêmio Estimado</Text>
            <Text style={styles.highlightValue}>
             10 000, 00 Kz
              /mês
            </Text>
          </View>
        </Card.Content>
      </Card>
      }

<Card style={[styles.card, styles.cardBorderBlue]}>
  <Card.Title title="Dados do Veículo" titleStyle={styles.cardTitle} left={() => <Text style={styles.cardEmoji}>🚗</Text>} />
  <Card.Content>
    <Info label="Matrícula" value={matricula} />
    <Info label="Marca" value={marca} />
    <Info label="Modelo" value={modelo} />
    <Info label="Categoria" value={categoria} />
    <Info label="Cilindrada" value={cilindrada} />
  </Card.Content>
</Card>

<Card style={[styles.card, styles.cardBorderGreen]}>
  <Card.Title title="Cobertura" titleStyle={styles.cardTitle} left={() => <Text style={styles.cardEmoji}>🛡️</Text>} />
  <Card.Content>
    <Info label="Escalão de Capital" value={escalaoCapital} />
    <Info label="Fracionamento" value={fracionamento} />
  </Card.Content>
</Card>

<Card style={[styles.card, styles.cardBorderYellow]}>
  <Card.Title title="Datas" titleStyle={styles.cardTitle} left={() => <Text style={styles.cardEmoji}>📅</Text>} />
  <Card.Content>
    <Info label="1ª Matrícula" value={dataPrimeiraMatricula} />
    <Info label="Início da Cobertura" value={dataInicio} />
  </Card.Content>
</Card>

      <EmailCard/>


      <TouchableOpacity style={styles.button} onPress={() => router.navigate('/(auth)/simulacao')}>
        <Text style={styles.buttonText}>Voltar</Text>
      </TouchableOpacity>
    </ScrollView>
  );
}

function Info({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.infoRow}>
      <Text style={styles.label}>{label}</Text>
      <Text style={styles.value}>{value || '-'}</Text>
    </View>
  );
}


const styles = StyleSheet.create({
  highlightCard: {
  backgroundColor: '#0D2C59',
  paddingVertical: 24,
  marginBottom: 24,
  borderRadius: 16,
  alignItems: 'center',
  elevation: 4,
},
highlightContent: {
  flexDirection: 'row',
  alignItems: 'center',
  justifyContent: 'center',
},
celebrationIcon: {
  fontSize: 32,
  marginRight: 12,
},
highlightLabel: {
  color: '#fff',
  fontSize: 16,
  fontWeight: '600',
  textAlign: 'center',
},
highlightValue: {
  color: '#fff',
  fontSize: 28,
  fontWeight: 'bold',
  marginTop: 4,
  textAlign: 'center',
},

  container: {
    padding: 16,
    paddingBottom: 60,
    backgroundColor: '#F5F8FA',
  },
  title: {
    fontSize: 22,
    fontWeight: 'bold',
    color: '#0D2C59',
    marginBottom: 20,
    textAlign: 'center',
  },
  card: {
    marginBottom: 16,
    backgroundColor: '#fff',
    borderRadius: 12,
    elevation: 3,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#0D2C59',
    marginBottom: 10,
  },
  divider: {
    marginTop: 6,
    backgroundColor: '#E0E0E0',
    height: 1,
  },
  button: {
    padding: 10,
    backgroundColor: '#4CAF50',
    borderRadius: 5,
    width: 100,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    alignSelf: 'center',
    marginTop: 16,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
  },
cardTitle: {
  fontSize: 18,
  fontWeight: 'bold',
  color: '#0D2C59',
  marginLeft: -12,
},
cardEmoji: {
  fontSize: 24,
  marginRight: 4,
},
cardBorderBlue: {
  borderLeftWidth: 5,
  borderLeftColor: '#0D2C59',
},
cardBorderGreen: {
  borderLeftWidth: 5,
  borderLeftColor: '#4CAF50',
},
cardBorderYellow: {
  borderLeftWidth: 5,
  borderLeftColor: '#FFC107',
},
infoRow: {
  flexDirection: 'row',
  justifyContent: 'space-between',
  marginBottom: 12,
  paddingVertical: 2,
  borderBottomWidth: 1,
  borderBottomColor: '#eee',
},
label: {
  fontSize: 14,
  fontWeight: '500',
  color: '#333',
},
value: {
  fontSize: 14,
  color: '#000',
},
});
