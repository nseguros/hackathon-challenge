# 🚗 NOSSA Seguros - Sistema de Simulação de Seguros Automóveis

**Hackathon Revela-te! 2025**

## 📋 Sobre o Projeto

Sistema web completo para simulação de seguros automóveis, desenvolvido com arquitetura **Full Stack** (React + Node.js). Permite aos clientes simular, calcular, subscrever e gerenciar seguros de forma rápida e intuitiva através de uma interface moderna e API robusta.

## 🏗️ Arquitetura do Sistema

O projeto é dividido em duas aplicações principais:

- **Frontend** (`/front`): Interface do usuário desenvolvida em React + Vite
- **Backend** (`/back`): API REST desenvolvida em Node.js + Express + SQLite

## 🎯 Funcionalidades Principais

### 🖥️ Frontend (React)
- **Autenticação** com validação em tempo real
- **Simulação de Seguro** com formulário completo e modal de confirmação
- **Cálculo de Prémio** conforme matriz oficial
- **Envio por Email** via backend integrado
- **Subscrição Completa** com dados pessoais e métodos de pagamento
- **Interface Responsiva** com Tailwind CSS

### ⚙️ Backend (Node.js)
- **API REST** completa com autenticação JWT
- **Sistema de Usuários** com registro e login
- **Motor de Cálculo** de prémios de seguro
- **Envio de Emails** via Nodemailer
- **Banco de Dados** SQLite com relacionamentos
- **Segurança** com bcryptjs e validações

## 🛠️ Tecnologias Utilizadas

### Frontend
- **React 18** - Biblioteca JavaScript para interfaces
- **Vite 5** - Build tool e dev server
- **Tailwind CSS** - Framework CSS utilitário
- **React Router** - Roteamento
- **Context API** - Gerenciamento de estado
- **Axios** - Cliente HTTP

### Backend
- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **SQLite** - Banco de dados relacional
- **JWT** - Autenticação via tokens
- **bcryptjs** - Hash de senhas
- **CORS** - Cross-Origin Resource Sharing
- **Nodemailer** - Envio de emails

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Node.js (versão 16 ou superior)
- npm ou yarn

### 1. Configuração do Backend

```bash
# Navegar para a pasta do backend
cd back

# Instalar dependências
npm install

# Configurar variáveis de ambiente
# Criar arquivo .env na pasta back/ com:
PORT=3000
JWT_SECRET=sua_chave_secreta_jwt_aqui
NODE_ENV=development

# Configurações de Email (Gmail)
GMAIL_USER=seu_email@gmail.com
GMAIL_PASSWORD=sua_senha_de_aplicativo_gmail

# Executar em modo desenvolvimento
npm run dev

# OU executar em produção
npm start
```

O backend será iniciado em: `http://localhost:3000`

### 2. Configuração do Frontend

```bash
# Em um novo terminal, navegar para a pasta do frontend
cd front

# Instalar dependências
npm install

# Executar aplicação
npm run dev
```

O frontend será iniciado em: `http://localhost:5173`

### 3. Ordem de Inicialização
1. **Primeiro**: Iniciar o backend (porta 3000)
2. **Segundo**: Iniciar o frontend (porta 5173)
3. **Acessar**: http://localhost:5173

## 🎮 Fluxo de Uso da Aplicação

1. **Registro/Login**: 
   - Telefone no formato (9XXXXXXXX)
   - Senha com mínimo 6 caracteres + 1 caractere especial

2. **Página Inicial**: 
   - Clicar em "Automóvel" para iniciar simulação

3. **Simulação**: 
   - Preencher dados do veículo
   - Confirmar informações no modal

4. **Resultado**: 
   - Visualizar prémio calculado
   - Opção de enviar por email
   - Botão para aderir ao seguro

5. **Subscrição**: 
   - Inserir dados pessoais
   - Escolher método de pagamento
   - Confirmar subscrição

## 🧮 Matriz de Cálculo de Prémios

| Marca | Modelo | Escalão | Cilindrada | Prémio Mensal |
|-------|--------|---------|------------|---------------|
| Toyota | Corolla | A | 1300cc | 10.000 AKZ |
| Toyota | RAV4 | B | 2000cc | 13.200 AKZ |
| Hyundai | Elantra | B | 1600cc | 12.100 AKZ |
| Hyundai | Tucson | C | 2400cc | 15.600 AKZ |

### Fatores de Cálculo
- **Valor Base**: Conforme escalão do veículo
- **Factor Escalão**: Multiplicador por categoria
- **Factor Fracionamento**: Desconto para pagamento anual
- **Factor Cilindrada**: Ajuste conforme potência do motor

## 📡 Endpoints da API Backend

### Rotas Públicas

#### `GET /`
Informações gerais da API

#### `GET /api/home`
Página inicial da aplicação

#### `GET /api/status`
Status do servidor, uptime e uso de memória

### Autenticação

#### `POST /api/auth/register`
Registro de novo usuário
```json
{
  "phone": "929782402",
  "password": "senha@123"
}
```

#### `POST /api/auth/login`
Login de usuário
```json
{
  "phone": "929782402",
  "password": "senha@123"
}
```

#### `GET /api/auth/me`
Informações do usuário autenticado (rota protegida)

### Simulações

#### `POST /api/simulacao/calcular`
Calcula e salva uma simulação de seguro
```json
{
  "marca": "Toyota",
  "modelo": "Corolla",
  "cilindrada": "1300",
  "escalao": "A",
  "dataMatricula": "2020-01-01",
  "matricula": "LD-00-00-AA",
  "categoria": "Ligeiro Particular",
  "fraccionamento": "Mensal",
  "dataInicio": "2024-01-01"
}
```

#### `GET /api/simulacao/historico`
Histórico de simulações do usuário

#### `GET /api/simulacao/:id`
Busca simulação específica

#### `DELETE /api/simulacao/:id`
Delete simulação específica

#### `POST /api/simulacao/enviar-email`
Envia simulação por email
```json
{
  "emailDestinatario": "cliente@email.com",
  "conteudo": "Mensagem personalizada (opcional)",
  "simulacaoId": 1
}
```

## 🗄️ Estrutura do Banco de Dados

### Tabela `users`
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  phone TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Tabela `simulacoes`
```sql
CREATE TABLE simulacoes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  marca TEXT NOT NULL,
  modelo TEXT NOT NULL,
  cilindrada INTEGER NOT NULL,
  escalao TEXT NOT NULL,
  escalao_valor TEXT NOT NULL,
  categoria TEXT NOT NULL,
  fraccionamento TEXT NOT NULL,
  data_matricula TEXT NOT NULL,
  matricula TEXT NOT NULL,
  data_inicio TEXT NOT NULL,
  valor_base REAL NOT NULL,
  factor_base REAL NOT NULL,
  factor_escalao REAL NOT NULL,
  factor_fraccionamento REAL NOT NULL,
  formula TEXT NOT NULL,
  premio_estimado REAL NOT NULL,
  moeda TEXT DEFAULT 'AKZ',
  periodicidade TEXT DEFAULT 'mensal',
  cilindrada_esperada INTEGER,
  corresponde_tabela BOOLEAN,
  intervalo_cilindrada TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users (id)
);
```

## 📁 Estrutura de Pastas

```
Backup HNS - Funcional/
├── README.md                    # Este arquivo
├── back/                        # Backend API
│   ├── config/
│   │   └── database.js         # Configuração SQLite
│   ├── routes/
│   │   ├── auth.js             # Rotas de autenticação
│   │   ├── simulacao.js        # Rotas de simulação
│   │   └── home.js             # Rotas gerais
│   ├── .env                    # Variáveis de ambiente
│   ├── package.json            # Dependências backend
│   ├── server.js               # Servidor principal
│   ├── database.sqlite         # Banco de dados
│   └── README.md               # Documentação backend
├── front/                       # Frontend React
│   ├── public/
│   │   ├── favicon.png
│   │   └── vite.svg
│   ├── src/
│   │   ├── assets/
│   │   │   └── logo.png
│   │   ├── components/
│   │   │   ├── Card.jsx
│   │   │   ├── Header.jsx
│   │   │   ├── HomePage.jsx
│   │   │   ├── ProtectedRoute.jsx
│   │   │   ├── ResultadoPage.jsx
│   │   │   └── SimuladorPage.jsx
│   │   ├── contexts/
│   │   │   └── AuthContext.jsx
│   │   ├── pages/
│   │   │   ├── LoginPage.jsx
│   │   │   └── SubscricaoPage.jsx
│   │   ├── App.jsx
│   │   ├── App.css
│   │   ├── main.jsx
│   │   └── index.css
│   ├── eslint.config.js
│   ├── index.html
│   ├── package.json            # Dependências frontend
│   ├── postcss.config.js
│   ├── tailwind.config.js
│   ├── vite.config.js
│   └── README.md               # Documentação frontend
```

## 🛡️ Recursos de Segurança

- **Autenticação JWT**: Tokens seguros para sessões
- **Hash de Senhas**: bcryptjs para criptografia
- **Validação de Dados**: Sanitização no frontend e backend
- **CORS Configurado**: Controle de acesso entre domínios
- **Tratamento de Erros**: Logs e respostas padronizadas
- **Validações em Tempo Real**: UX melhorada com feedback imediato

## 📧 Configuração de Email

Para habilitar o envio de emails, configure no arquivo `.env`:

```env
# Gmail (recomendado para desenvolvimento)
GMAIL_USER=seuemail@gmail.com
GMAIL_PASSWORD=sua_senha_de_aplicativo

# Obs: Use "Senhas de aplicativo" do Gmail, não a senha da conta
```

### Como gerar senha de aplicativo Gmail:
1. Acesse sua conta Google
2. Vá em "Segurança" → "Verificação em duas etapas"
3. Em "Senhas de aplicativo", gere uma nova senha
4. Use essa senha no arquivo `.env`

## 🧪 Testando a API

### Exemplo com cURL

```bash
# Registrar usuário
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"929782402","password":"senha@123"}'

# Fazer login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"929782402","password":"senha@123"}'

# Calcular simulação (substitua SEU_TOKEN_JWT pelo token obtido no login)
curl -X POST http://localhost:3000/api/simulacao/calcular \
  -H "Authorization: Bearer SEU_TOKEN_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "marca":"Toyota",
    "modelo":"Corolla",
    "cilindrada":"1300",
    "escalao":"A",
    "dataMatricula":"2020-01-01",
    "matricula":"LD-00-00-AA",
    "categoria":"Ligeiro Particular",
    "fraccionamento":"Mensal",
    "dataInicio":"2024-01-01"
  }'
```

## 🎯 Próximos Passos / Roadmap

- [ ] **Integração com Gateway de Pagamento**
- [ ] **Módulo de Sinistros**
- [ ] **Dashboard Administrativo**
- [ ] **App Mobile (React Native)**
- [ ] **Integração com APIs de Veículos**
- [ ] **Sistema de Notificações**
- [ ] **Relatórios e Analytics**
- [ ] **...**

## 📝 Licença

Este projeto foi desenvolvido para o **Hackathon Revela-te! 2025**.

## 👥 Equipe

Projeto desenvolvido por **HUDSON MATEQUE** para o Hackathon Revela-te! 2025.

---

**🚀 Sistema completo e pronto para demonstração!**

Para suporte técnico ou dúvidas sobre o projeto, consulte a documentação específica de cada módulo nos diretórios `/front` e `/back`.
