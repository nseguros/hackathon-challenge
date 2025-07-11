import Beneficios from '@/components/Beneficios/Beneficios';
import AntDesign from '@expo/vector-icons/AntDesign';
import FontAwesome5 from '@expo/vector-icons/FontAwesome5';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';
import { useRouter } from 'expo-router';
import {
  ImageBackground,
  Platform,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';

export default function Home() {
  const router = useRouter();

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.scrollContent}>
      <ImageBackground
        source={require('@/assets/images/header_app.png')}
        style={styles.headerImage}
        resizeMode="cover"
      />

      <Text style={styles.title}>Escolha o tipo de seguro que pretende</Text>

      <View style={styles.cardsContainer}>
        <TouchableOpacity style={styles.card} onPress={() => router.navigate('/(auth)/simulacao')}>
          <View style={styles.iconContainer}>
            <AntDesign name="car" size={30} color="#0D2C59" />
          </View>
          <Text style={styles.cardText}>Automóvel</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.card}>
          <View style={styles.iconContainer}>
            <MaterialIcons name="health-and-safety" size={30} color="#0D2C59" />
          </View>
          <Text style={styles.cardText}>Saúde</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.card}>
          <View style={styles.iconContainer}>
            <FontAwesome5 name="book-dead" size={30} color="#0D2C59" />
          </View>
          <Text style={styles.cardText}>Vida</Text>
        </TouchableOpacity>
      </View>

      <Beneficios />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  scrollContent: {
    paddingBottom: 30,
  },
  headerImage: {
    height: 180,
    width: '100%',
  },
  title: {
    fontSize: 20,
    fontWeight: '700',
    color: '#0D2C59',
    textAlign: 'center',
    marginVertical: 24,
  },
  cardsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-evenly',
    gap: 16,
    paddingHorizontal: 16,
  },
  card: {
    width: '28%',
    backgroundColor: '#F9FCFF',
    borderWidth: 1,
    borderColor: '#E0EEF8',
    borderRadius: 16,
    paddingVertical: 20,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.07,
    shadowRadius: 2,
    elevation: Platform.OS === 'android' ? 3 : 1,
  },
  iconContainer: {
    marginBottom: 10,
    backgroundColor: '#E6F0FB',
    padding: 12,
    borderRadius: 50,
  },
  cardText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#0D2C59',
    textAlign: 'center',
  },
});
