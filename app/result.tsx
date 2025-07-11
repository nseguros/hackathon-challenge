import React, { useState } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity, SafeAreaView, StatusBar, ScrollView, Alert } from 'react-native';
import { useRouter, useLocalSearchParams } from 'expo-router';
import { CircleCheck as CheckCircle2, Mail, ArrowLeft, Send, LogOut } from 'lucide-react-native';

export default function ResultScreen() {
  const router = useRouter();
  const params = useLocalSearchParams();
  const [email, setEmail] = useState('');

  const { premium, brand, model, capitalLevel } = params;

  const handleSendEmail = () => {
    if (!email) {
      Alert.alert('Erro', 'Por favor, digite um endereço de e-mail válido.');
      return;
    }

    // Simular envio de e-mail
    Alert.alert(
      'Simulação Enviada',
      `A simulação foi enviada para ${email}.\n\nEm breve receberá os detalhes da sua simulação.`,
      [
        {
          text: 'OK',
          onPress: () => router.push('/home'),
        },
      ]
    );
  };

  const handleExit = () => {
    router.push('/home');
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" backgroundColor="#FFFFFF" />
      
      <View style={styles.header}>
        <TouchableOpacity
          style={styles.backButton}
          onPress={() => router.back()}
        >
          <ArrowLeft size={24} color="#2563EB" />
        </TouchableOpacity>
        <Text style={styles.title}>Resultado</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.content}>
          <View style={styles.successContainer}>
            <CheckCircle2 size={64} color="#10B981" />
            <Text style={styles.successTitle}>Simulação Concluída</Text>
            <Text style={styles.successSubtitle}>
              Resultado da Simulação de Seguro Automóvel
            </Text>
          </View>

          <View style={styles.resultCard}>
            <Text style={styles.resultTitle}>Prémio Estimado</Text>
            <Text style={styles.premiumValue}>
              {premium} AKZ/mês
            </Text>
            <Text style={styles.premiumNote}>
              O seu prémio está estimado em {premium} AKZ/mês.
            </Text>
          </View>

          <View style={styles.detailsCard}>
            <Text style={styles.detailsTitle}>Detalhes da Simulação</Text>
            <View style={styles.detailRow}>
              <Text style={styles.detailLabel}>Marca:</Text>
              <Text style={styles.detailValue}>{brand}</Text>
            </View>
            <View style={styles.detailRow}>
              <Text style={styles.detailLabel}>Modelo:</Text>
              <Text style={styles.detailValue}>{model}</Text>
            </View>
            <View style={styles.detailRow}>
              <Text style={styles.detailLabel}>Escalão de Capital:</Text>
              <Text style={styles.detailValue}>{capitalLevel}</Text>
            </View>
            <View style={styles.detailRow}>
              <Text style={styles.detailLabel}>Fraccionamento:</Text>
              <Text style={styles.detailValue}>Mensal</Text>
            </View>
          </View>

          <View style={styles.emailSection}>
            <Text style={styles.emailTitle}>Enviar por E-mail</Text>
            <Text style={styles.emailSubtitle}>
              Envie a simulação por e-mail para guardar os detalhes.
            </Text>
            
            <View style={styles.emailInputContainer}>
              <Mail size={20} color="#6B7280" />
              <TextInput
                style={styles.emailInput}
                value={email}
                onChangeText={setEmail}
                placeholder="Digite o seu e-mail"
                keyboardType="email-address"
                autoCapitalize="none"
                placeholderTextColor="#9CA3AF"
              />
            </View>
          </View>

          <View style={styles.buttonContainer}>
            <TouchableOpacity
              style={styles.sendButton}
              onPress={handleSendEmail}
              activeOpacity={0.8}
            >
              <Send size={20} color="#FFFFFF" />
              <Text style={styles.sendButtonText}>Enviar</Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.exitButton}
              onPress={handleExit}
              activeOpacity={0.8}
            >
              <LogOut size={20} color="#6B7280" />
              <Text style={styles.exitButtonText}>Sair</Text>
            </TouchableOpacity>
          </View>
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
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 24,
    paddingVertical: 16,
    backgroundColor: '#FFFFFF',
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  backButton: {
    padding: 8,
  },
  title: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
  },
  placeholder: {
    width: 40,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    padding: 24,
  },
  successContainer: {
    alignItems: 'center',
    marginBottom: 32,
  },
  successTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#1F2937',
    marginTop: 16,
    marginBottom: 8,
  },
  successSubtitle: {
    fontSize: 16,
    color: '#6B7280',
    textAlign: 'center',
  },
  resultCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 24,
    marginBottom: 24,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
    borderWidth: 2,
    borderColor: '#10B981',
  },
  resultTitle: {
    fontSize: 16,
    fontWeight: '500',
    color: '#6B7280',
    marginBottom: 8,
  },
  premiumValue: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#10B981',
    marginBottom: 16,
  },
  premiumNote: {
    fontSize: 14,
    color: '#6B7280',
    textAlign: 'center',
    lineHeight: 20,
  },
  detailsCard: {
    backgroundColor: '#FFFFFF',
    borderRadius: 16,
    padding: 24,
    marginBottom: 24,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 8,
    elevation: 4,
  },
  detailsTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 16,
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#F3F4F6',
  },
  detailLabel: {
    fontSize: 14,
    color: '#6B7280',
  },
  detailValue: {
    fontSize: 14,
    fontWeight: '500',
    color: '#1F2937',
  },
  emailSection: {
    marginBottom: 32,
  },
  emailTitle: {
    fontSize: 18,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 8,
  },
  emailSubtitle: {
    fontSize: 14,
    color: '#6B7280',
    marginBottom: 16,
  },
  emailInputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#D1D5DB',
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  emailInput: {
    flex: 1,
    fontSize: 16,
    color: '#1F2937',
    marginLeft: 12,
  },
  buttonContainer: {
    gap: 12,
  },
  sendButton: {
    backgroundColor: '#2563EB',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'center',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 4,
    },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  sendButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
    marginLeft: 8,
  },
  exitButton: {
    backgroundColor: '#FFFFFF',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    flexDirection: 'row',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: '#D1D5DB',
  },
  exitButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#6B7280',
    marginLeft: 8,
  },
});