import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity, SafeAreaView, StatusBar, ScrollView, Alert } from 'react-native';
import { useRouter } from 'expo-router';
import { ChevronDown, Calendar, ArrowLeft } from 'lucide-react-native';
import { Picker } from '@react-native-picker/picker';

export default function SimulationScreen() {
  const router = useRouter();
  const [formData, setFormData] = useState({
    brand: '',
    model: '',
    category: 'Ligeiro Particular',
    engine: '',
    registrationDate: '',
    plateNumber: '',
    capitalLevel: '',
    fractionation: 'Mensal',
    startDate: '',
  });

  const [showPicker, setShowPicker] = useState(null);

  const brands = [
    { label: 'Selecione a marca', value: '' },
    { label: 'Toyota', value: 'Toyota' },
    { label: 'Hyundai', value: 'Hyundai' },
  ];

  const models = {
    Toyota: [
      { label: 'Selecione o modelo', value: '' },
      { label: 'Corolla', value: 'Corolla' },
      { label: 'RAV4', value: 'RAV4' },
    ],
    Hyundai: [
      { label: 'Selecione o modelo', value: '' },
      { label: 'Elantra', value: 'Elantra' },
      { label: 'Tucson', value: 'Tucson' },
    ],
  };

  const capitalLevels = [
    { label: 'Selecione o escalão', value: '' },
    { label: 'A — 13.376.000,00 AKZ', value: 'A' },
    { label: 'B — 26.752.000,00 AKZ', value: 'B' },
    { label: 'C — 40.128.000,00 AKZ', value: 'C' },
  ];

  const engineMap: Record<string, string> = {
    'Corolla': 'Entre 1.601 CC e 2.000 CC',
    'Elantra': 'Entre 1.601 CC e 2.000 CC',
    'RAV4': 'Entre 2.001 CC e 2.500 CC',
    'Tucson': 'Entre 2.001 CC e 2.500 CC',
  };

  useEffect(() => {
    if (formData.model) {
      setFormData(prev => ({
        ...prev,
        engine: engineMap[formData.model as string] || '',
      }));
    }
  }, [formData.model]);

  const handleFieldChange = (field: keyof typeof formData, value: string) => {
    setFormData(prev => ({
      ...prev,
      [field]: value,
    }));

    if (field === 'brand') {
      setFormData(prev => ({
        ...prev,
        model: '',
        engine: '',
      }));
    }
  };

  const isFormValid = () => {
    return formData.brand && formData.model && formData.registrationDate && 
           formData.plateNumber && formData.capitalLevel && formData.startDate;
  };

  const handleSimulate = () => {
    if (!isFormValid()) {
      Alert.alert('Erro', 'Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    // Calcular prémio baseado numa fórmula simples
    const baseValue = {
      'A': 13376000,
      'B': 26752000,
      'C': 40128000,
    }[formData.capitalLevel];

    const brandMultiplier = formData.brand === 'Toyota' ? 1.2 : 1.0;
    const modelMultiplier = ['RAV4', 'Tucson'].includes(formData.model) ? 1.3 : 1.0;
    
    const monthlyPremium = Math.round((baseValue * 0.002 * brandMultiplier * modelMultiplier) / 12);

    router.push({
      pathname: '/result',
      params: {
        premium: monthlyPremium.toLocaleString('pt-AO'),
        brand: formData.brand,
        model: formData.model,
        capitalLevel: formData.capitalLevel,
      },
    });
  };

  const renderPicker = (
    field: keyof typeof formData,
    options: { label: string; value: string }[],
    placeholder: string
  ) => (
    <TouchableOpacity
      style={styles.pickerContainer}
      onPress={() => setShowPicker(field)}
    >
      <Text style={[styles.pickerText, !formData[field] && styles.pickerPlaceholder]}>
        {formData[field] || placeholder}
      </Text>
      <ChevronDown size={20} color="#6B7280" />
    </TouchableOpacity>
  );

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
        <Text style={styles.title}>Seguro Automóvel</Text>
        <View style={styles.placeholder} />
      </View>

      <ScrollView style={styles.scrollView} showsVerticalScrollIndicator={false}>
        <View style={styles.form}>
          <Text style={styles.formTitle}>Dados do Veículo</Text>
          
          <View style={styles.inputGroup}>
            <Text style={styles.label}>Marca *</Text>
            {renderPicker('brand', brands, 'Selecione a marca')}
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Modelo *</Text>
            {renderPicker('model', models[formData.brand as keyof typeof models] || [], 'Selecione o modelo')}
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Categoria</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={[styles.input, styles.inputDisabled]}
                value={formData.category}
                editable={false}
              />
            </View>
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Cilindrada</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={[styles.input, styles.inputDisabled]}
                value={formData.engine}
                editable={false}
              />
            </View>
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Data da 1.ª Matrícula *</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={styles.input}
                value={formData.registrationDate}
                onChangeText={(value) => handleFieldChange('registrationDate', value)}
                placeholder="DD/MM/AAAA"
                keyboardType="numeric"
              />
              <Calendar size={20} color="#6B7280" />
            </View>
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Matrícula *</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={styles.input}
                value={formData.plateNumber}
                onChangeText={(value) => handleFieldChange('plateNumber', value)}
                placeholder="Digite a matrícula"
                autoCapitalize="characters"
              />
            </View>
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Escalão de Capital *</Text>
            {renderPicker('capitalLevel', capitalLevels, 'Selecione o escalão')}
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Fraccionamento</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={[styles.input, styles.inputDisabled]}
                value={formData.fractionation}
                editable={false}
              />
            </View>
          </View>

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Data de Início *</Text>
            <View style={styles.inputContainer}>
              <TextInput
                style={styles.input}
                value={formData.startDate}
                onChangeText={(value) => handleFieldChange('startDate', value)}
                placeholder="DD/MM/AAAA"
                keyboardType="numeric"
              />
              <Calendar size={20} color="#6B7280" />
            </View>
          </View>

          <TouchableOpacity
            style={[styles.simulateButton, !isFormValid() && styles.simulateButtonDisabled]}
            onPress={handleSimulate}
            disabled={!isFormValid()}
            activeOpacity={0.8}
          >
            <Text style={[styles.simulateButtonText, !isFormValid() && styles.simulateButtonTextDisabled]}>
              Simular
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>

      {showPicker && (
        <View style={styles.pickerModal}>
          <View style={styles.pickerContent}>
            <View style={styles.pickerHeader}>
              <TouchableOpacity onPress={() => setShowPicker(null)}>
                <Text style={styles.pickerCancel}>Cancelar</Text>
              </TouchableOpacity>
              <Text style={styles.pickerTitle}>Selecionar</Text>
              <TouchableOpacity onPress={() => setShowPicker(null)}>
                <Text style={styles.pickerDone}>Concluído</Text>
              </TouchableOpacity>
            </View>
            <Picker
              selectedValue={formData[showPicker as keyof typeof formData]}
              onValueChange={(value: string) => handleFieldChange(showPicker as keyof typeof formData, value)}
            >
              {(
                showPicker === 'brand' ? brands :
                showPicker === 'model' ? (models[formData.brand as keyof typeof models] || []) :
                capitalLevels
              ).map((option: { label: string; value: string }) => (
                <Picker.Item
                  key={option.value}
                  label={option.label}
                  value={option.value}
                />
              ))}
            </Picker>
          </View>
        </View>
      )}
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
  form: {
    padding: 24,
  },
  formTitle: {
    fontSize: 20,
    fontWeight: '600',
    color: '#1F2937',
    marginBottom: 24,
  },
  inputGroup: {
    marginBottom: 20,
  },
  label: {
    fontSize: 14,
    fontWeight: '500',
    color: '#374151',
    marginBottom: 8,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#D1D5DB',
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  input: {
    flex: 1,
    fontSize: 16,
    color: '#1F2937',
  },
  inputDisabled: {
    color: '#6B7280',
    backgroundColor: '#F3F4F6',
  },
  pickerContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: '#FFFFFF',
    borderRadius: 12,
    borderWidth: 1,
    borderColor: '#D1D5DB',
    paddingHorizontal: 16,
    paddingVertical: 16,
  },
  pickerText: {
    fontSize: 16,
    color: '#1F2937',
  },
  pickerPlaceholder: {
    color: '#9CA3AF',
  },
  simulateButton: {
    backgroundColor: '#2563EB',
    paddingVertical: 16,
    borderRadius: 12,
    alignItems: 'center',
    marginTop: 32,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 4,
    },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    elevation: 8,
  },
  simulateButtonDisabled: {
    backgroundColor: '#F3F4F6',
    shadowOpacity: 0.1,
    elevation: 2,
  },
  simulateButtonText: {
    fontSize: 16,
    fontWeight: '600',
    color: '#FFFFFF',
  },
  simulateButtonTextDisabled: {
    color: '#9CA3AF',
  },
  pickerModal: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'flex-end',
  },
  pickerContent: {
    backgroundColor: '#FFFFFF',
    borderTopLeftRadius: 20,
    borderTopRightRadius: 20,
  },
  pickerHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#E5E7EB',
  },
  pickerCancel: {
    fontSize: 16,
    color: '#EF4444',
  },
  pickerTitle: {
    fontSize: 16,
    fontWeight: '600',
    color: '#1F2937',
  },
  pickerDone: {
    fontSize: 16,
    color: '#2563EB',
    fontWeight: '600',
  },
});