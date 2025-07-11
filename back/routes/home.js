const express = require('express');
const router = express.Router();

// Rota de home
router.get('/home', (req, res) => {
  try {
    res.json({
      success: true,
      message: 'Bem-vindo à página inicial!',
      data: {
        appName: 'HNS Backend',
        version: '1.0.0',
        description: 'Sistema backend para gerenciamento de usuários',
        features: [
          'Autenticação de usuários',
          'Banco de dados SQLite',
          'API RESTful',
          'Segurança com JWT'
        ],
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('Erro na rota home:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// Rota de status da API
router.get('/status', (req, res) => {
  try {
    res.json({
      success: true,
      status: 'online',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
      memory: process.memoryUsage()
    });
  } catch (error) {
    console.error('Erro na rota status:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

module.exports = router;
