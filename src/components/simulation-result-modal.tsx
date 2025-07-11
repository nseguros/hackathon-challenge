import { Button, ButtonText } from "@/src/components/ui/button";
import { Center } from "@/src/components/ui/center";
import { Heading } from "@/src/components/ui/heading";
import { CloseIcon, Icon } from "@/src/components/ui/icon";
import {
  Modal,
  ModalBackdrop,
  ModalBody,
  ModalCloseButton,
  ModalContent,
  ModalFooter,
  ModalHeader,
} from "@/src/components/ui/modal";
import { Text } from "@/src/components/ui/text";
import { useRouter } from "expo-router";
import React from "react";
import { KeyboardAvoidingView, Platform } from "react-native";
import {
  SafeAreaView,
  useSafeAreaInsets,
} from "react-native-safe-area-context";
import { Input, InputField } from "./ui/input";

export default function SimuladorResultModal({
  showModal,
  setShowModal,
  result = 0,
}: any) {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  return (
    <SafeAreaView className="flex-1 bg-white">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        keyboardVerticalOffset={insets.top + 16} // 👈 Ajusta automaticamente
        className="flex-1"
      >
        <Center className="h-[300px]">
          <Modal
            isOpen={showModal}
            onClose={() => {
              setShowModal(false);
            }}
            size="md"
          >
            <ModalBackdrop />
            <ModalContent>
              <ModalHeader>
                <Heading size="md" className="text-typography-950">
                  Resultado da Simulação de Seguro Automóvel
                </Heading>
                <ModalCloseButton>
                  <Icon
                    as={CloseIcon}
                    size="md"
                    className="stroke-background-400 group-[:hover]/modal-close-button:stroke-background-700 group-[:active]/modal-close-button:stroke-background-900 group-[:focus-visible]/modal-close-button:stroke-background-900"
                  />
                </ModalCloseButton>
              </ModalHeader>
              <ModalBody>
                <Text className="text-lg">
                  O seu prémio está estimado em ${result} AKZ/mês.
                </Text>

                <Text className="mt-2 font-semibold">
                  Envie a simulação por e-mail
                </Text>
                <Input
                  variant="outline"
                  size="xl"
                  isDisabled={false}
                  isInvalid={false}
                  isReadOnly={false}
                  className="mt-4"
                >
                  <InputField type="text" placeholder="E-mail" />
                </Input>
              </ModalBody>
              <ModalFooter>
                <Button
                  variant="outline"
                  action="secondary"
                  onPress={() => {
                    setShowModal(false);
                    router.navigate("/home");
                  }}
                >
                  <ButtonText>Sair</ButtonText>
                </Button>
                <Button
                  onPress={() => {
                    setShowModal(false);
                  }}
                >
                  <ButtonText>Enviar</ButtonText>
                </Button>
              </ModalFooter>
            </ModalContent>
          </Modal>
        </Center>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
