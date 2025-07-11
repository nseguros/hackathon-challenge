# Frontend - Nossa Seguros

Este é o frontend da aplicação **Nossa Seguros**, desenvolvido com **Next.js 15**, **React 18**, **TailwindCSS** e **Radix UI**.

## 🧱 Stack Tecnológica

- **Next.js** `^15.3.5`
- **React** `^18.2.0`
- **TailwindCSS** `^3.4.17`
- **Radix UI** (diversos componentes de acessibilidade)
- **react-hook-form** e **zod** para validação
- **Lucide** para ícones

## 🚀 Como rodar o projeto

1. Instale as dependências:

```bash
npm install
# ou
pnpm install
```

2. Execute o servidor de desenvolvimento:

```bash
npm run dev
# ou
pnpm dev
```

3. Acesse em: [http://localhost:3000](http://localhost:3000)

3.1. Use o user Padrão:

👤 Utilizador Padrão e Registo
A aplicação dispõe de um utilizador padrão para testes iniciais:

📧 E-mail:    client@nossa.ao  
📱 Telefone:  923000000  
🔐 Senha:     password

## 📁 Estrutura de Pastas

```
frontEnd/
├── app/                      # Rotas do Next.js App Router
│   ├── login/
│   ├── register/
│   ├── simulacao/
│   ├── simulacao-automovel/
│   ├── subscricao/
│   └── user/
├── components/              # Componentes reutilizáveis
├── hooks/                   # Custom React hooks
├── lib/                     # Funções utilitárias e serviços
├── public/                  # Arquivos estáticos
├── styles/                  # Estilos globais
├── .env.local               # Variáveis de ambiente (se necessário)
└── tailwind.config.ts       # Configuração do TailwindCSS
```

## ✅ Funcionalidades

- Simulação de seguro automóvel
- Confirmação visual do prêmio mensal estimado
- Fluxo de subscrição com preenchimento de dados pessoais
- Simulação de pagamento (mocked)
- Redirecionamento e feedback com UX fluida

## 📦 Scripts disponíveis

```bash
npm run dev       # Inicia em modo de desenvolvimento
npm run build     # Compila o projeto para produção
npm run start     # Roda o build para produção
npm run lint      # Analisa o código com ESLint
```

## 🔧 Requisitos

- Node.js 18+
- pnpm ou npm
- Navegador moderno

## ✨ Sugestões Futuras

- Integração com sistemas de pagamento reais (Multicaixa, Cartão)
- Área do cliente para gerir apólices
- Notificações em tempo real com WebSockets
- Dashboard para administradores
- Comunicação com o back para Aderir a uma Apólices

## 💡 Contato

Desenvolvido por: \[EDGAR A. DIKENGE]

LinkedIn: \[[Edgar Almeida Dikenge](https://linkedin.com/in/edgar-almeida-dikenge-199330261)]
Email: \[[dikengeofficial@gmail.com](dikengeofficial@gmail.com)]
