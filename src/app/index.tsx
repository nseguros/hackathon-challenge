import { Button, ButtonText } from "@/src/components/ui/button";
import { zodResolver } from "@hookform/resolvers/zod";
import { useRouter } from "expo-router";
import { useState } from "react";
import { Controller, useForm } from "react-hook-form";
import {
  KeyboardAvoidingView,
  Platform,
  SafeAreaView,
  Text,
  View,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { z } from "zod";
import Logo from "../components/logo";
import { EyeIcon, EyeOffIcon } from "../components/ui/icon";
import {
  Input,
  InputField,
  InputIcon,
  InputSlot,
} from "../components/ui/input";

export const filterSchema = z.object({
  numberPhone: z.string().max(9),
  password: z.string(),
});

export type FilterFormData = z.infer<typeof filterSchema>;

export default function Index() {
  const [showPassword, setShowPassword] = useState(false);

  const router = useRouter();

  const {
    control,
    handleSubmit,
    formState: { errors },
  } = useForm({
    resolver: zodResolver(filterSchema),
    // defaultValues: {
    //   numberPhone: "",
    //   password: "",
    // },
  });

  const handleState = () => {
    setShowPassword((showState) => {
      return !showState;
    });
  };

  const onSubmit = (data: FilterFormData) => {
    console.log(data);
    router.navigate("/home");
  };
  const insets = useSafeAreaInsets();
  return (
    <SafeAreaView className="flex-1 bg-white">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        keyboardVerticalOffset={insets.top + 16}
        className="flex-1"
      >
        <View className="flex-1 items-center justify-center bg-white">
          <Logo />
          <Text className="text-2xl">Vamos começar</Text>
          <View className="gap-4 w-full px-6 mt-6">
            <Controller
              control={control}
              rules={{
                maxLength: 100,
              }}
              render={({ field: { onChange, onBlur, value } }) => (
                <Input
                  variant="outline"
                  size="xl"
                  isDisabled={false}
                  isInvalid={false}
                  isReadOnly={false}
                >
                  <InputField
                    type="text"
                    keyboardType="numeric"
                    value={value}
                    onChangeText={onChange}
                    placeholder="Número de telemóvel"
                  />
                </Input>
              )}
              name="numberPhone"
            />
            {errors.numberPhone && <Text className="text-sm text-red-600">Número obrigatório 9 digitos.</Text>}
            <Controller
              control={control}
              rules={{
                maxLength: 100,
              }}
              render={({ field: { onChange, onBlur, value } }) => (
                <Input
                  variant="outline"
                  size="xl"
                  isDisabled={false}
                  isInvalid={false}
                  isReadOnly={false}
                >
                  <InputField
                    type={showPassword ? "text" : "password"}
                    value={value}
                    onChangeText={onChange}
                  />
                  <InputSlot className="pr-3" onPress={handleState}>
                    <InputIcon as={showPassword ? EyeIcon : EyeOffIcon} />
                  </InputSlot>
                </Input>
              )}
              name="password"
            />
            {errors.password && <Text className="text-sm text-red-600">Senha obrigatório.</Text>}
          </View>
          <Button
            onPress={handleSubmit(onSubmit)}
            size="xl"
            variant="solid"
            action="primary"
            className="mt-6"
          >
            <ButtonText>Iniciar Sessão</ButtonText>
          </Button>
        </View>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
