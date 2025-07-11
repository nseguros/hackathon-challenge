const express = require('express');
const jwt = require('jsonwebtoken');
const db = require('../config/database');
const nodemailer = require('nodemailer');

const router = express.Router();

// Configuração do Nodemailer
let transporter = null;

// Função para criar transporter com verificação
const createTransporter = () => {
  console.log('🔧 Criando transporter de email...');
  console.log('Email usuario:', process.env.GMAIL_USER);
  console.log('Senha definida:', process.env.GMAIL_PASSWORD ? 'Sim' : 'Não');
  
  return nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: process.env.GMAIL_USER,
      pass: process.env.GMAIL_PASSWORD,
    },
  });
};

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

// Matriz de simulação conforme especificado no documento do hackathon
const factorsBase = {
  "Toyota-Corolla": 1.0,
  "Toyota-RAV4": 1.2,
  "Hyundai-Elantra": 1.1,
  "Hyundai-Tucson": 1.3,
};

const factorsEscalao = {
  "A": 1.0,  // 13.376.000,00 AKZ
  "B": 1.1,  // 26.752.000,00 AKZ  
  "C": 1.2,  // 40.128.000,00 AKZ
};

const escalaoValores = {
  "A": "13.376.000,00 AKZ",
  "B": "26.752.000,00 AKZ",
  "C": "40.128.000,00 AKZ",
};

// Valores de cilindrada esperados para cada modelo (conforme tabela oficial)
const cilindradasEsperadas = {
  "Toyota-Corolla": 1601,
  "Toyota-RAV4": 2001,
  "Hyundai-Elantra": 1601,
  "Hyundai-Tucson": 2001,
};

// Validação de intervalos de cilindrada por modelo
const validarCilindrada = (modelo, cilindrada) => {
  const cilindradaNum = parseInt(cilindrada);
  
  switch (modelo) {
    case "Corolla":
      return cilindradaNum >= 1601 && cilindradaNum <= 2000;
    case "RAV4":
      return cilindradaNum >= 2001 && cilindradaNum <= 2500;
    case "Elantra":
      return cilindradaNum >= 1601 && cilindradaNum <= 2000;
    case "Tucson":
      return cilindradaNum >= 2001 && cilindradaNum <= 2500;
    default:
      return false;
  }
};

// Função auxiliar para obter intervalo de cilindrada
function getIntervaloCilindrada(modelo) {
  switch (modelo) {
    case "Corolla": return "Entre 1.601 CC e 2.500 CC";
    case "RAV4": return "Entre 2.001 CC e 2.500 CC";
    case "Elantra": return "Entre 1.601 CC e 2.500 CC";
    case "Tucson": return "Entre 2.001 CC e 2.500 CC";
    default: return "Não definido";
  }
}

/**
 * POST /api/simulacao/calcular
 * Calcula o prêmio da simulação baseado na matriz oficial e salva no banco de dados
 */
router.post('/calcular', authenticateToken, async (req, res) => {
  try {
    const {
      marca,
      modelo,
      cilindrada,
      escalao,
      dataMatricula,
      matricula,
      categoria,
      fraccionamento,
      dataInicio
    } = req.body;

    const userId = req.user.userId;

    // Validação de campos obrigatórios
    const camposObrigatorios = ['marca', 'modelo', 'cilindrada', 'escalao', 'dataMatricula', 'matricula', 'dataInicio'];
    const camposFaltando = camposObrigatorios.filter(campo => !req.body[campo]);
    
    if (camposFaltando.length > 0) {
      return res.status(400).json({
        success: false,
        message: `Campos obrigatórios em falta: ${camposFaltando.join(', ')}`,
        data: null
      });
    }

    // Validar cilindrada para o modelo
    if (!validarCilindrada(modelo, cilindrada)) {
      return res.status(400).json({
        success: false,
        message: `Cilindrada ${cilindrada} CC inválida para o modelo ${modelo}`,
        data: null
      });
    }

    // Buscar factors na matriz
    const chaveBase = `${marca}-${modelo}`;
    const factorBase = factorsBase[chaveBase];
    const factorEscalao = factorsEscalao[escalao];
    const factorFraccionamento = 1.0; // Sempre mensal
    const valorBase = 10000; // Valor fixo conforme especificação

    // Verificar se encontrou os factors
    if (!factorBase) {
      return res.status(400).json({
        success: false,
        message: `Combinação marca/modelo não encontrada: ${chaveBase}`,
        data: null
      });
    }

    if (!factorEscalao) {
      return res.status(400).json({
        success: false,
        message: `Escalão inválido: ${escalao}`,
        data: null
      });
    }

    // Calcular prêmio usando a fórmula oficial
    // Fórmula: Prémio Estimado = Valor Base × Factor Base × Factor Escalão × Factor Fraccionamento
    const premioCalculado = valorBase * factorBase * factorEscalao * factorFraccionamento;

    // Verificar se corresponde aos valores esperados da tabela
    const cilindradaEsperada = cilindradasEsperadas[chaveBase];
    const correspondeTabela = parseInt(cilindrada) === cilindradaEsperada;
    const intervaloCilindrada = getIntervaloCilindrada(modelo);

    // Log para auditoria
    console.log('=== CÁLCULO DO PRÉMIO (BACKEND) ===');
    console.log(`Usuário ID: ${userId}`);
    console.log(`Marca/Modelo: ${chaveBase}`);
    console.log(`Cilindrada: ${cilindrada} CC`);
    console.log(`Escalão: ${escalao} - ${escalaoValores[escalao]}`);
    console.log(`Valor Base: ${valorBase} AKZ`);
    console.log(`Factor Base: ${factorBase}`);
    console.log(`Factor Escalão: ${factorEscalao}`);
    console.log(`Factor Fraccionamento: ${factorFraccionamento}`);
    console.log(`Fórmula: ${valorBase} × ${factorBase} × ${factorEscalao} × ${factorFraccionamento}`);
    console.log(`Prémio Calculado: ${premioCalculado} AKZ/mês`);
    console.log(`Corresponde à tabela: ${correspondeTabela ? 'Sim' : 'Não'}`);

    // Salvar simulação no banco de dados
    const formula = `${valorBase} × ${factorBase} × ${factorEscalao} × ${factorFraccionamento}`;
    
    db.run(`
      INSERT INTO simulacoes (
        user_id, marca, modelo, cilindrada, escalao, escalao_valor, categoria, 
        fraccionamento, data_matricula, matricula, data_inicio, valor_base, 
        factor_base, factor_escalao, factor_fraccionamento, formula, 
        premio_estimado, cilindrada_esperada, corresponde_tabela, intervalo_cilindrada
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `, [
      userId, marca, modelo, parseInt(cilindrada), escalao, escalaoValores[escalao], 
      categoria || 'Ligeiro Particular', fraccionamento || 'Mensal', dataMatricula, 
      matricula, dataInicio, valorBase, factorBase, factorEscalao, 
      factorFraccionamento, formula, premioCalculado, cilindradaEsperada, 
      correspondeTabela, intervaloCilindrada
    ], function(err) {
      if (err) {
        console.error('Erro ao salvar simulação:', err);
        return res.status(500).json({
          success: false,
          message: 'Erro ao salvar simulação no banco de dados',
          data: null
        });
      }

      // Resposta de sucesso com ID da simulação salva
      res.status(200).json({
        success: true,
        message: "Simulação calculada e salva com sucesso",
        data: {
          simulacaoId: this.lastID,
          simulacao: {
            marca,
            modelo,
            cilindrada: parseInt(cilindrada),
            escalao,
            escalaoValor: escalaoValores[escalao],
            categoria: categoria || 'Ligeiro Particular',
            fraccionamento: fraccionamento || 'Mensal',
            dataMatricula,
            matricula,
            dataInicio
          },
          calculo: {
            valorBase,
            factorBase,
            factorEscalao,
            factorFraccionamento,
            formula,
            premioEstimado: premioCalculado,
            moeda: "AKZ",
            periodicidade: "mensal"
          },
          validacao: {
            cilindradaEsperada,
            correspondeTabela,
            intervaloCilindrada
          }
        }
      });

      console.log(`✅ Simulação salva com ID: ${this.lastID} para usuário ${userId}`);
    });

  } catch (error) {
    console.error('Erro ao calcular simulação:', error);
    res.status(500).json({
      success: false,
      message: "Erro interno do servidor ao calcular simulação",
      data: null
    });
  }
});

/**
 * GET /api/simulacao/historico
 * Busca o histórico de simulações do usuário logado
 */
router.get('/historico', authenticateToken, (req, res) => {
  try {
    const userId = req.user.userId;
    const { limit = 10, offset = 0 } = req.query;

    db.all(`
      SELECT * FROM simulacoes 
      WHERE user_id = ? 
      ORDER BY created_at DESC 
      LIMIT ? OFFSET ?
    `, [userId, parseInt(limit), parseInt(offset)], (err, rows) => {
      if (err) {
        console.error('Erro ao buscar histórico:', err);
        return res.status(500).json({
          success: false,
          message: 'Erro ao buscar histórico de simulações'
        });
      }

      // Contar total de simulações do usuário
      db.get('SELECT COUNT(*) as total FROM simulacoes WHERE user_id = ?', [userId], (countErr, countResult) => {
        if (countErr) {
          console.error('Erro ao contar simulações:', countErr);
          return res.status(500).json({
            success: false,
            message: 'Erro ao contar simulações'
          });
        }

        res.json({
          success: true,
          message: 'Histórico recuperado com sucesso',
          data: {
            simulacoes: rows,
            pagination: {
              total: countResult.total,
              limit: parseInt(limit),
              offset: parseInt(offset),
              hasMore: (parseInt(offset) + parseInt(limit)) < countResult.total
            }
          }
        });
      });
    });
  } catch (error) {
    console.error('Erro ao buscar histórico:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

/**
 * GET /api/simulacao/:id
 * Busca uma simulação específica do usuário
 */
router.get('/:id', authenticateToken, (req, res) => {
  try {
    const userId = req.user.userId;
    const simulacaoId = req.params.id;

    db.get(`
      SELECT * FROM simulacoes 
      WHERE id = ? AND user_id = ?
    `, [simulacaoId, userId], (err, row) => {
      if (err) {
        console.error('Erro ao buscar simulação:', err);
        return res.status(500).json({
          success: false,
          message: 'Erro ao buscar simulação'
        });
      }

      if (!row) {
        return res.status(404).json({
          success: false,
          message: 'Simulação não encontrada'
        });
      }

      res.json({
        success: true,
        message: 'Simulação encontrada',
        data: row
      });
    });
  } catch (error) {
    console.error('Erro ao buscar simulação:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

/**
 * DELETE /api/simulacao/:id
 * Deleta uma simulação específica do usuário
 */
router.delete('/:id', authenticateToken, (req, res) => {
  try {
    const userId = req.user.userId;
    const simulacaoId = req.params.id;

    db.run(`
      DELETE FROM simulacoes 
      WHERE id = ? AND user_id = ?
    `, [simulacaoId, userId], function(err) {
      if (err) {
        console.error('Erro ao deletar simulação:', err);
        return res.status(500).json({
          success: false,
          message: 'Erro ao deletar simulação'
        });
      }

      if (this.changes === 0) {
        return res.status(404).json({
          success: false,
          message: 'Simulação não encontrada'
        });
      }

      res.json({
        success: true,
        message: 'Simulação deletada com sucesso'
      });
    });
  } catch (error) {
    console.error('Erro ao deletar simulação:', error);
    res.status(500).json({
      success: false,
      message: 'Erro interno do servidor'
    });
  }
});

/**
 * POST /api/simulacao/enviar-email
 * Envia uma simulação específica por email
 */
router.post('/enviar-email', authenticateToken, async (req, res) => {
  try {
    const { emailDestinatario, conteudo, simulacaoId } = req.body;
    const userId = req.user.userId;

    // Validação de campos obrigatórios
    if (!emailDestinatario || !simulacaoId) {
      return res.status(400).json({
        success: false,
        message: 'Email do destinatário e ID da simulação são obrigatórios'
      });
    }

    // Validar formato do email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(emailDestinatario)) {
      return res.status(400).json({
        success: false,
        message: 'Formato de email inválido'
      });
    }

    // Verificar configuração do email
    if (!process.env.GMAIL_USER || !process.env.GMAIL_PASSWORD) {
      console.error('Variáveis de ambiente GMAIL_USER ou GMAIL_PASSWORD não definidas.');
      console.error('GMAIL_USER:', process.env.GMAIL_USER ? 'DEFINIDO' : 'NÃO DEFINIDO');
      console.error('GMAIL_PASSWORD:', process.env.GMAIL_PASSWORD ? 'DEFINIDO' : 'NÃO DEFINIDO');
      return res.status(500).json({
        success: false,
        message: 'Configuração do servidor de email incompleta'
      });
    }

    console.log('🔐 Verificando credenciais de email...');
    console.log('Email configurado:', process.env.GMAIL_USER ? 'Sim' : 'Não');
    console.log('Senha configurada:', process.env.GMAIL_PASSWORD ? 'Sim' : 'Não');

    // Buscar a simulação no banco de dados
    db.get(`
      SELECT s.*, u.phone as user_phone FROM simulacoes s
      JOIN users u ON s.user_id = u.id
      WHERE s.id = ? AND s.user_id = ?
    `, [simulacaoId, userId], async (err, simulacao) => {
      if (err) {
        console.error('Erro ao buscar simulação:', err);
        return res.status(500).json({
          success: false,
          message: 'Erro ao buscar simulação no banco de dados'
        });
      }

      if (!simulacao) {
        return res.status(404).json({
          success: false,
          message: 'Simulação não encontrada ou não pertence ao usuário'
        });
      }

      // Preparar dados da simulação para o email
      const dataFormatada = new Date(simulacao.created_at).toLocaleDateString('pt-BR');
      const premioFormatado = simulacao.premio_estimado.toLocaleString('pt-BR', {
        style: 'currency',
        currency: 'AOA'
      });

      // Template do email
      const emailHTML = `
        <!DOCTYPE html>
        <html>
        <head>
          <meta charset="UTF-8">
          <title>Simulação de Seguro - HNS</title>
          <style>
            body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
            .container { max-width: 600px; margin: 0 auto; padding: 20px; }
            .header { background-color: #2c3e50; color: white; padding: 20px; text-align: center; }
            .content { background-color: #f8f9fa; padding: 20px; border-radius: 5px; margin: 20px 0; }
            .detail-row { margin: 10px 0; padding: 8px; background-color: white; border-radius: 3px; }
            .label { font-weight: bold; color: #2c3e50; }
            .value { color: #555; }
            .calculation { background-color: #e8f4f8; padding: 15px; border-radius: 5px; margin: 15px 0; }
            .premium { font-size: 24px; font-weight: bold; color: #27ae60; text-align: center; margin: 20px 0; }
            .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }
          </style>
        </head>
        <body>
          <div class="container">
            <div class="header">
              <h1>🚗 Simulação de Seguro Automóvel</h1>
              <p>HNS - Hackathon Nossa Seguros</p>
            </div>
            
            ${conteudo ? `<div class="content"><p>${conteudo.replace(/\n/g, '<br>')}</p></div>` : ''}
            
            <div class="content">
              <h2>📋 Detalhes da Simulação</h2>
              
              <div class="detail-row">
                <span class="label">Marca/Modelo:</span>
                <span class="value">${simulacao.marca} ${simulacao.modelo}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Cilindrada:</span>
                <span class="value">${simulacao.cilindrada} CC</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Escalão:</span>
                <span class="value">${simulacao.escalao} - ${simulacao.escalao_valor}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Categoria:</span>
                <span class="value">${simulacao.categoria}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Fraccionamento:</span>
                <span class="value">${simulacao.fraccionamento}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Matrícula:</span>
                <span class="value">${simulacao.matricula}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Data de Matrícula:</span>
                <span class="value">${new Date(simulacao.data_matricula).toLocaleDateString('pt-BR')}</span>
              </div>
              
              <div class="detail-row">
                <span class="label">Data de Início:</span>
                <span class="value">${new Date(simulacao.data_inicio).toLocaleDateString('pt-BR')}</span>
              </div>
            </div>
            
            <div class="calculation">
              <h3>🧮 Cálculo do Prémio</h3>
              <p><strong>Fórmula:</strong> ${simulacao.formula}</p>
              <p><strong>Valor Base:</strong> ${simulacao.valor_base.toLocaleString('pt-BR')} AKZ</p>
              <p><strong>Factor Base:</strong> ${simulacao.factor_base}</p>
              <p><strong>Factor Escalão:</strong> ${simulacao.factor_escalao}</p>
              <p><strong>Factor Fraccionamento:</strong> ${simulacao.factor_fraccionamento}</p>
            </div>
            
            <div class="premium">
              💰 Prémio Estimado: ${premioFormatado}/mês
            </div>
            
            <div class="content">
              <h3>✅ Validação</h3>
              <p><strong>Intervalo de Cilindrada:</strong> ${simulacao.intervalo_cilindrada}</p>
              <p><strong>Corresponde à Tabela:</strong> ${simulacao.corresponde_tabela ? 'Sim' : 'Não'}</p>
              <p><strong>Cilindrada Esperada:</strong> ${simulacao.cilindrada_esperada} CC</p>
            </div>
            
            <div class="footer">
              <p>Simulação gerada em: ${dataFormatada}</p>
              <p>Este email foi enviado através do sistema HNS</p>
              <p>© 2025 HNS - Hackathon Nossa Seguros</p>
            </div>
          </div>
        </body>
        </html>
      `;

      // Configuração do email
      const mailOptions = {
        from: `HNS Sistema <${process.env.GMAIL_USER}>`,
        to: emailDestinatario,
        subject: `Simulação de Seguro - ${simulacao.marca} ${simulacao.modelo}`,
        html: emailHTML
      };

      try {
        // Criar transporter dinamicamente
        const emailTransporter = createTransporter();
        
        // Verificar se o transporter foi criado corretamente
        console.log('📧 Verificando configuração do transporter...');
        await emailTransporter.verify();
        console.log('✅ Transporter verificado com sucesso');
        
        // Enviar o email
        const result = await emailTransporter.sendMail(mailOptions);
        
        console.log(`✅ Email enviado com sucesso para ${emailDestinatario} - Simulação ID: ${simulacaoId}`);
        console.log('📧 ID da mensagem:', result.messageId);
        
        // Resposta de sucesso
        res.json({
          success: true,
          message: 'Email enviado com sucesso',
          data: {
            emailDestinatario,
            simulacaoId,
            dataEnvio: new Date().toISOString()
          }
        });

      } catch (emailError) {
        console.error('Erro ao enviar email:', emailError);
        const errorMessage = emailError instanceof Error ? emailError.message : 'Falha ao enviar o email';
        
        res.status(500).json({
          success: false,
          message: `Falha ao enviar o email. Detalhes: ${errorMessage}`
        });
      }
    });

  } catch (error) {
    console.error('Erro no processamento do envio de email:', error);
    const errorMessage = error instanceof Error ? error.message : 'Erro interno do servidor';
    
    res.status(500).json({
      success: false,
      message: `Erro interno do servidor. Detalhes: ${errorMessage}`
    });
  }
});

module.exports = router;
