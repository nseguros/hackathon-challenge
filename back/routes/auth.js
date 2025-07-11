const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/database');

const router = express.Router();

// Função para validar número de telefone
const validatePhone = (phone) => {
  // Remove todos os caracteres não numéricos
  const cleanPhone = phone.replace(/\D/g, '');
  // Verifica se tem pelo menos 8 dígitos (formato mínimo)
  return cleanPhone.length == 9;
};

// Função para validar senha
const validatePassword = (password) => {
  // Verifica se tem 6 ou mais caracteres
  if (password.length < 6) {
    return { valid: false, message: 'A senha deve ter pelo menos 6 caracteres' };
  }
  
  // Verifica se tem pelo menos um caractere especial
  const specialCharRegex = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/;
  if (!specialCharRegex.test(password)) {
    return { valid: false, message: 'A senha deve conter pelo menos um caractere especial' };
  }
  
  return { valid: true };
};

// Rota de registro
router.post('/register', async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Validação básica
    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Número de telefone e senha são obrigatórios'
      });
    }

    // Validar número de telefone
    if (!validatePhone(phone)) {
      return res.status(400).json({
        success: false,
        message: 'Número de telefone inválido, deve conter 9 dígitos'
      });
    }

    // Validar senha
    const passwordValidation = validatePassword(password);
    if (!passwordValidation.valid) {
      return res.status(400).json({
        success: false,
        message: passwordValidation.message
      });
    }

    // Limpar número de telefone (manter apenas números)
    const cleanPhone = phone.replace(/\D/g, '');

    // Verificar se o usuário já existe
    db.get(
      'SELECT id FROM users WHERE phone = ?',
      [cleanPhone],
      async (err, row) => {
        if (err) {
          console.error('Erro ao verificar usuário:', err);
          return res.status(500).json({
            success: false,
            message: 'Erro interno do servidor'
          });
        }

        if (row) {
          return res.status(400).json({
            success: false,
            message: 'Número de telefone já está cadastrado'
          });
        }

        try {
          // Hash da senha
          const saltRounds = 10;
          const hashedPassword = await bcrypt.hash(password, saltRounds);

          // Inserir usuário no banco
          db.run(
            'INSERT INTO users (phone, password) VALUES (?, ?)',
            [cleanPhone, hashedPassword],
            function(err) {
              if (err) {
                console.error('Erro ao criar usuário:', err);
                return res.status(500).json({
                  success: false,
                  message: 'Erro ao criar usuário'
                });
              }

              res.status(201).json({
                success: true,
                message: 'Usuário criado com sucesso',
                data: {
                  id: this.lastID,
                  phone: cleanPhone
                }
              });
            }
          );
        } catch (hashError) {
          console.error('Erro ao processar senha:', hashError);
          res.status(500).json({
            success: false,
            message: 'Erro ao processar dados'
          });
        }
      }
    );
  } catch (error) {
    console.error('Erro no registro:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// Rota de login
router.post('/login', (req, res) => {
  try {
    const { phone, password } = req.body;

    // Validação básica
    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Número de telefone e senha são obrigatórios'
      });
    }

    // Limpar número de telefone
    const cleanPhone = phone.replace(/\D/g, '');

    // Buscar usuário no banco
    db.get(
      'SELECT * FROM users WHERE phone = ?',
      [cleanPhone],
      async (err, user) => {
        if (err) {
          console.error('Erro ao buscar usuário:', err);
          return res.status(500).json({
            success: false,
            message: 'Erro interno do servidor'
          });
        }

        if (!user) {
          return res.status(401).json({
            success: false,
            message: 'Credenciais inválidas'
          });
        }

        try {
          // Verificar senha
          const isValidPassword = await bcrypt.compare(password, user.password);

          if (!isValidPassword) {
            return res.status(401).json({
              success: false,
              message: 'Credenciais inválidas'
            });
          }

          // Gerar JWT token
          const token = jwt.sign(
            { 
              userId: user.id, 
              phone: user.phone
            },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
          );

          res.json({
            success: true,
            message: 'Login realizado com sucesso',
            data: {
              user: {
                id: user.id,
                phone: user.phone
              },
              token: token
            }
          });
        } catch (compareError) {
          console.error('Erro ao verificar senha:', compareError);
          res.status(500).json({
            success: false,
            message: 'Erro ao processar login'
          });
        }
      }
    );
  } catch (error) {
    console.error('Erro no login:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

// Middleware para verificar token JWT
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Token de acesso requerido'
    });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        message: 'Token inválido'
      });
    }
    req.user = user;
    next();
  });
};

// Rota protegida para verificar token
router.get('/me', authenticateToken, (req, res) => {
  res.json({
    success: true,
    message: 'Usuário autenticado',
    data: {
      user: req.user
    }
  });
});

module.exports = router;
