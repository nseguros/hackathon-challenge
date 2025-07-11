"use client"

import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "../contexts/AuthContext"
import Header from "../components/Header"
import Card, { CardHeader, CardContent, CardTitle } from "../components/Card"

const marcasModelos = {
  Toyota: ["Corolla", "RAV4"],
  Hyundai: ["Elantra", "Tucson"],
}

const cilindradas = {
  Corolla: { valor: 1601, intervalo: "Entre 1.601 CC e 2.500 CC" },
  RAV4: { valor: 2001, intervalo: "Entre 2.001 CC e 2.500 CC" },
  Elantra: { valor: 1601, intervalo: "Entre 1.601 CC e 2.000 CC" },
  Tucson: { valor: 2001, intervalo: "Entre 2.001 CC e 2.500 CC" },
}

const escaloes = [
  { label: "A - 13.376.000,00 AKZ", value: "A" },
  { label: "B - 26.752.000,00 AKZ", value: "B" },
  { label: "C - 40.128.000,00 AKZ", value: "C" },
]

const SimuladorPage = () => {
  const navigate = useNavigate()
  const { user } = useAuth()
  
  const [formData, setFormData] = useState({
    marca: "",
    modelo: "",
    categoria: "Ligeiro Particular",
    cilindrada: "",
    dataMatricula: "",
    matricula: "",
    escalao: "",
    fraccionamento: "Mensal",
    dataInicio: "",
  })
  const [loading, setLoading] = useState(false)
  const [cilindradaError, setCilindradaError] = useState("")
  const [showConfirmModal, setShowConfirmModal] = useState(false)

  const handleMarcaChange = (marca) => {
    setFormData({
      ...formData,
      marca,
      modelo: "",
      cilindrada: "",
    })
  }

  const handleModeloChange = (modelo) => {
    const cilindradaSugerida = modelo ? cilindradas[modelo]?.valor || "" : ""
    setFormData({
      ...formData,
      modelo,
      cilindrada: cilindradaSugerida,
    })
    setCilindradaError("")
  }

  const validarCilindrada = (modelo, cilindrada) => {
    if (!modelo || !cilindrada) return true
    
    const cilindradaNum = parseInt(cilindrada)
    const config = cilindradas[modelo]
    
    if (!config) return false
    
    // Validar intervalos conforme a tabela
    switch (modelo) {
      case "Corolla":
        return cilindradaNum >= 1601 && cilindradaNum <= 2000
      case "RAV4":
        return cilindradaNum >= 2001 && cilindradaNum <= 2500  // Entre 1.601 CC e 2.500 CC
      case "Elantra":
        return cilindradaNum >= 1601 && cilindradaNum <= 2000  // Entre 1.601 CC e 2.000 CC
      case "Tucson":
        return cilindradaNum >= 2001 && cilindradaNum <= 2500
      default:
        return false
    }
  }

  const handleCilindradaChange = (value) => {
    setFormData({
      ...formData,
      cilindrada: value,
    })
    
    if (value && formData.modelo) {
      const isValid = validarCilindrada(formData.modelo, value)
      if (!isValid) {
        setCilindradaError(`Cilindrada deve estar no intervalo: ${cilindradas[formData.modelo]?.intervalo}`)
      } else {
        setCilindradaError("")
      }
    } else {
      setCilindradaError("")
    }
  }

  const handleInputChange = (field, value) => {
    setFormData({
      ...formData,
      [field]: value,
    })
  }

  const handleSubmit = async (e) => {
    e.preventDefault()

    const requiredFields = ["marca", "modelo", "cilindrada", "dataMatricula", "matricula", "escalao", "dataInicio"]
    const isValid = requiredFields.every((field) => formData[field])

    if (!isValid) {
      alert("Por favor, preencha todos os campos obrigatórios")
      return
    }

    if (cilindradaError) {
      alert("Por favor, corrija a cilindrada antes de continuar")
      return
    }

    if (!validarCilindrada(formData.modelo, formData.cilindrada)) {
      alert(`Cilindrada inválida para o modelo ${formData.modelo}. ${cilindradas[formData.modelo]?.intervalo}`)
      return
    }

    // Mostrar modal de confirmação em vez de enviar diretamente
    setShowConfirmModal(true)
  }

  const handleConfirmarEnvio = async () => {
    setShowConfirmModal(false)
    setLoading(true)

    try {
      // Obter token do localStorage
      const token = localStorage.getItem("token")
      
      // Enviar dados para o backend para calcular o prêmio
      const response = await fetch("http://localhost:3000/api/simulacao/calcular", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
        body: JSON.stringify({
          marca: formData.marca,
          modelo: formData.modelo,
          cilindrada: formData.cilindrada,
          escalao: formData.escalao,
          dataMatricula: formData.dataMatricula,
          matricula: formData.matricula,
          categoria: formData.categoria,
          fraccionamento: formData.fraccionamento,
          dataInicio: formData.dataInicio,
        }),
      })

      const result = await response.json()

      if (!response.ok) {
        // Se erro de autenticação, redirecionar para login
        if (response.status === 401) {
          alert("Sessão expirada. Redirecionando para o login...")
          localStorage.removeItem("token")
          localStorage.removeItem("user")
          navigate("/login")
          return
        }
        throw new Error(result.message || "Erro ao calcular simulação")
      }

      if (result.success) {
        // Salvar resultado completo do backend no localStorage
        localStorage.setItem("simulacao", JSON.stringify(result.data))
        navigate("/resultado")
      } else {
        throw new Error(result.message || "Erro no cálculo da simulação")
      }
    } catch (error) {
      console.error("Erro ao processar simulação:", error)
      alert(`Erro ao processar simulação: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  const handleVoltarFormulario = () => {
    setShowConfirmModal(false)
  }

  const getEscalaoLabel = (value) => {
    const escalao = escaloes.find(e => e.value === value)
    return escalao ? escalao.label : value
  }

  return (
    <div className="min-h-screen">
      <Header />

      <main className="max-w-2xl mx-auto px-4 py-8">
        <Card>
          <CardHeader>
            <CardTitle className="text-2xl text-center text-gray-800">Simulação de Seguro Automóvel</CardTitle>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit} className="space-y-6">
              <div className="grid md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="block text-sm font-medium text-gray-700">Marca *</label>
                  <select value={formData.marca} onChange={(e) => handleMarcaChange(e.target.value)} className="select">
                    <option value="">Selecione a marca</option>
                    <option value="Toyota">Toyota</option>
                    <option value="Hyundai">Hyundai</option>
                  </select>
                </div>

                <div className="space-y-2">
                  <label className="block text-sm font-medium text-gray-700">Modelo *</label>
                  <select
                    value={formData.modelo}
                    onChange={(e) => handleModeloChange(e.target.value)}
                    disabled={!formData.marca}
                    className="select"
                  >
                    <option value="">Selecione o modelo</option>
                    {formData.marca &&
                      marcasModelos[formData.marca]?.map((modelo) => (
                        <option key={modelo} value={modelo}>
                          {modelo}
                        </option>
                      ))}
                  </select>
                </div>
              </div>

              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">Categoria</label>
                <input value={formData.categoria} disabled className="input bg-gray-100" />
              </div>

              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">Cilindrada (CC) *</label>
                <input 
                  type="number"
                  placeholder={formData.modelo ? `Ex: ${cilindradas[formData.modelo]?.valor}` : "Ex: 1600"}
                  value={formData.cilindrada}
                  onChange={(e) => handleCilindradaChange(e.target.value)}
                  disabled={!formData.modelo}
                  className={`input ${cilindradaError ? 'border-red-500 focus:ring-red-500' : ''} ${!formData.modelo ? 'bg-gray-100' : ''}`}
                />
                {formData.modelo && (
                  <p className="text-xs text-gray-500">
                    Intervalo permitido: {cilindradas[formData.modelo]?.intervalo}
                  </p>
                )}
                {cilindradaError && (
                  <p className="text-red-600 text-xs mt-1">
                    {cilindradaError}
                  </p>
                )}
              </div>

              <div className="grid md:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <label className="block text-sm font-medium text-gray-700">Data da 1.ª matrícula *</label>
                  <input
                    type="date"
                    value={formData.dataMatricula}
                    onChange={(e) => handleInputChange("dataMatricula", e.target.value)}
                    className="input"
                  />
                </div>

                <div className="space-y-2">
                  <label className="block text-sm font-medium text-gray-700">Matrícula *</label>
                  <input
                    type="text"
                    placeholder="Ex: LD-00-00-AA"
                    value={formData.matricula}
                    onChange={(e) => handleInputChange("matricula", e.target.value)}
                    className="input"
                  />
                </div>
              </div>

              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">Escalão de capital *</label>
                <select
                  value={formData.escalao}
                  onChange={(e) => handleInputChange("escalao", e.target.value)}
                  className="select"
                >
                  <option value="">Selecione o escalão</option>
                  {escaloes.map((escalao) => (
                    <option key={escalao.value} value={escalao.value}>
                      {escalao.label}
                    </option>
                  ))}
                </select>
              </div>

              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">Fraccionamento</label>
                <input value={formData.fraccionamento} disabled className="input bg-gray-100" />
              </div>

              <div className="space-y-2">
                <label className="block text-sm font-medium text-gray-700">Data de início *</label>
                <input
                  type="date"
                  value={formData.dataInicio}
                  onChange={(e) => handleInputChange("dataInicio", e.target.value)}
                  className="input"
                />
              </div>

              <button
                type="submit"
                className={`btn btn-primary w-full py-3 ${loading ? "btn-disabled" : ""}`}
                disabled={loading}
              >
                {loading ? "Simulando..." : "Simular"}
              </button>
            </form>
          </CardContent>
        </Card>
      </main>

      {/* Modal de Confirmação */}
      {showConfirmModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg max-w-md w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6">
              <h2 className="text-xl font-semibold text-gray-800 mb-4">Confirmar Dados da Simulação</h2>
              
              <div className="space-y-3 mb-6">
                <div className="bg-gray-50 p-3 rounded">
                  <h3 className="font-medium text-gray-700 mb-2">Informações do Veículo</h3>
                  <div className="grid grid-cols-2 gap-2 text-sm">
                    <div>
                      <span className="font-medium">Marca:</span> {formData.marca}
                    </div>
                    <div>
                      <span className="font-medium">Modelo:</span> {formData.modelo}
                    </div>
                    <div>
                      <span className="font-medium">Cilindrada:</span> {formData.cilindrada} CC
                    </div>
                    <div>
                      <span className="font-medium">Categoria:</span> {formData.categoria}
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 p-3 rounded">
                  <h3 className="font-medium text-gray-700 mb-2">Detalhes da Matrícula</h3>
                  <div className="grid grid-cols-1 gap-2 text-sm">
                    <div>
                      <span className="font-medium">Matrícula:</span> {formData.matricula}
                    </div>
                    <div>
                      <span className="font-medium">Data da 1.ª matrícula:</span> {new Date(formData.dataMatricula).toLocaleDateString('pt-PT')}
                    </div>
                  </div>
                </div>

                <div className="bg-gray-50 p-3 rounded">
                  <h3 className="font-medium text-gray-700 mb-2">Configurações do Seguro</h3>
                  <div className="grid grid-cols-1 gap-2 text-sm">
                    <div>
                      <span className="font-medium">Escalão:</span> {getEscalaoLabel(formData.escalao)}
                    </div>
                    <div>
                      <span className="font-medium">Fraccionamento:</span> {formData.fraccionamento}
                    </div>
                    <div>
                      <span className="font-medium">Data de início:</span> {new Date(formData.dataInicio).toLocaleDateString('pt-PT')}
                    </div>
                  </div>
                </div>
              </div>

              <div className="flex gap-3">
                <button
                  onClick={handleVoltarFormulario}
                  className="btn btn-secondary flex-1"
                  disabled={loading}
                >
                  Voltar ao Formulário
                </button>
                <button
                  onClick={handleConfirmarEnvio}
                  className={`btn btn-primary flex-1 ${loading ? "btn-disabled" : ""}`}
                  disabled={loading}
                >
                  {loading ? "Calculando..." : "Confirmar e Calcular"}
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

export default SimuladorPage
