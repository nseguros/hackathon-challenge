const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');
const path = require('path');

// Importar rotas
const authRoutes = require('./routes/auth');
const homeRoutes = require('./routes/home');
const simulacaoRoutes = require('./routes/simulacao');

// Importar e inicializar banco de dados
const db = require('./config/database');

// Configurar variáveis de ambiente
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rotas
app.use('/api/auth', authRoutes);
app.use('/api', homeRoutes);
app.use('/api/simulacao', simulacaoRoutes);

// Rota raiz
app.get('/', (req, res) => {
  res.json({
    message: 'Bem-vindo ao Backend HNS!',
    version: '1.0.0',
    endpoints: {
      home: '/api/home',
      login: '/api/auth/login (phone, password)',
      register: '/api/auth/register (phone, password)',
      simulacao: '/api/simulacao/calcular (POST - requer autenticação)',
      historico: '/api/simulacao/historico (GET - requer autenticação)',
      enviarEmail: '/api/simulacao/enviar-email (POST - requer autenticação)'
    },
    requirements: {
      phone: 'Número de telefone válido',
      password: 'Mínimo 6 caracteres + 1 caractere especial'
    }
  });
});

// Middleware de tratamento de erros
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Erro interno do servidor'
  });
});

// Middleware para rotas não encontradas
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Rota não encontrada'
  });
});

// Inicializar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando na porta ${PORT}`);
  console.log(`📱 Acesse: http://localhost:${PORT}`);
});
