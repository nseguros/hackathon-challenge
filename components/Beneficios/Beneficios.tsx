import { FontAwesome5, Ionicons, MaterialIcons } from '@expo/vector-icons';
import { StyleSheet, Text, View } from 'react-native';

export default function Beneficios() {
  const beneficios = [
    {
      icon: <Ionicons name="shield-checkmark" size={24} color="#0D2C59" />,
      label: 'Cobertura imediata',
    },
    {
      icon: <FontAwesome5 name="ambulance" size={22} color="#0D2C59" />,
      label: 'Assistência 24h',
    },
    {
      icon: <MaterialIcons name="car-rental" size={24} color="#0D2C59" />,
      label: 'Carro de substituição',
    },
    {
      icon: <FontAwesome5 name="file-invoice" size={20} color="#0D2C59" />,
      label: 'Documentação simplificada',
    },
  ];

  return (
    <View style={styles.container}>
      <Text style={styles.title}>🛡️ Benefícios incluídos no seu seguro</Text>

      {beneficios.map((item, index) => (
        <View key={index} style={styles.row}>
          <View style={styles.iconBox}>{item.icon}</View>
          <Text style={styles.label}>{item.label}</Text>
        </View>
      ))}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginTop: 30,
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 18,
    fontWeight: '700',
    color: '#0D2C59',
    marginBottom: 20,
    textAlign: 'center',
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderBottomColor: '#E1E7EF',
  },
  iconBox: {
    width: 36,
    height: 36,
    borderRadius: 8,
    backgroundColor: '#E6EEF9',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 12,
  },
  label: {
    fontSize: 15,
    fontWeight: '500',
    color: '#0D2C59',
    flexShrink: 1,
  },
});
