import { useState } from 'react';
import { KeyboardAvoidingView, StyleSheet, Text, TextInput, TouchableOpacity, View } from 'react-native';

export default function EmailCard() {
  const [email, setEmail] = useState('');
  const [enviado, setEnviado] = useState(false);

  const validarEmail = (email: string) =>
    /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);

  const handleEnviar = () => {
    // Simula envio
    setEnviado(true);
    setTimeout(() => setEnviado(false), 3000);
  };

  const podeEnviar = validarEmail(email);

  return (
    <View style={styles.card}>
        <KeyboardAvoidingView>
            <Text style={styles.label}>Deseja receber a simulação por e-mail?</Text>
            <TextInput
                placeholder="Digite seu e-mail"
                placeholderTextColor="#777"
                style={styles.input}
                value={email}
                onChangeText={setEmail}
                keyboardType="email-address"
            />
            <TouchableOpacity
                style={[styles.button, { backgroundColor: podeEnviar ? '#0D2C59' : '#ccc' }]}
                onPress={handleEnviar}
                disabled={!podeEnviar}
            >
                <Text style={styles.buttonText}>
                {enviado ? 'Enviado ✅' : 'Enviar por e-mail'}
                </Text>
            </TouchableOpacity>
      </KeyboardAvoidingView>
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: '#fff',
    padding: 20,
    borderRadius: 12,
    marginTop: 30,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.08,
    shadowRadius: 6,
    elevation: 4,
  },
  label: {
    fontSize: 16,
    marginBottom: 12,
    fontWeight: '500',
    color: '#0D2C59',
  },
  input: {
    height: 48,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    paddingHorizontal: 12,
    marginBottom: 12,
  },
  button: {
    height: 48,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
  },
  buttonText: {
    color: '#fff',
    fontWeight: '600',
  },
});
