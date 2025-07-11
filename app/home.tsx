import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, SafeAreaView, StatusBar, ScrollView } from 'react-native';
import { useRouter } from 'expo-router';
import { Car, Heart, User, CircleCheck as CheckCircle2, Circle as XCircle } from 'lucide-react-native';

export default function HomeScreen() {
  const router = useRouter();

  const handleCarInsurance = () => {
    router.push('/simulation');
  };

  const insuranceTypes = [
    {
      id: 'car',
      title: 'Seguro Automóvel',
      icon: Car,
      active: true,
      onPress: handleCarInsurance,
    },
    {
      id: 'health',
      title: 'Seguro de Saúde',
      icon: Heart,
      active: false,
      onPress: () => {},
    },
    {
      id: 'life',
      title: 'Seguro de Vida',
      icon: User,
      active: false,
      onPress: () => {},
    },
  ];

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#FFFFFF" />
      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <Text style={styles.title}>Simulador de Produtos</Text>
          <Text style={styles.subtitle}>Escolha o tipo de seguro que pretende simular</Text>
        </View>

        <View style={styles.cardsContainer}>
          {insuranceTypes.map((insurance) => (
            <TouchableOpacity
              key={insurance.id}
              style={[
                styles.card,
                insurance.active ? styles.cardActive : styles.cardInactive
              ]}
              onPress={insurance.onPress}
              disabled={!insurance.active}
              activeOpacity={0.8}
            >
              <View style={styles.cardHeader}>
                <View style={[
                  styles.iconContainer,
                  insurance.active ? styles.iconContainerActive : styles.iconContainerInactive
                ]}>
                  <insurance.icon
                    size={28}
                    color={insurance.active ? '#2563EB' : '#9CA3AF'}
                  />
                </View>
                <View style={styles.statusContainer}>
                  {insurance.active ? (
                    <CheckCircle2 size={20} color="#10B981" />
                  ) : (
                    <XCircle size={20} color="#EF4444" />
                  )}
                </View>
              </View>
              
              <Text style={[
                styles.cardTitle,
                insurance.active ? styles.cardTitleActive : styles.cardTitleInactive
              ]}>
                {insurance.title}
              </Text>
              
              <Text style={[
                styles.cardStatus,
                insurance.active ? styles.cardStatusActive : styles.cardStatusInactive
              ]}>
                {insurance.active ? 'Disponível' : 'Em breve'}
              </Text>

              {insurance.active && (
                <View style={styles.cardFooter}>
                  <Text style={styles.cardAction}>Simular agora</Text>
                </View>
              )}
            </TouchableOpacity>
          ))}
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F9FAFB',
  },
  scrollView: {
    flex: 1,
  },
  header: {
    paddingHorizontal: 24,
    paddingTop: 32,
    paddingBottom: 24,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: '#1F2937',
    textAlign: 'center',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#6B7280',
    textAlign: 'center',
    lineHeight: 24,
  },
  cardsContainer: {
    padding: 24,
    gap: 16,
  },
  card: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 24,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
    borderWidth: 2,
  },
  cardActive: {
    borderColor: '#2563EB',
  },
  cardInactive: {
    borderColor: '#E5E7EB',
  },
  cardHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 16,
  },
  iconContainer: {
    width: 56,
    height: 56,
    borderRadius: 28,
    justifyContent: 'center',
    alignItems: 'center',
  },
  iconContainerActive: {
    backgroundColor: '#EBF4FF',
  },
  iconContainerInactive: {
    backgroundColor: '#F3F4F6',
  },
  statusContainer: {
    padding: 4,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 8,
  },
  cardTitleActive: {
    color: '#1F2937',
  },
  cardTitleInactive: {
    color: '#6B7280',
  },
  cardStatus: {
    fontSize: 14,
    marginBottom: 16,
  },
  cardStatusActive: {
    color: '#10B981',
  },
  cardStatusInactive: {
    color: '#EF4444',
  },
  cardFooter: {
    paddingTop: 16,
    borderTopWidth: 1,
    borderTopColor: '#E5E7EB',
  },
  cardAction: {
    fontSize: 14,
    fontWeight: '600',
    color: '#2563EB',
    textAlign: 'center',
  },
});