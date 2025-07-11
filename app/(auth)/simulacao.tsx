import DateTimePicker from '@react-native-community/datetimepicker';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';
import { Alert, Image, ScrollView, StyleSheet } from 'react-native';
import { Button, Menu, Provider, Text, TextInput } from 'react-native-paper';
const marcas = ['Toyota', 'Hyundai'];
const modelosPorMarca: Record<string, string[]> = {
  Toyota: ['Corolla', 'RAV4'],
  Hyundai: ['Elantra', 'Tucson'],
};
const cilindradas: Record<string, string> = {
  Corolla: 'Entre 1.601 CC e 2.000 CC',
  Elantra: 'Entre 1.601 CC e 2.000 CC',
  RAV4: 'Entre 2.001 CC e 2.500 CC',
  Tucson: 'Entre 2.001 CC e 2.500 CC',
};

export default function Simulacao() {
  const router = useRouter();

  const [matricula, setMatricula] = useState('');
  const [marca, setMarca] = useState('');
  const [modelo, setModelo] = useState('');
  const [categoria, setCategoria] = useState('');
  const [cilindrada, setCilindrada] = useState('');
  const [escalaoCapital, setEscalaoCapital] = useState('');
  const [fracionamento, setFracionamento] = useState('Mensal');

  const [dataPrimeiraMatricula, setDataPrimeiraMatricula] = useState<Date | null>(null);
  const [dataInicio, setDataInicio] = useState<Date | null>(null);
  const [showPicker, setShowPicker] = useState<'matricula' | 'inicio' | null>(null);

  const [marcaMenuVisible, setMarcaMenuVisible] = useState(false);
  const [modeloMenuVisible, setModeloMenuVisible] = useState(false);
  const [escalaoMenuVisible, setEscalaoMenuVisible] = useState(false);

  useEffect(() => {
    if (modelo) {
      setCategoria('Ligeiro Particular');
      setCilindrada(cilindradas[modelo] || '');
    } else {
      setCategoria('');
      setCilindrada('');
    }
  }, [modelo]);

  const formatarData = (date: Date | null) => {
    if (!date) return '';
    return new Intl.DateTimeFormat('pt-AO').format(date);
  };

  const goToResultado = () => {
    
      if (!matricula.trim()) {
    return Alert.alert('Erro', 'Por favor, preencha a matrícula do veículo.');
  }

  if (!marca) {
    return Alert.alert('Erro', 'Por favor, selecione a marca do veículo.');
  }

  if (!modelo) {
    return Alert.alert('Erro', 'Por favor, selecione o modelo do veículo.');
  }

  if (!dataPrimeiraMatricula) {
    return Alert.alert('Erro', 'Por favor, selecione a data da 1ª matrícula.');
  }

  if (!dataInicio) {
    return Alert.alert('Erro', 'Por favor, selecione a data de início.');
  }

  if (!escalaoCapital) {
    return Alert.alert('Erro', 'Por favor, selecione o escalão de capital.');
  }

  if (!fracionamento.trim()) {
    return Alert.alert('Erro', 'Por favor, preencha o fracionamento.');
  }


    router.push({
      pathname: '/(resultado)/resultado',
      params: {
        matricula,
        marca,
        modelo,
        categoria,
        cilindrada,
        dataPrimeiraMatricula: formatarData(dataPrimeiraMatricula),
        dataInicio: formatarData(dataInicio),
        escalaoCapital,
        fracionamento,
      },
    });
  };

  return (
    <Provider>
      <ScrollView contentContainerStyle={styles.container}>
        <Image source={require('@/assets/images/logo.png')} style={styles.logo} resizeMode="contain" />
        <Text style={styles.title}>Simulação de Seguro Automóvel</Text>

        <TextInput
          label="Matrícula"
          value={matricula}
          onChangeText={setMatricula}
          mode="outlined"
          style={styles.input}
          textColor="#000"
          outlineColor="#0D2C59"
          activeOutlineColor="#0D2C59"
        />

        <Menu
          visible={marcaMenuVisible}
          onDismiss={() => setMarcaMenuVisible(false)}
          anchor={
            <TextInput
              label="Marca"
              value={marca}
              mode="outlined"
              style={styles.input}
              onFocus={() => setMarcaMenuVisible(true)}
              textColor="#000"
              outlineColor="#0D2C59"
              activeOutlineColor="#0D2C59"
              right={<TextInput.Icon icon="menu-down" />}
            />
          }>
          {marcas.map((item) => (
            <Menu.Item
              key={item}
              onPress={() => {
                setMarca(item);
                setModelo('');
                setMarcaMenuVisible(false);
              }}
              title={item}
            />
          ))}
        </Menu>

        {marca !== '' && (
          <Menu
            visible={modeloMenuVisible}
            onDismiss={() => setModeloMenuVisible(false)}
            anchor={
              <TextInput
                label="Modelo"
                value={modelo}
                mode="outlined"
                style={styles.input}
                onFocus={() => setModeloMenuVisible(true)}
                textColor="#000"
                outlineColor="#0D2C59"
                activeOutlineColor="#0D2C59"
                right={<TextInput.Icon icon="menu-down" />}
              />
            }>
            {modelosPorMarca[marca]?.map((item) => (
              <Menu.Item
                key={item}
                onPress={() => {
                  setModelo(item);
                  setModeloMenuVisible(false);
                }}
                title={item}
              />
            ))}
          </Menu>
        )}

        {categoria !== '' && (
          <TextInput
            label="Categoria"
            value={categoria}
            mode="outlined"
            style={styles.input}
            editable={false}
            textColor="#000"
          />
        )}

        {cilindrada !== '' && (
          <TextInput
            label="Cilindrada"
            value={cilindrada}
            mode="outlined"
            style={styles.input}
            editable={false}
            textColor="#000"
          />
        )}

        <TextInput
          label="Data da 1ª Matrícula"
          value={formatarData(dataPrimeiraMatricula)}
          mode="outlined"
          style={styles.input}
          editable={false}
          onPressIn={() => setShowPicker('matricula')}
          right={<TextInput.Icon icon="calendar" />}
          textColor="#000"
        />
        {showPicker === 'matricula' && (
          <DateTimePicker
            value={dataPrimeiraMatricula || new Date()}
            mode="date"
            display="default"
            onChange={(event, date) => {
              setShowPicker(null);
              if (date) setDataPrimeiraMatricula(date);
            }}
          />
        )}

        <TextInput
          label="Data de Início"
          value={formatarData(dataInicio)}
          mode="outlined"
          style={styles.input}
          editable={false}
          onPressIn={() => setShowPicker('inicio')}
          right={<TextInput.Icon icon="calendar" />}
          textColor="#000"
        />
        {showPicker === 'inicio' && (
          <DateTimePicker
            value={dataInicio || new Date()}
            mode="date"
            display="default"
            onChange={(event, date) => {
              setShowPicker(null);
              if (date) setDataInicio(date);
            }}
          />
        )}

        <Menu
          visible={escalaoMenuVisible}
          onDismiss={() => setEscalaoMenuVisible(false)}
          anchor={
            <TextInput
              label="Escalão de Capital"
              value={escalaoCapital}
              mode="outlined"
              style={styles.input}
              onFocus={() => setEscalaoMenuVisible(true)}
              right={<TextInput.Icon icon="menu-down" />}
              textColor="#000"
              outlineColor="#0D2C59"
              activeOutlineColor="#0D2C59"
            />
          }>
          <Menu.Item onPress={() => { setEscalaoCapital('A - 13.376.000 AKZ'); setEscalaoMenuVisible(false); }} title="A - 13.376.000 AKZ" />
          <Menu.Item onPress={() => { setEscalaoCapital('B - 26.752.000 AKZ'); setEscalaoMenuVisible(false); }} title="B - 26.752.000 AKZ" />
          <Menu.Item onPress={() => { setEscalaoCapital('C - 40.128.000 AKZ'); setEscalaoMenuVisible(false); }} title="C - 40.128.000 AKZ" />
        </Menu>

        <TextInput
          label="Fracionamento"
          value={fracionamento}
          onChangeText={setFracionamento}
          mode="outlined"
          style={styles.input}
          textColor="#000"
          outlineColor="#0D2C59"
          activeOutlineColor="#0D2C59"
        />

        <Button mode="contained" onPress={goToResultado} style={styles.button}>
          <Text>Simular</Text>
        </Button>
      </ScrollView>
    </Provider>
  );
}

const styles = StyleSheet.create({
  container: {
    padding: 20,
    paddingBottom: 60,
    backgroundColor: '#fff',
  },
  logo: {
    width: 140,
    height: 60,
    alignSelf: 'center',
    marginBottom: 10,
  },
  title: {
    fontSize: 20,
    fontWeight: '700',
    color: '#0D2C59',
    marginBottom: 20,
    textAlign: 'center',
  },
  input: {
    marginBottom: 16,
    backgroundColor: '#f8f9fa',
  },
  button: {
    marginTop: 20,
    paddingVertical: 10,
    backgroundColor: '#0D2C59',
    borderRadius: 5,
  },
});
