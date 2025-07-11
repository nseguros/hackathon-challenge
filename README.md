# Nossa App Hackton

Um novo projeto Flutter projetado para demonstrar práticas modernas de desenvolvimento de aplicativos no Hackton da Nossa Seguros.

## Visão Geral do Projeto

Este projeto foi desenvolvido como parte do Hackathon Revela-te!, uma iniciativa promovida pela NOSSA Seguros com o objetivo de impulsionar a inovação no setor segurador angolano. O desafio propôs a criação de uma solução digital que melhorasse a experiência dos clientes, tornando as interações com a seguradora mais simples, rápidas e intuitivas.


### Funcionalidades
- **Versão**: 1.0.0+1
- **Ambiente**: Dart SDK ^3.6.1
- **Dependências**:
    - `flutter`
    - `cupertino_icons` (^1.0.8)
    - `animate_do` (^4.2.0)
    - `flutter_localizations`
- **Dependências de Desenvolvimento**:
    - `flutter_test`
    - `flutter_lints` (^5.0.0)

### Recursos
O projeto inclui os seguintes recursos:
- Imagens: `assets/imgs/`, `assets/imgs/icons/`
- Fontes:
    - Regular: `assets/fonts/Roboto-Regular.ttf`
    - Light: `assets/fonts/Roboto-Light.ttf`
    - Bold: `assets/fonts/Roboto-Bold.ttf`

### Páginas
- Tela de Splash
- Tela de Login
- Tela de criação de conta
- Tela inicial
- Tela de simulação
- Tela de pagamento
- Tab de simulações
- Tab de apólices
- Tab de perfil

### Funcionalidades

#### Autenticação do Utilizador
- Login com número de telefone e senha.

#### Simulação de Seguro Automóvel
- Escolha de marca e modelo do veículo.
- Preenchimento automático da categoria e cilindrada.
- Seleção do escalão de capital e data de início.
- Cálculo automático do prémio com base numa matriz de fatores fornecida.
- Exibição do valor estimado do prémio mensal.
- Simulação do envio por e-mail da proposta.

#### Funcionalidades Adicionais (Caso Implementadas)
- Confirmação de dados antes do cálculo.
- Subscrição do seguro após simulação.
- Formulário adicional com dados do tomador e método de pagamento.

### Credenciais de Login
- **Telefone**: 999999999
- **Palavra-passe**: 123456

## Começando

Para começar a trabalhar neste projeto, certifique-se de que o Flutter está instalado e configurado. Consulte os seguintes recursos para orientação:

- [Lab: Escreva seu primeiro aplicativo Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Exemplos úteis de Flutter](https://docs.flutter.dev/cookbook)

Para documentação detalhada sobre desenvolvimento com Flutter, visite a [documentação online](https://docs.flutter.dev/), que inclui tutoriais, exemplos e referências de API.

### Comandos para Rodar o Projeto
1. Certifique-se de que o Flutter está instalado:
   ```bash
   flutter --version
   ```
   Versão recomendada: **Flutter 3.29.2**
2. Para rodar o projeto:
   ```bash
   flutter pub get
   flutter run
   ```

## Notas de Desenvolvimento

Este projeto está configurado como um pacote privado (`publish_to: 'none'`) e não é destinado à publicação no pub.dev. Caso deseje publicá-lo, remova a linha `publish_to` do arquivo `pubspec.yaml`.

### Build e Versionamento
- **Android**: Utiliza `versionName` e `versionCode`.
- **iOS**: Utiliza `CFBundleShortVersionString` e `CFBundleVersion`.
- **Windows**: Utiliza partes de versão major, minor e patch para versões de produto e arquivo.

Para mais informações sobre versionamento, consulte:
- [Versionamento no Android](https://developer.android.com/studio/publish/versioning)
- [Versionamento no iOS](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html)

## Demostração
![DEMO](demo.mov)


## Licença

Este projeto está licenciado sob os termos especificados no repositório.
