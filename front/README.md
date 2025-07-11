# 🚗 NOSSA Seguros - Simulador de Seguros Automóveis
**Hackathon Revela-te! 2025**

## 📋 Sobre o Projeto

Simulador web moderno para seguros automóveis desenvolvido com **React + Vite**. Permite aos clientes simular, calcular e subscrever seguros de forma rápida e intuitiva.

## 🎯 Funcionalidades

- **Autenticação** com validação em tempo real
- **Simulação de Seguro** com formulário completo e modal de confirmação
- **Cálculo de Prémio** conforme matriz oficial
- **Envio por Email** via backend integrado
- **Subscrição Completa** com dados pessoais e métodos de pagamento

## 🛠️ Tecnologias

- React 18 + Vite 5 + Tailwind CSS
- React Router + Context API
- Integração Backend com APIs REST

## 🚀 Como Executar

```bash
# Instalar dependências
npm install

# Executar aplicação
npm run dev

# Acessar em: http://localhost:5173
```

## 🎮 Fluxo de Uso

1. **Login**: Telefone (9XXXXXXXX) + Senha (min. 6 chars + 1 especial)
2. **Home**: Clicar em "Automóvel" para iniciar simulação
3. **Simulação**: Preencher dados → Confirmar no modal
4. **Resultado**: Ver prémio → Enviar email → Aderir
5. **Subscrição**: Dados pessoais → Método pagamento → Confirmar

## 🧮 Matriz de Cálculo

| Marca | Modelo | Escalão | Prémio Mensal |
|-------|--------|---------|---------------|
| Toyota | Corolla | A | 10.000 AKZ |
| Toyota | RAV4 | B | 13.200 AKZ |
| Hyundai | Elantra | B | 12.100 AKZ |
| Hyundai | Tucson | C | 15.600 AKZ |

## 📧 APIs Backend

```bash
POST /api/auth/login           # Autenticação
POST /api/simulacao/calcular   # Cálculo do prémio
POST /api/simulacao/enviar-email # Envio por email
```

---

**🚀 Aplicação completa e pronta para demonstração!**
