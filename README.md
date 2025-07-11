# nossa_seguro_app

Aplicativo Flutter para simulação, contratação e gerenciamento de seguros de forma digital e intuitiva.

## 📱 Descrição da Solução
O **nossa_seguro_app** é uma solução mobile desenvolvida em Flutter, focada em facilitar o acesso a produtos de seguro. O app permite ao usuário:
- Simular diferentes tipos de seguros (auto, vida, etc.)
- Selecionar e contratar produtos
- Gerenciar assinaturas e visualizar detalhes das apólices
- Acompanhar o status das solicitações
- Realizar login seguro

A arquitetura do projeto segue boas práticas de separação de responsabilidades, com lógica de negócio isolada em controllers e componentes de UI reutilizáveis.

## 🚀 Instruções de Instalação e Execução

### Pré-requisitos
- [Flutter](https://flutter.dev/docs/get-started/install) (versão 3.x ou superior)
- Android Studio, VS Code ou outro IDE compatível
- Emulador Android/iOS ou dispositivo físico

### Passos para rodar o projeto
1. Clone o repositório:
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd nossa_seguro_app
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute a análise de código (opcional, mas recomendado):
   ```bash
   flutter analyze
   ```
4. Rode o app em um emulador ou dispositivo:
   ```bash
   flutter run
   ```

## 🛠️ Tecnologias Utilizadas
- **Flutter**: Framework principal para desenvolvimento multiplataforma
- **Dart**: Linguagem de programação
- **Provider/Riverpod/BLoC**: Gerenciamento de estado (ajustar conforme implementação)
- **Arquitetura Limpa**: Separação de camadas (UI, controllers, serviços, modelos)
- **Integração com APIs REST**: Comunicação com backend para autenticação

## Descrição da solução desenvolvida
 - [x] autenticação do usuário feito com supabase, comprindo os requesitos pedidos
 - [x] Lista os Produtos disponíveis para simulação
 - [x] Formulario de simulação, com validação de campos
 - [x] Tela de confirmação de simulação
 - [x] Tela de calculo da simulação
 - [x] Tela de subscrição
 - [x] Tela de confirmação da subscrição

## ℹ️ Observações Relevantes
- **Limitações**:
  - Algumas funcionalidades estão pendentes de integração com backend, com exceção da autenticação, que foi implementada com o Supabase, o resto está usando mock de dados.

