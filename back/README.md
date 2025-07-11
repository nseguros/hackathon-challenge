# HNS Backend

Backend desenvolvido em Node.js com JavaScript e SQLite para o projeto HNS.

## 🚀 Tecnologias

- **Node.js** - Runtime JavaScript
- **Express.js** - Framework web
- **SQLite** - Banco de dados
- **JWT** - Autenticação
- **bcryptjs** - Hash de senhas
- **CORS** - Cross-Origin Resource Sharing
- **Nodemailer** - Envio de emails

## 📦 Instalação

1. Clone o repositório ou navegue até a pasta do projeto
2. Instale as dependências:
```bash
npm install
```

3. Configure as variáveis de ambiente no arquivo `.env`:
```
PORT=3000
JWT_SECRET=sua_chave_secreta_jwt_aqui
NODE_ENV=development

# Configurações de Email
GMAIL_USER=seu_email@gmail.com
GMAIL_PASSWORD=sua_senha_de_aplicativo_gmail
```

## 🎯 Como usar

### Desenvolvimento
```bash
npm run dev
```

### Produção
```bash
npm start
```

O servidor será iniciado na porta configurada (padrão: 3000).

## 📋 Endpoints da API

### Rotas Públicas

#### GET `/`
- **Descrição**: Informações gerais da API
- **Resposta**: JSON com informações da API e endpoints disponíveis

#### GET `/api/home`
- **Descrição**: Página inicial da aplicação
- **Resposta**: JSON com informações de boas-vindas

#### GET `/api/status`
- **Descrição**: Status da API
- **Resposta**: JSON com status do servidor, uptime e uso de memória

### Autenticação

#### POST `/api/auth/register`
- **Descrição**: Registro de novo usuário
- **Body**:
```json
{
  "phone": "929782402",
  "password": "senha@123"
}
```
- **Validações**:
  - Número de telefone: mínimo 8 dígitos
  - Senha: mínimo 6 caracteres + 1 caractere especial

#### POST `/api/auth/login`
- **Descrição**: Login de usuário
- **Body**:
```json
{
  "phone": "929782402",
  "password": "senha@123"
}
```

#### GET `/api/auth/me`
- **Descrição**: Informações do usuário autenticado (rota protegida)
- **Headers**: `Authorization: Bearer {token}`

### Simulações

#### POST `/api/simulacao/calcular`
- **Descrição**: Calcula e salva uma simulação de seguro
- **Headers**: `Authorization: Bearer {token}`
- **Body**:
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

#### GET `/api/simulacao/historico`
- **Descrição**: Busca o histórico de simulações do usuário
- **Headers**: `Authorization: Bearer {token}`
- **Query Parameters**: `limit` (padrão: 10), `offset` (padrão: 0)

#### GET `/api/simulacao/:id`
- **Descrição**: Busca uma simulação específica
- **Headers**: `Authorization: Bearer {token}`

#### DELETE `/api/simulacao/:id`
- **Descrição**: Deleta uma simulação específica
- **Headers**: `Authorization: Bearer {token}`

#### POST `/api/simulacao/enviar-email`
- **Descrição**: Envia uma simulação por email
- **Headers**: `Authorization: Bearer {token}`
- **Body**:
```json
{
  "emailDestinatario": "cliente@email.com",
  "conteudo": "Mensagem personalizada (opcional)",
  "simulacaoId": 1
}
```

## 🗄️ Banco de Dados

O banco SQLite será criado automaticamente na primeira execução com as seguintes tabelas:

### Tabela `users`
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `phone` (TEXT, UNIQUE, NOT NULL)
- `password` (TEXT, NOT NULL)
- `created_at` (DATETIME, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

### Tabela `simulacoes`
- `id` (INTEGER, PRIMARY KEY, AUTOINCREMENT)
- `user_id` (INTEGER, NOT NULL, FOREIGN KEY)
- `marca` (TEXT, NOT NULL)
- `modelo` (TEXT, NOT NULL)
- `cilindrada` (INTEGER, NOT NULL)
- `escalao` (TEXT, NOT NULL)
- `escalao_valor` (TEXT, NOT NULL)
- `categoria` (TEXT, NOT NULL)
- `fraccionamento` (TEXT, NOT NULL)
- `data_matricula` (TEXT, NOT NULL)
- `matricula` (TEXT, NOT NULL)
- `data_inicio` (TEXT, NOT NULL)
- `valor_base` (REAL, NOT NULL)
- `factor_base` (REAL, NOT NULL)
- `factor_escalao` (REAL, NOT NULL)
- `factor_fraccionamento` (REAL, NOT NULL)
- `formula` (TEXT, NOT NULL)
- `premio_estimado` (REAL, NOT NULL)
- `moeda` (TEXT, DEFAULT 'AKZ')
- `periodicidade` (TEXT, DEFAULT 'mensal')
- `cilindrada_esperada` (INTEGER)
- `corresponde_tabela` (BOOLEAN)
- `intervalo_cilindrada` (TEXT)
- `created_at` (DATETIME, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (DATETIME, DEFAULT CURRENT_TIMESTAMP)

## 🔧 Estrutura do Projeto

```
back/
├── config/
│   └── database.js      # Configuração do banco SQLite
├── routes/
│   ├── auth.js         # Rotas de autenticação
│   ├── simulacao.js     # Rotas de simulação
│   └── home.js         # Rotas da página inicial
├── .env                # Variáveis de ambiente
├── package.json        # Dependências e scripts
├── server.js          # Arquivo principal do servidor
└── database.sqlite    # Banco de dados (criado automaticamente)
```

## 🛡️ Segurança

- Senhas são criptografadas usando bcryptjs
- Autenticação via JWT tokens
- Validação de dados de entrada
- CORS configurado
- Tratamento de erros

## 📝 Exemplos de Uso

### Registrar um usuário
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"phone":"929782402","password":"senha@123"}'
```

### Fazer login
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"phone":"929782402","password":"senha@123"}'
```

### Calcular simulação
```bash
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

### Enviar simulação por email
```bash
curl -X POST http://localhost:3000/api/simulacao/enviar-email \
  -H "Authorization: Bearer SEU_TOKEN_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "emailDestinatario":"cliente@email.com",
    "conteudo":"Segue sua simulação de seguro automóvel",
    "simulacaoId":1
  }'
```

### Acessar rota protegida
```bash
curl -X GET http://localhost:3000/api/auth/me \
  -H "Authorization: Bearer SEU_TOKEN_JWT"
```
