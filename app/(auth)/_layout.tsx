import { Ionicons } from '@expo/vector-icons';
import AntDesign from '@expo/vector-icons/AntDesign';
import Entypo from '@expo/vector-icons/Entypo';
import Fontisto from '@expo/vector-icons/Fontisto';
import { Tabs } from "expo-router";
export default function RootLayout() {
    return (
        <Tabs
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarShowLabel: true,
        tabBarLabelStyle: {
          fontSize: 12,
          fontWeight: '600',
        },
        tabBarActiveTintColor: '#0066FF',
        tabBarInactiveTintColor: '#A0A0A0',
        tabBarIcon: ({ focused, color, size }) => {
          let iconName: keyof typeof Ionicons.glyphMap = 'home';

          if (route.name === 'index') {
            iconName = 'home';
          } else if (route.name === 'perfil') {
            iconName = 'person';
          } else if (route.name === 'config') {
            iconName = 'settings';
          }

          return <Ionicons name={iconName} size={size} color={color} />;
        },
      })}
    >
            <Tabs.Screen name="home"  options={{
                      title: 'Pagina inicial',
                      tabBarIcon: ({ color }) => <Entypo name="home" size={24} color={color} />,
            }}></Tabs.Screen>
            <Tabs.Screen name="configuracao"  options={{
                      title: 'Configuração',
                      tabBarIcon: ({ color }) => <Fontisto name="player-settings" size={24} color={color} />
            }}></Tabs.Screen>
            <Tabs.Screen name="simulacao"  options={{
                      title: 'Simulação',
                      tabBarIcon: ({ color }) => <AntDesign name="play" size={24} color={color} />
            }}></Tabs.Screen>
        </Tabs>
    )
}
