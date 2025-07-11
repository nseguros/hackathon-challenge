const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Caminho para o arquivo do banco de dados
const dbPath = path.join(__dirname, '..', 'database.sqlite');

// Criar conexão com o banco
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('❌ Erro ao conectar com o banco de dados:', err.message);
  } else {
    console.log('✅ Conectado ao banco de dados SQLite');
  }
});

// Criar tabelas se não existirem
db.serialize(() => {
  // Tabela de usuários
  db.run(`
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      phone TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  `, (err) => {
    if (err) {
      console.error('❌ Erro ao criar tabela users:', err.message);
    } else {
      console.log('✅ Tabela users criada/verificada com sucesso');
    }
  });

  // Tabela de sessões (opcional para controle de sessões)
  db.run(`
    CREATE TABLE IF NOT EXISTS sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      token TEXT NOT NULL,
      expires_at DATETIME NOT NULL,
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id)
    )
  `, (err) => {
    if (err) {
      console.error('❌ Erro ao criar tabela sessions:', err.message);
    } else {
      console.log('✅ Tabela sessions criada/verificada com sucesso');
    }
  });

  // Tabela de simulações
  db.run(`
    CREATE TABLE IF NOT EXISTS simulacoes (
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
    )
  `, (err) => {
    if (err) {
      console.error('❌ Erro ao criar tabela simulacoes:', err.message);
    } else {
      console.log('✅ Tabela simulacoes criada/verificada com sucesso');
    }
  });
});

module.exports = db;
