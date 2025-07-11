"use client"

import { useState, useEffect } from "react"
import { useNavigate } from "react-router-dom"
import { Mail, CheckCircle } from "lucide-react"
import { useAuth } from "../contexts/AuthContext"
import Header from "../components/Header"
import Card, { CardHeader, CardContent, CardTitle } from "../components/Card"

const ResultadoPage = () => {
  const [simulacaoData, setSimulacaoData] = useState(null)
  const [email, setEmail] = useState("")
  const [enviado, setEnviado] = useState(false)
  const [loading, setLoading] = useState(false)
  const [simulacaoId, setSimulacaoId] = useState(null)
  const navigate = useNavigate()
  const { user } = useAuth()

  useEffect(() => {
    const simulacaoData = localStorage.getItem("simulacao")

    if (!simulacaoData) {
      navigate("/home")
      return
    }

    try {
      const dadosCompletos = JSON.parse(simulacaoData)
      setSimulacaoData(dadosCompletos)
      
      // Capturar o ID da simulação se disponível
      if (dadosCompletos.simulacaoId) {
        setSimulacaoId(dadosCompletos.simulacaoId)
      }
      
      // Log detalhado dos dados recebidos do backend
      console.log('=== DADOS DA SIMULAÇÃO (FRONTEND) ===')
      console.log('Simulação:', dadosCompletos.simulacao)
      console.log('Cálculo:', dadosCompletos.calculo)
      console.log('Validação:', dadosCompletos.validacao)
      console.log('Simulação ID:', dadosCompletos.simulacaoId)
      console.log('Prêmio Estimado:', dadosCompletos.calculo?.premioEstimado, 'AKZ/mês')
      
    } catch (error) {
      console.error('Erro ao processar dados da simulação:', error)
      navigate("/home")
    }
  }, [navigate])

  const handleEnviarEmail = async (e) => {
    e.preventDefault()
    if (!email) return

    // Verificar se temos o ID da simulação
    if (!simulacaoId) {
      alert("Erro: ID da simulação não encontrado. Tente fazer uma nova simulação.")
      return
    }

    setLoading(true)

    try {
      // Obter token do localStorage
      const token = localStorage.getItem("token")

      if (!token) {
        alert("Sessão expirada. Redirecionando para o login...")
        navigate("/login")
        return
      }

      // Enviar email através da API
      const response = await fetch("http://localhost:3000/api/simulacao/enviar-email", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
        },
        body: JSON.stringify({
          emailDestinatario: email,
          simulacaoId: simulacaoId,
          conteudo: `Olá,\n\nSegue em anexo a simulação do seu seguro automóvel realizada através do sistema HNS.\n\nAtenciosamente,\nEquipe HNS`
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
        throw new Error(result.message || "Erro ao enviar email")
      }

      if (result.success) {
        setEnviado(true)
        console.log("✅ Email enviado com sucesso:", result.data)
      } else {
        throw new Error(result.message || "Erro no envio do email")
      }
    } catch (error) {
      console.error("Erro ao enviar email:", error)
      alert(`Erro ao enviar email: ${error.message}`)
    } finally {
      setLoading(false)
    }
  }

  const handleSair = () => {
    localStorage.removeItem("simulacao")
    navigate("/home")
  }

  if (!simulacaoData) return null

  const { simulacao, calculo } = simulacaoData

  return (
    <div className="min-h-screen">
      <Header />

      <main className="max-w-2xl mx-auto px-4 py-8">
        <Card>
          <CardHeader>
            <CardTitle className="text-2xl text-center text-gray-800">
              Resultado da Simulação de Seguro Automóvel
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            {/* Resultado do prémio */}
            <div className="text-center space-y-4">
              <p className="text-lg text-gray-700">
                O seu prémio está estimado em <span className="font-bold text-blue-600">{calculo.premioEstimado.toLocaleString("pt-AO")} {calculo.moeda}/{calculo.periodicidade}</span>. <span className="font-semibold text-gray-800">Adira já, em 3 minutos, e evite constrangimentos.</span>
              </p>
              
              {/* Botão Aderir */}
              <div className="mt-6">
                <button
                  onClick={() => navigate("/subscricao")}
                  className="btn btn-primary px-8 py-3 text-lg font-semibold"
                >
                  Aderir
                </button>
              </div>
            </div>

            {!enviado ? (
              <div className="space-y-4">
                <p className="text-center text-gray-600">Envie a simulação por e-mail.</p>

                <form onSubmit={handleEnviarEmail} className="space-y-4">
                  <div className="space-y-2">
                    <label className="block text-sm font-medium text-gray-700">E-mail do destinatário</label>
                    <input
                      type="email"
                      placeholder="exemplo@email.com"
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      required
                      className="input"
                    />
                  </div>

                  <div className="flex gap-3">
                    <button
                      type="submit"
                      className={`btn btn-primary flex-1 flex items-center justify-center ${loading || !email ? "btn-disabled" : ""}`}
                      disabled={loading || !email}
                    >
                      <Mail className="w-4 h-4 mr-2" />
                      {loading ? "Enviando..." : "Enviar"}
                    </button>

                    <button type="button" onClick={handleSair} className="btn btn-secondary flex-1">
                      Sair
                    </button>
                  </div>
                </form>
              </div>
            ) : (
              <div className="text-center space-y-4">
                <div className="flex justify-center">
                  <CheckCircle className="w-16 h-16 text-green-500" />
                </div>
                <h3 className="text-xl font-semibold text-green-600">Simulação enviada com sucesso!</h3>
                <p className="text-gray-600">A simulação foi enviada para {email}</p>
                <button onClick={handleSair} className="btn btn-primary">
                  Voltar ao início
                </button>
              </div>
            )}
            {/* Resumo da simulação */}
            <div className="bg-gray-50 p-4 rounded-lg">
              <h3 className="font-semibold text-gray-700 mb-3">Resumo da Simulação:</h3>
              <div className="grid grid-cols-2 gap-2 text-sm">
                <div>
                  <span className="font-medium">Marca:</span> {simulacao.marca}
                </div>
                <div>
                  <span className="font-medium">Modelo:</span> {simulacao.modelo}
                </div>
                <div>
                  <span className="font-medium">Cilindrada:</span> {simulacao.cilindrada} CC
                </div>
                <div>
                  <span className="font-medium">Escalão:</span> {simulacao.escalao} - {simulacao.escalaoValor}
                </div>
                <div>
                  <span className="font-medium">Matrícula:</span> {simulacao.matricula}
                </div>
                <div>
                  <span className="font-medium">Categoria:</span> {simulacao.categoria}
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  )
}

export default ResultadoPage
