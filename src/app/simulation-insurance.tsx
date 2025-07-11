import { ChevronDownIcon } from "@/src/components/ui/icon";
import {
  Select,
  SelectBackdrop,
  SelectContent,
  SelectDragIndicator,
  SelectDragIndicatorWrapper,
  SelectIcon,
  SelectInput,
  SelectItem,
  SelectPortal,
  SelectTrigger,
} from "@/src/components/ui/select";
import DateTimePicker from "@react-native-community/datetimepicker";
import { useState } from "react";
import { Controller, useForm, useWatch } from "react-hook-form";
import {
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  View,
} from "react-native";
import {
  SafeAreaView,
  useSafeAreaInsets,
} from "react-native-safe-area-context";
import { z } from "zod";
import SimuladorResultModal from "../components/simulation-result-modal";
import { Button, ButtonText } from "../components/ui/button";
import { Input, InputField } from "../components/ui/input";

export const filterSchema = z.object({
  mark: z.string(),
  model: z.string(),
  category: z.string(),
  displacement: z.string(),
  registrationData: z.string(),
  registration: z.string(),
  capitalLevel: z.string(),
  fractionation: z.string(),
  startDate: z.string(),
});

export type FilterFormData = z.infer<typeof filterSchema>;

type Model = {
  [key: string]: {
    label: string;
    value: string;
  }[];
};
export default function SimulationInsurance() {
  const {
    control,
    handleSubmit,

    formState: { errors, isSubmitting, isValid },
  } = useForm({
    defaultValues: {
      mark: "",
      model: "",
      category: "Ligeiro Particular",
      displacement: "",
      registrationData: "",
      registration: "",
      startDate: "",
      fractionation: "Mensal",
      capitalLevel: "",
    },
    mode: "onChange",
  });

  const [showModal, setShowModal] = useState(false);
  const [dataModal, setDataModal] = useState<string>("");

  const insets = useSafeAreaInsets();

  const listMarks = [
    {
      label: "Toyota",
      value: "toyota",
    },
    {
      label: "Hyundai",
      value: "hyundai",
    },
  ];

  const listModels: Model = {
    toyota: [
      {
        label: "Corolla",
        value: "corolla",
      },
      {
        label: "RAV4",
        value: "rav4",
      },
    ],
    hyundai: [
      {
        label: "Elantra",
        value: "elantra",
      },
      {
        label: "Tucson",
        value: "tucson",
      },
    ],
  };

  const selectedMark = useWatch({ control, name: "mark" });
  const selectedModel = useWatch({ control, name: "model" });

  const filteredModel = selectedMark ? listModels[`${selectedMark}`] : [];

  const listDisplacement = [
    {
      label: "Entre 1.601 CC e 2.000 CC",
      value: "Entre 1.601 CC e 2.000 CC",
    },
    {
      label: "Entre 2.001 CC e 2.500 CC",
      value: "Entre 2.001 CC e 2.500 CC",
    },
  ];

  const listCapitalLevel = [
    {
      label: "A- 13.376.000,00 AKZ",
      value: "13.376.000,00",
    },

    {
      label: "B- 26.752.000,00 AKZ",
      value: "26.752.000,00",
    },
    {
      label: "C- 40.128.000,00 AKZ",
      value: "40.128.000,00",
    },
  ];

  const sedanModels = ["corolla", "elantra"];
  const suvModels = ["rav4", "tucson"];

  const seletedDisplacement: any = sedanModels.includes(selectedModel)
    ? listDisplacement[0]
    : suvModels.includes(selectedModel)
      ? listDisplacement[1]
      : {};
  function formatarNumeroAKZ(valor: number): string {
    return new Intl.NumberFormat("pt-AO", {
      style: "currency",
      currency: "AOA",
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(valor);
  }
  const onSubmit = (data: FilterFormData) => {
    setShowModal(true);
    const mark = data.mark.toLowerCase();
    const model = data.model.toLowerCase();
    const valorBase = 10000;
    const factorBase =
      mark === "toyota" && model === "rav4"
        ? 1.2
        : mark === "hyundai" && model === "elantra"
          ? 1.1
          : mark === "hyundai" && model === "tucson"
            ? 1.3
            : 1;

    const factorEscalao =
      mark === "toyota" && model === "rav4"
        ? 1.1
        : mark === "hyundai" && model === "elantra"
          ? 1.1
          : mark === "hyundai" && model === "tucson"
            ? 1.2
            : 1;
    const factorFraccionamento = 1;

    const premio =
      valorBase * factorBase * factorEscalao * factorFraccionamento;

    setDataModal(formatarNumeroAKZ(premio));
  };

  return (
    <SafeAreaView className="flex-1 bg-white">
      <KeyboardAvoidingView
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        keyboardVerticalOffset={insets.top + 16} // 👈 Ajusta automaticamente
        className="flex-1"
      >
        <ScrollView
          contentContainerStyle={{ paddingBottom: insets.bottom + 20 }}
        >
          <View className="flex-1 items-center justify-center bg-white">
            <Text className="text-3xl">Formulário de simulação </Text>
            <View className="gap-4 w-full px-6 mt-6">
              <Text className="text-lg">Marca</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select onValueChange={onChange}>
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        {listMarks.map((mark) => (
                          <SelectItem
                            key={mark.value}
                            label={mark.label}
                            value={mark.value}
                          />
                        ))}
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="mark"
              />
              {errors.mark && <Text className="text-sm text-red-600">Obrigatório.</Text>}

              <Text className="text-lg">Modelo</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select onValueChange={onChange}>
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        {filteredModel.map((model) => (
                          <SelectItem
                            key={model.value}
                            label={model.label}
                            value={model.value}
                          />
                        ))}
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="model"
              />
              {errors.model && <Text className="text-sm text-red-600">Obrigatório.</Text>}
              <Text className="text-lg">Categoria</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select
                    onValueChange={onChange}
                    defaultValue="Ligeiro Particular"
                    selectedValue={"Ligeiro Particular"}
                  >
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        <SelectItem
                          label={"Ligeiro Particular"}
                          value={"Ligeiro Particular"}
                        />
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="category"
              />
              {errors.category && <Text className="text-sm text-red-600">Obrigatório.</Text>}
              <Text className="text-lg">Cilindrada</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select
                    onValueChange={onChange}
                    selectedValue={seletedDisplacement?.label}
                  >
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        <SelectItem
                          label={seletedDisplacement?.label}
                          value={seletedDisplacement?.value}
                        />
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="displacement"
              />

              {errors.model && <Text className="text-sm text-red-600">Obrigatório</Text>}

              <Text className="text-lg">Data da 1.ª matrícula</Text>
              <Controller
                name="registrationData"
                control={control}
                render={({ field: { value, onChange } }) => (
                  <DateTimePicker
                    value={value ? new Date(value) : new Date()}
                    mode="date"
                    display="default"
                    onChange={(_, selectedDate: any) => {
                      if (selectedDate) {
                        onChange(selectedDate.toISOString());
                      }
                    }}
                  />
                )}
              />
              <Text className="text-lg">Matrícula</Text>
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
                      value={value}
                      onChangeText={onChange}
                      placeholder="Matrícula "
                    />
                  </Input>
                )}
                name="registration"
              />
              {errors.registration && <Text className="text-sm text-red-600">Obrigatório</Text>}

              <Text className="text-lg">Escalão de capital</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select onValueChange={onChange}>
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        {listCapitalLevel.map((mark) => (
                          <SelectItem
                            key={mark.value}
                            label={mark.label}
                            value={mark.value}
                          />
                        ))}
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="capitalLevel"
              />
                    {errors.capitalLevel && <Text className="text-sm text-red-600">Obrigatório</Text>}

              <Text className="text-lg">Fraccionamento</Text>
              <Controller
                control={control}
                rules={{
                  required: true,
                }}
                render={({ field: { onChange, onBlur, value } }) => (
                  <Select
                    onValueChange={onChange}
                    defaultValue="Mensal"
                    selectedValue={"Mensal"}
                  >
                    <SelectTrigger variant="outline" size="xl">
                      <SelectInput placeholder="Select option" />
                      <SelectIcon className="mr-3" as={ChevronDownIcon} />
                    </SelectTrigger>
                    <SelectPortal>
                      <SelectBackdrop />
                      <SelectContent>
                        <SelectDragIndicatorWrapper>
                          <SelectDragIndicator />
                        </SelectDragIndicatorWrapper>
                        <SelectItem label={"Mensal"} value={"Mensal"} />
                      </SelectContent>
                    </SelectPortal>
                  </Select>
                )}
                name="fractionation"
              />
        {errors.fractionation && <Text className="text-sm text-red-600">Obrigatório</Text>}
              <Text className="text-lg">Data de início</Text>
              <Controller
                name="startDate"
                control={control}
                render={({ field: { value, onChange } }) => (
                  <DateTimePicker
                    value={value ? new Date(value) : new Date()}
                    mode="date"
                    className="w-full"
                    display="default"
                    onChange={(_, selectedDate: any) => {
                      if (selectedDate) {
                        onChange(selectedDate.toISOString());
                      }
                    }}
                  />
                )}
              />
            </View>

            <Button
              size="xl"
              variant="solid"
              action={!isValid ? "secondary" : "primary"}
              disabled={!isValid || isSubmitting}
              onPress={handleSubmit(onSubmit)}
              className="mt-6"
            >
              <ButtonText>Simular</ButtonText>
            </Button>

            <SimuladorResultModal
              showModal={showModal}
              setShowModal={setShowModal}
              result={dataModal}
            />
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}
