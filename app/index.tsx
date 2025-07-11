import { Ionicons } from "@expo/vector-icons";
import { Image } from "expo-image";
import { useRouter } from "expo-router";
import { useEffect, useState } from "react";
import { ActivityIndicator, StyleSheet, Text, TextInput, TouchableOpacity, View } from "react-native";

const Index = () => {
  const [telefone, setTelefone] = useState('');
  const [senha, setSenha] = useState('');
  const [mostrarSenha, setMostrarSenha] = useState(false);
  const [loading, setLoading] = useState(false);
  const [formValido, setFormValido] = useState(false);

  const router = useRouter();

  useEffect(() => {
    const valido = telefone.length >= 9 && senha.length >= 3;
    setFormValido(valido);
  }, [telefone, senha]);

  function login() {
    if (!formValido) return;
    setLoading(true);

    setTimeout(() => {
      setLoading(false);
      if (senha === '123' && telefone === '936500717') {
        router.navigate('/(auth)/home');
      } else {
        alert("Telefone ou senha incorretos.");
      }
    }, 1000);   
  }

  return (
    <View style={styles.container}>
      <Image style={styles.logo} source={require('@/assets/images/logo.png')} />
      <Text style={styles.smallText}>Vamos começar</Text>

      <TextInput
        style={styles.input}
        keyboardType="numeric"
        placeholder="Telefone"
        placeholderTextColor="gray"
        value={telefone}
        onChangeText={setTelefone}
      />

      <View style={senhaStyle.container}>
        <TextInput
          style={senhaStyle.input}
          placeholder="Digite sua senha"
          placeholderTextColor="gray"
          secureTextEntry={!mostrarSenha}
          value={senha}
          onChangeText={setSenha}
        />
        <TouchableOpacity
          style={senhaStyle.icon}
          onPress={() => setMostrarSenha(!mostrarSenha)}
        >
          <Ionicons name={mostrarSenha ? 'eye-off' : 'eye'} size={24} color="gray" />
        </TouchableOpacity>
      </View>

      <TouchableOpacity
        style={[styles.button, { backgroundColor: formValido ? '#4CAF50' : '#ccc' }]}
        disabled={!formValido || loading}
        onPress={login}
      >
        {loading ? (
          <ActivityIndicator color="#fff" />
        ) : (
          <Text style={styles.buttonText}>Iniciar sessão</Text>
        )}
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5'
  },
  smallText: {
    fontSize: 16,
    color: '#4CAF50',
    marginBottom: 20,
    fontWeight: '600',
  },
  input: {
    height: 50,
    borderWidth: 1,
    borderColor: '#ccc',
    marginBottom: 15,
    width: '80%',
    borderRadius: 8,
    paddingHorizontal: 15,
    backgroundColor: 'white',
  },
  logo: {
    height: 60,
    width: 250,
    marginBottom: 20,
    resizeMode: 'contain',
  },
  button: {
    height: 50,
    width: '80%',
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 8,
    marginTop: 20,
  },
  buttonText: {
    color: '#fff',
    fontWeight: 'bold',
  },
});

const senhaStyle = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    paddingHorizontal: 10,
    width: '80%',
    backgroundColor: 'white',
  },
  input: {
    flex: 1,
    height: 50,
  },
  icon: {
    padding: 5,
  },
});

export default Index;
