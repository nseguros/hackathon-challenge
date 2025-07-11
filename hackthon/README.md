# 📚 Hackthon Backend - Nossa Seguros

Projeto backend modular em Java com Spring Boot, criado para o hackathon da Nossa Seguros. Fornece funcionalidades de autenticação, gestão de usuários e simulação de seguros automóveis.

---

## 🔹 Tecnologias Utilizadas

* Java 21
* Spring Boot 3.5
* Maven
* Docker / Docker Compose
* JWT + RSA
* Postgres

---

## 🚀 Como Rodar o Projeto

### Requisitos:

* Java 17+
* Maven 3.8+
* Docker & Docker Compose

### Passos:

```bash
# 1. Subir containers de dependência (Mongo, etc)
docker-compose up -d

# 2. Compilar o projeto
mvn clean install

# 3. Iniciar o backend
mvn spring-boot:run
```

A aplicação estará disponível em:

```
http://localhost:9850/api/v1
```

---

## 📁 Estrutura de Pastas

### `common/`

Componentes compartilhados:

* `configs/`: JWT, RSA, OpenAPI, CORS, etc.
* `dto/`: respostas comuns (`ApiResponse`).
* `exceptions/`: sistema de exceções customizadas e handler global.

### `helpers/identification`

Validação e identificação de entidades com controllers e DTOs auxiliares.

### `infra/http`

Controladores HTTP expostos:

* `AuthController`
* `InsuranceController`
* `UserController`

### `modules/`

#### `auth/`

* Gerenciamento de autenticação e redefinição de senha.

#### `users/`

* Gestão de usuários, roles e permissões.
* Repositórios e serviços.

#### `insurance/`

* Entidade de simulação de seguros.
* Regras de negócio e reposição inicial (`SeederInsurance`).

### `resources/`

* `certs/`: chaves RSA (JWT).
* `application.yml`: configurações de ambiente.

---

## 🔒 Segurança e JWT

* As requisições protegidas utilizam JWT.
* As chaves estão localizadas em: `src/main/resources/certs/`

---

## 📄 Documentação

* Documentação automática ativada com OpenAPI.
* Swagger está habilitado via `OpenApiConfig`.

____
3.1. Use o user Padrão:

👤 Utilizador Padrão e Registo
A aplicação dispõe de um utilizador padrão para testes iniciais:

📧 E-mail:    client@nossa.ao  
📱 Telefone:  923000000  
🔐 Senha:     password

---

## 💡 Contato

Desenvolvido por: \[EDGAR A. DIKENGE]

LinkedIn: \[[Edgar Almeida Dikenge](https://linkedin.com/in/edgar-almeida-dikenge-199330261)]
Email: \[[dikengeofficial@gmail.com](dikengeofficial@gmail.com)]
