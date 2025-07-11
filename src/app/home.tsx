import { Button, ButtonText } from "@/src/components/ui/button";
import { CircleIcon } from "@/src/components/ui/icon";
import {
  Radio,
  RadioGroup,
  RadioIcon,
  RadioIndicator,
  RadioLabel,
} from "@/src/components/ui/radio";
import { useRouter } from "expo-router";
import { useState } from "react";
import { Text, View } from "react-native";
import Logo from "../components/logo";
export default function Index() {
  const options = ["Seguro Automóvel", "Seguro de Saúde", "Seguro de Vida"];
  const [value, setValue] = useState<string>(options[0]);

  const router = useRouter();
  function handleClick() {
    router.navigate("/simulation-insurance");
  }

  return (
    <View className="flex-1 items-center justify-center bg-white">
      <Logo />
      <Text className="text-2xl">Simulador de Produtos</Text>
      <Text className="text-lg mt-4">
        Escolha o tipo de seguro que pretende simular.
      </Text>
      <Text className="text-lg mt-4">Cartões com as seguintes opções</Text>

      <View>
        <RadioGroup value={value} onChange={setValue}>
          {options.map((opt, index) => (
            <Radio
              key={index}
              value={opt}
              size="md"
              isInvalid={false}
              isDisabled={false}
            >
              <RadioIndicator>
                <RadioIcon as={CircleIcon} />
              </RadioIndicator>
              <RadioLabel>{opt}</RadioLabel>
            </Radio>
          ))}
        </RadioGroup>
      </View>
      <Button
        onPress={handleClick}
        size="xl"
        variant="solid"
        action="primary"
        className="mt-4"
      >
        <ButtonText>Continuar</ButtonText>
      </Button>
    </View>
  );
}
