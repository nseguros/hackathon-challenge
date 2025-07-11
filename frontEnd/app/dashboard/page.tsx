"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import {
  Heart,
  Cross,
  Stethoscope,
  GraduationCap,
  User,
  FileText,
  CreditCard,
  Settings,
  LogOut,
  Bell,
  Shield,
  Calculator,
} from "lucide-react"

interface UserData {
  name: string
  email: string
  phone: string
  policies: Array<{
    id: string
    type: string
    status: string
    premium: number
    nextPayment: string
  }>
}

export default function DashboardPage() {
  const [userData, setUserData] = useState<UserData | null>(null)
  const [isLoading, setIsLoading] = useState(true)
  const router = useRouter()

  const handleSimular = () => {
    router.push("/simulacao")
  }

  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const response = await fetch("/api/user/profile")
        if (response.ok) {
          const data = await response.json()
          setUserData(data)
        } else {
          router.push("/login")
        }
      } catch (error) {
        console.error("Erro ao carregar dados do usuário:", error)
        router.push("/login")
      } finally {
        setIsLoading(false)
      }
    }

    fetchUserData()
  }, [router])

  const handleLogout = () => {
    document.cookie = "auth-token=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT"
    router.push("/login")
  }

  const getProductIcon = (type: string) => {
    switch (type.toLowerCase()) {
      case "vida":
        return <Heart className="h-6 w-6 text-red-500" />
      case "saúde":
        return <Cross className="h-6 w-6 text-green-500" />
      case "saúde mwangolé":
        return <Stethoscope className="h-6 w-6 text-blue-500" />
      case "escolar":
        return <GraduationCap className="h-6 w-6 text-purple-500" />
      default:
        return <Shield className="h-6 w-6 text-gray-500" />
    }
  }

  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case "ativo":
        return "bg-green-100 text-green-800"
      case "pendente":
        return "bg-yellow-100 text-yellow-800"
      case "vencido":
        return "bg-red-100 text-red-800"
      default:
        return "bg-gray-100 text-gray-800"
    }
  }

  if (isLoading) {
    return (
        <div className="min-h-screen bg-gray-50 flex items-center justify-center">
          <div className="text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
            <p className="mt-4 text-gray-600">Carregando...</p>
          </div>
        </div>
    )
  }

  return (
      <div className="min-h-screen bg-gray-50">
        {/* Header */}
        <header className="bg-white shadow-sm border-b">
          <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex justify-between items-center h-16">
              <div className="flex items-center space-x-4">
                <img
                    src="https://www.nossaseguros.ao/assets/img/logo.png"
                    alt="Nossa Seguros"
                    className="h-8 w-auto object-contain"
                />
                <span className="text-gray-600 text-sm">Dashboard</span>
              </div>

              <div className="flex items-center space-x-4">
                <Button variant="ghost" size="sm">
                  <Bell className="h-4 w-4" />
                </Button>
                <Button variant="ghost" size="sm" onClick={handleLogout}>
                  <LogOut className="h-4 w-4" />
                  <span className="ml-2">Sair</span>
                </Button>
              </div>
            </div>
          </div>
        </header>

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          {/* Welcome Section */}
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900">Olá, {userData?.name || "Usuário"}!</h1>
            <p className="text-gray-600 mt-2">Gerencie suas apólices e informações pessoais</p>
          </div>

          {/* Quick Stats */}
          <div className="grid grid-cols-1 md:grid-cols-5 gap-6 mb-8">
            <Card>
              <CardContent className="p-6">
                <div className="flex items-center">
                  <Shield className="h-8 w-8 text-blue-600" />
                  <div className="ml-4">
                    <p className="text-sm font-medium text-gray-600">Apólices Ativas</p>
                    <p className="text-2xl font-bold text-gray-900">
                      {userData?.policies?.filter((p) => p.status === "ativo").length || 0}
                    </p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="p-6">
                <div className="flex items-center">
                  <CreditCard className="h-8 w-8 text-green-600" />
                  <div className="ml-4">
                    <p className="text-sm font-medium text-gray-600">Próximo Pagamento</p>
                    <p className="text-lg font-bold text-gray-900">15/08/2024</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="p-6">
                <div className="flex items-center">
                  <FileText className="h-8 w-8 text-purple-600" />
                  <div className="ml-4">
                    <p className="text-sm font-medium text-gray-600">Sinistros</p>
                    <p className="text-2xl font-bold text-gray-900">0</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card>
              <CardContent className="p-6">
                <div className="flex items-center">
                  <User className="h-8 w-8 text-orange-600" />
                  <div className="ml-4">
                    <p className="text-sm font-medium text-gray-600">Perfil</p>
                    <p className="text-lg font-bold text-gray-900">Completo</p>
                  </div>
                </div>
              </CardContent>
            </Card>
            <Card
                className="cursor-pointer hover:shadow-lg transition-shadow border-2 border-green-500 bg-green-50"
                onClick={handleSimular}
            >
              <CardContent className="p-6">
                <div className="flex items-center">
                  <Calculator className="h-8 w-8 text-green-600" />
                  <div className="ml-4">
                    <p className="text-sm font-medium text-green-600">Nova Simulação</p>
                    <p className="text-lg font-bold text-green-700">Simular Seguro</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Main Content */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Policies List */}
            <div className="lg:col-span-2">
              <Card>
                <CardHeader>
                  <CardTitle>Minhas Apólices</CardTitle>
                  <CardDescription>Gerencie suas apólices de seguro</CardDescription>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    {userData?.policies?.map((policy) => (
                        <div key={policy.id} className="flex items-center justify-between p-4 border rounded-lg">
                          <div className="flex items-center space-x-4">
                            {getProductIcon(policy.type)}
                            <div>
                              <h3 className="font-medium text-gray-900">{policy.type}</h3>
                              <p className="text-sm text-gray-600">Próximo pagamento: {policy.nextPayment}</p>
                            </div>
                          </div>
                          <div className="flex items-center space-x-4">
                            <div className="text-right">
                              <p className="font-medium text-gray-900">AOA {policy.premium.toFixed(2)}</p>
                              <Badge className={getStatusColor(policy.status)}>{policy.status}</Badge>
                            </div>
                            <Button variant="outline" size="sm">
                              Ver Detalhes
                            </Button>
                          </div>
                        </div>
                    )) || (
                        <div className="text-center py-8">
                          <Shield className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                          <p className="text-gray-600">Nenhuma apólice encontrada</p>
                          <Button className="mt-4 bg-gradient-to-r from-blue-600 to-green-500">Contratar Seguro</Button>
                        </div>
                    )}
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Sidebar */}
            <div className="space-y-6">
              {/* Profile Card */}
              <Card>
                <CardHeader>
                  <CardTitle>Perfil</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-4">
                    <div>
                      <p className="text-sm font-medium text-gray-600">Nome</p>
                      <p className="text-gray-900">{userData?.name || "Não informado"}</p>
                    </div>
                    <div>
                      <p className="text-sm font-medium text-gray-600">Email</p>
                      <p className="text-gray-900">{userData?.email || "Não informado"}</p>
                    </div>
                    <div>
                      <p className="text-sm font-medium text-gray-600">Telefone</p>
                      <p className="text-gray-900">{userData?.phone || "Não informado"}</p>
                    </div>
                    <Button variant="outline" className="w-full bg-transparent">
                      <Settings className="h-4 w-4 mr-2" />
                      Editar Perfil
                    </Button>
                  </div>
                </CardContent>
              </Card>

              {/* Quick Actions */}
              <Card>
                <CardHeader>
                  <CardTitle>Ações Rápidas</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2">
                    <Button
                        onClick={handleSimular}
                        className="w-full justify-start bg-green-600 hover:bg-green-700 text-white mb-2"
                    >
                      <Calculator className="h-4 w-4 mr-2" />
                      Simular Novo Seguro
                    </Button>
                    <Button variant="outline" className="w-full justify-start bg-transparent">
                      <FileText className="h-4 w-4 mr-2" />
                      Solicitar Sinistro
                    </Button>
                    <Button variant="outline" className="w-full justify-start bg-transparent">
                      <CreditCard className="h-4 w-4 mr-2" />
                      Histórico de Pagamentos
                    </Button>
                    <Button variant="outline" className="w-full justify-start bg-transparent">
                      <Shield className="h-4 w-4 mr-2" />
                      Contratar Novo Seguro
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>
  )
}
