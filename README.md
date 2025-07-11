# 🚗 NOSSA Seguros - Simulador de Seguro Automóvel

Este é um MVP (protótipo funcional) de uma plataforma **mobile** construída com **React Native + Expo**, desenvolvida para o Hackathon **Revela-te!** promovido pela **NOSSA Seguros**.

---

## 📱 Funcionalidades Implementadas

- Autenticação fictícia com validação de campos
- Simulação de seguro automóvel com base em:
  - Marca e Modelo do veículo
  - Cilindrada (gerada automaticamente)
  - Escalão de capital
  - Fraccionamento
- Cálculo automático do prémio com base na matriz fornecida
- Formatação monetária para valores em AKZ
- Visualização do valor final em modal
- Layout responsivo e otimizado para mobile

---

## ⚙️ Tecnologias Utilizadas

- **Expo (React Native)**
- **TypeScript**
- **react-hook-form** – controle de formulário
- **zod** – validação de esquema
- **@react-native-community/datetimepicker** – datas
- **Tailwind CSS (via NativeWind) / Gluestack UI** – estilização
- **Custom UI Components** (Select, Input, Modal)

---

## 📂 Instalação & Execução

```bash


# 3. Instalar as dependências
pnpm install

# 4. Executar o projeto no Expo
pnpx expo start
