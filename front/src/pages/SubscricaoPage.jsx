"use client"

import { useState, useEffect } from "react"
import { useNavigate } from "react-router-dom"
import { CheckCircle, CreditCard } from "lucide-react"
import { useAuth } from "../contexts/AuthContext"
import Header from "../components/Header"
import Card, { CardHeader, CardContent, CardTitle } from "../components/Card"

const SubscricaoPage = () => {
  const [simulacaoData, setSimulacaoData] = useState(null)
  const [formData, setFormData] = useState({
    nome: "",
    nif: "",
    telefone: "",
    email: "",
    aceitaTermos: false,
    metodoPagamento: ""
  })
  const [loading, setLoading] = useState(false)
  const [subscricaoCompleta, setSubscricaoCompleta] = useState(false)
  const [errors, setErrors] = useState({})
  const navigate = useNavigate()
  const { user } = useAuth()

  const metodosPagamento = [
    { value: "transferencia", label: "Transferência" },
    { value: "multicaixa", label: "Referência Multicaixa" },
    { value: "baipaga", label: "BAI Paga" }
  ]

  useEffect(() => {
    const simulacaoData = localStorage.getItem("simulacao")

    if (!simulacaoData) {
      navigate("/home")
      return
    }

    try {
      const dadosCompletos = JSON.parse(simulacaoData)
      setSimulacaoData(dadosCompletos)
      
      // Pré-preencher telefone se disponível do contexto de autenticação
      if (user && user.phone) {
        setFormData(prev => ({
          ...prev,
          telefone: user.phone
        }))
      }
    } catch (error) {
      console.error('Erro ao processar dados da simulação:', error)
      navigate("/home")
    }
  }, [navigate, user])

  const handleInputChange = (field, value) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }))
    
    // Limpar erro do campo quando usuário começar a digitar
    if (errors[field]) {
      setErrors(prev => ({
        ...prev,
        [field]: ""
      }))
    }
  }

  const validateForm = () => {
    const newErrors = {}

    if (!formData.nome.trim()) {
      newErrors.nome = "Nome é obrigatório"
    }

    if (!formData.nif.trim()) {
      newErrors.nif = "NIF é obrigatório"
    } else if (!/^\d{9}$/.test(formData.nif.replace(/\s/g, ''))) {
      newErrors.nif = "NIF deve conter 9 dígitos"
    }

    if (!formData.telefone.trim()) {
      newErrors.telefone = "Telefone é obrigatório"
    } else if (!/^(\+244|244)?[9][0-9]{8}$/.test(formData.telefone.replace(/\s/g, ''))) {
      newErrors.telefone = "Formato inválido (ex: +244900000000 ou 900000000)"
    }

    if (!formData.email.trim()) {
      newErrors.email = "Email é obrigatório"
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = "Formato de email inválido"
    }

    if (!formData.aceitaTermos) {
      newErrors.aceitaTermos = "Deve aceitar os Termos e Condições"
    }

    if (!formData.metodoPagamento) {
      newErrors.metodoPagamento = "Selecione um método de pagamento"
    }

    setErrors(newErrors)
    return Object.keys(newErrors).length === 0
  }

  const handleConfirmarSubscricao = async (e) => {
    e.preventDefault()

    if (!validateForm()) {
      return
    }

    setLoading(true)

    try {
      // Simular processamento de pagamento (mocked)
      await new Promise(resolve => setTimeout(resolve, 2000))

      // Marcar subscrição como completa
      setSubscricaoCompleta(true)
      
      console.log("✅ Subscrição processada com sucesso:", {
        simulacao: simulacaoData,
        dadosSubscricao: formData
      })

    } catch (error) {
      console.error("Erro ao processar subscrição:", error)
      alert("Erro ao processar subscrição. Tente novamente.")
    } finally {
      setLoading(false)
    }
  }

  const handleVoltarInicio = () => {
    // Limpar dados da simulação
    localStorage.removeItem("simulacao")
    navigate("/home")
  }

  if (!simulacaoData) return null

  const { simulacao, calculo } = simulacaoData

  if (subscricaoCompleta) {
    return (
      <div className="min-h-screen">
        <Header />
        <main className="max-w-2xl mx-auto px-4 py-8">
          <Card>
            <CardContent className="text-center space-y-6 py-12">
              <div className="flex justify-center">
                <CheckCircle className="w-24 h-24 text-green-500" />
              </div>
              <h2 className="text-2xl font-semibold text-green-600">
                Subscrição Concluída com Sucesso!
              </h2>
              <p className="text-gray-600 text-lg">
                A sua subscrição foi concluída com sucesso. Receberá a apólice por e-mail nas próximas horas.
              </p>
              <div className="bg-green-50 p-4 rounded-lg">
                <h3 className="font-semibold text-green-700 mb-2">Resumo da Subscrição:</h3>
                <div className="text-sm text-green-600 space-y-1">
                  <div><strong>Veículo:</strong> {simulacao.marca} {simulacao.modelo}</div>
                  <div><strong>Prémio:</strong> {calculo.premioEstimado.toLocaleString("pt-AO")} AKZ/mês</div>
                  <div><strong>Método de Pagamento:</strong> {metodosPagamento.find(m => m.value === formData.metodoPagamento)?.label}</div>
                </div>
              </div>
              <button
                onClick={handleVoltarInicio}
                className="btn btn-primary px-8 py-3"
              >
                Voltar à Página Inicial
              </button>
            </CardContent>
          </Card>
        </main>
      </div>
    )
  }

  return (
    <div className="min-h-screen">
      <Header />

      <main className="max-w-2xl mx-auto px-4 py-8">
        <Card>
          <CardHeader>
            <CardTitle className="text-2xl text-center text-gray-800">
              Subscrição de Seguro Automóvel
            </CardTitle>
            <div className="text-center text-gray-600">
              Complete os seus dados para finalizar a subscrição
            </div>
          </CardHeader>
          <CardContent>
            {/* Resumo da simulação */}
            <div className="bg-blue-50 p-4 rounded-lg mb-6">
              <h3 className="font-semibold text-blue-700 mb-2">Resumo do Seguro:</h3>
              <div className="text-sm text-blue-600 space-y-1">
                <div><strong>Veículo:</strong> {simulacao.marca} {simulacao.modelo} ({simulacao.cilindrada} CC)</div>
                <div><strong>Escalão:</strong> {simulacao.escalao} - {simulacao.escalaoValor}</div>
                <div><strong>Prémio Mensal:</strong> {calculo.premioEstimado.toLocaleString("pt-AO")} AKZ</div>
              </div>
            </div>

            <form onSubmit={handleConfirmarSubscricao} className="space-y-6">
              {/* Nome do Tomador */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">
                  Nome do Tomador do Seguro *
                </label>
                <input
                  type="text"
                  placeholder="Nome completo"
                  value={formData.nome}
                  onChange={(e) => handleInputChange("nome", e.target.value)}
                  className={`input ${errors.nome ? 'border-red-500' : ''}`}
                />
                {errors.nome && <p className="text-red-600 text-xs">{errors.nome}</p>}
              </div>

              {/* NIF */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">
                  NIF do Tomador do Seguro *
                </label>
                <input
                  type="text"
                  placeholder="000000000"
                  value={formData.nif}
                  onChange={(e) => handleInputChange("nif", e.target.value)}
                  className={`input ${errors.nif ? 'border-red-500' : ''}`}
                />
                {errors.nif && <p className="text-red-600 text-xs">{errors.nif}</p>}
              </div>

              {/* Telefone */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">
                  Número de Telefone *
                </label>
                <input
                  type="tel"
                  placeholder="+244900000000 ou 900000000"
                  value={formData.telefone}
                  onChange={(e) => handleInputChange("telefone", e.target.value)}
                  className={`input ${errors.telefone ? 'border-red-500' : ''}`}
                />
                {errors.telefone && <p className="text-red-600 text-xs">{errors.telefone}</p>}
              </div>

              {/* Email */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">
                  E-mail do Tomador do Seguro *
                </label>
                <input
                  type="email"
                  placeholder="exemplo@email.com"
                  value={formData.email}
                  onChange={(e) => handleInputChange("email", e.target.value)}
                  className={`input ${errors.email ? 'border-red-500' : ''}`}
                />
                {errors.email && <p className="text-red-600 text-xs">{errors.email}</p>}
              </div>

              {/* Método de Pagamento */}
              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">
                  Método de Pagamento *
                </label>
                <select
                  value={formData.metodoPagamento}
                  onChange={(e) => handleInputChange("metodoPagamento", e.target.value)}
                  className={`select ${errors.metodoPagamento ? 'border-red-500' : ''}`}
                >
                  <option value="">Selecione o método de pagamento</option>
                  {metodosPagamento.map((metodo) => (
                    <option key={metodo.value} value={metodo.value}>
                      {metodo.label}
                    </option>
                  ))}
                </select>
                {errors.metodoPagamento && <p className="text-red-600 text-xs">{errors.metodoPagamento}</p>}
              </div>

              {/* Termos e Condições */}
              <div className="space-y-2">
                <div className="flex items-start space-x-3">
                  <input
                    type="checkbox"
                    id="termos"
                    checked={formData.aceitaTermos}
                    onChange={(e) => handleInputChange("aceitaTermos", e.target.checked)}
                    className="mt-1"
                  />
                  <label htmlFor="termos" className="text-sm text-gray-700">
                    Aceito os{" "}
                    <a href="#" className="text-blue-600 hover:underline">
                      Termos e Condições
                    </a>{" "}
                    do seguro automóvel *
                  </label>
                </div>
                {errors.aceitaTermos && <p className="text-red-600 text-xs">{errors.aceitaTermos}</p>}
              </div>

              {/* Botões */}
              <div className="flex gap-3 pt-4">
                <button
                  type="button"
                  onClick={() => navigate("/resultado")}
                  className="btn btn-secondary flex-1"
                  disabled={loading}
                >
                  Voltar
                </button>
                <button
                  type="submit"
                  className={`btn btn-primary flex-1 flex items-center justify-center ${loading ? "btn-disabled" : ""}`}
                  disabled={loading}
                >
                  <CreditCard className="w-4 h-4 mr-2" />
                  {loading ? "Processando..." : "Confirmar Subscrição"}
                </button>
              </div>
            </form>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

export default SubscricaoPage
