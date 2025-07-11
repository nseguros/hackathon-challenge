import { Image } from "react-native";
import logoUrl from "../assets/BANCA-E-SEGURO-Nossa-Seguros-logo.png";

export default function Logo() {
  return (
    <Image
      style={{
        width: 250,
        height: 200,
      }}
      resizeMode="contain"
      source={logoUrl}
    />
  );
}
