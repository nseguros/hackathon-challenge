import { useNavigate } from "react-router-dom"
import { Car, Heart, Shield } from "lucide-react"
import { useAuth } from "../contexts/AuthContext"
import Header from "../components/Header"
import Card, { CardHeader, CardContent, CardTitle } from "../components/Card"
import logo from "../assets/logo.png"

const HomePage = () => {
  const { user } = useAuth()
  const navigate = useNavigate()

  const handleSeguroClick = (tipo) => {
    if (tipo === "automovel") {
      navigate("/simulador")
    }
  }

  return (
    <div className="min-h-screen">
      <Header />

      <main className="max-w-4xl mx-auto px-4 py-8">
        {/* Logótipo da NOSSA Seguros */}
        <div className="text-center mb-8">
          <h2 className="text-3xl font-bold text-gray-800 mb-4">Simulador de Produtos</h2>
          <p className="text-lg text-gray-600">Escolha o tipo de seguro que pretende simular.</p>
        </div>

        <div className="grid md:grid-cols-3 gap-6">
          {/* Seguro Automóvel - Ativo */}
          <Card
            className="bg-gradient-to-br from-blue-500 to-blue-600 text-white cursor-pointer hover:from-blue-600 hover:to-blue-700 transition-all duration-200 transform hover:scale-105"
            onClick={() => handleSeguroClick("automovel")}
          >
            <CardHeader className="text-center">
              <Car size={48} className="mx-auto mb-4" />
              <CardTitle className="text-xl text-white">Seguro Automóvel</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-center text-blue-100">Proteja o seu veículo com a nossa cobertura completa</p>
            </CardContent>
          </Card>

          {/* Seguro de Saúde - Inativo */}
          <Card className="bg-gradient-to-br from-gray-400 to-gray-500 text-white opacity-60 cursor-not-allowed">
            <CardHeader className="text-center">
              <Heart size={48} className="mx-auto mb-4" />
              <CardTitle className="text-xl text-white">Seguro de Saúde</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-center text-gray-100">Cuide da sua saúde e da sua família</p>
              <p className="text-center text-sm mt-2 text-gray-200">Em breve disponível</p>
            </CardContent>
          </Card>

          {/* Seguro de Vida - Inativo */}
          <Card className="bg-gradient-to-br from-gray-400 to-gray-500 text-white opacity-60 cursor-not-allowed">
            <CardHeader className="text-center">
              <Shield size={48} className="mx-auto mb-4" />
              <CardTitle className="text-xl text-white">Seguro de Vida</CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-center text-gray-100">Garanta o futuro dos seus entes queridos</p>
              <p className="text-center text-sm mt-2 text-gray-200">Em breve disponível</p>
            </CardContent>
          </Card>
        </div>
      </main>
    </div>
  )
}

export default HomePage
