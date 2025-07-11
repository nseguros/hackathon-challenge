"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Checkbox } from "@/components/ui/checkbox"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Loader2, User, CreditCard, CheckCircle, ArrowLeft } from "lucide-react"

interface SubscriptionData {
    nome: string
    nif: string
    telefone: string
    email: string
    metodoPagamento: string
    aceitaTermos: boolean
}

export default function SubscricaoPage() {
    const router = useRouter()
    const [simulationData, setSimulationData] = useState<any>(null)
    const [formData, setFormData] = useState<SubscriptionData>({
        nome: "",
        nif: "",
        telefone: "",
        email: "",
        metodoPagamento: "",
        aceitaTermos: false,
    })
    const [isProcessing, setIsProcessing] = useState(false)
    const [isSuccess, setIsSuccess] = useState(false)
    const [error, setError] = useState("")

    useEffect(() => {
        const savedData = localStorage.getItem("simulationData")
        if (savedData) {
            setSimulationData(JSON.parse(savedData))
        } else {
            router.push("/simulacao")
        }
    }, [router])

    const handleInputChange = (field: keyof SubscriptionData, value: string | boolean) => {
        setFormData((prev) => ({
            ...prev,
            [field]: value,
        }))
    }

    const validateForm = () => {
        const { nome, nif, telefone, email, metodoPagamento, aceitaTermos } = formData

        if (!nome.trim()) return "Nome é obrigatório"
        if (!nif.trim()) return "NIF é obrigatório"
        if (!telefone.trim()) return "Telefone é obrigatório"
        if (!email.trim()) return "E-mail é obrigatório"
        if (!metodoPagamento) return "Método de pagamento é obrigatório"
        if (!aceitaTermos) return "Deve aceitar os Termos e Condições"

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(email)) return "E-mail inválido"
        if (telefone.length < 9) return "Telefone deve ter pelo menos 9 dígitos"

        return null
    }

    const handleConfirmarSubscricao = async () => {
        setError("")

        const validationError = validateForm()
        if (validationError) {
            setError(validationError)
            return
        }

        setIsProcessing(true)

        setTimeout(() => {
            setIsProcessing(false)
            setIsSuccess(true)
            localStorage.removeItem("simulationData")
        }, 3000)
    }

    const handleVoltarInicio = () => {
        router.push("/simulacao")
    }

    if (isSuccess) {
        return (
            <div className="min-h-screen bg-gradient-to-br from-green-50 to-blue-50 flex items-center justify-center p-4">
                <Card className="w-full max-w-md text-center">
                    <CardContent className="p-8">
                        <div className="flex justify-center mb-6">
                            <div className="w-16 h-16 bg-green-500 rounded-full flex items-center justify-center">
                                <CheckCircle className="h-8 w-8 text-white" />
                            </div>
                        </div>
                        <h2 className="text-2xl font-bold text-gray-900 mb-4">Subscrição Confirmada!</h2>
                        <p className="text-gray-600 mb-6">
                            A sua subscrição foi processada com sucesso. Receberá um e-mail de confirmação em breve.
                        </p>
                        <Button onClick={handleVoltarInicio} className="w-full bg-blue-600 hover:bg-blue-700">
                            Voltar ao Início
                        </Button>
                    </CardContent>
                </Card>
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50">
            {/* Header */}
            <header className="bg-white shadow-sm border-b">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center h-16">
                        <div className="flex items-center space-x-4">
                            <Button variant="ghost" onClick={() => router.back()} className="flex items-center space-x-2">
                                <ArrowLeft className="h-4 w-4" />
                                <span>Voltar</span>
                            </Button>
                            <img
                                src="https://www.nossaseguros.ao/assets/img/logo.png"
                                alt="Nossa Seguros"
                                className="h-8 w-auto object-contain"
                            />
                        </div>
                    </div>
                </div>
            </header>

            <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <div className="text-center mb-8">
                    <h1 className="text-3xl font-bold text-gray-900 mb-2">Subscrição do Seguro</h1>
                    <p className="text-gray-600">Complete os seus dados para finalizar a subscrição</p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    {/* Formulário de Subscrição */}
                    <div className="lg:col-span-2">
                        <Card>
                            <CardHeader>
                                <CardTitle className="flex items-center space-x-2">
                                    <User className="h-5 w-5" />
                                    <span>Dados do Tomador do Seguro</span>
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-6">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div className="md:col-span-2">
                                        <Label htmlFor="nome">Nome Completo *</Label>
                                        <Input
                                            id="nome"
                                            placeholder="Digite o seu nome completo"
                                            value={formData.nome}
                                            onChange={(e) => handleInputChange("nome", e.target.value)}
                                        />
                                    </div>

                                    <div>
                                        <Label htmlFor="nif">NIF *</Label>
                                        <Input
                                            id="nif"
                                            placeholder="Digite o seu NIF"
                                            value={formData.nif}
                                            onChange={(e) => handleInputChange("nif", e.target.value)}
                                        />
                                    </div>

                                    <div>
                                        <Label htmlFor="telefone">Telefone *</Label>
                                        <Input
                                            id="telefone"
                                            placeholder="Digite o seu telefone"
                                            value={formData.telefone}
                                            onChange={(e) => handleInputChange("telefone", e.target.value)}
                                        />
                                    </div>

                                    <div className="md:col-span-2">
                                        <Label htmlFor="email">E-mail *</Label>
                                        <Input
                                            id="email"
                                            type="email"
                                            placeholder="Digite o seu e-mail"
                                            value={formData.email}
                                            onChange={(e) => handleInputChange("email", e.target.value)}
                                        />
                                    </div>

                                    <div className="md:col-span-2">
                                        <Label htmlFor="metodoPagamento">Método de Pagamento *</Label>
                                        <Select onValueChange={(value) => handleInputChange("metodoPagamento", value)}>
                                            <SelectTrigger>
                                                <SelectValue placeholder="Selecione o método de pagamento" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="debito-direto">Débito Direto</SelectItem>
                                                <SelectItem value="transferencia">Transferência Bancária</SelectItem>
                                                <SelectItem value="multicaixa">Multicaixa Express</SelectItem>
                                                <SelectItem value="cartao-credito">Cartão de Crédito</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                </div>

                                <div className="flex items-center space-x-2">
                                    <Checkbox
                                        id="termos"
                                        checked={formData.aceitaTermos}
                                        onCheckedChange={(checked) => handleInputChange("aceitaTermos", checked as boolean)}
                                    />
                                    <Label htmlFor="termos" className="text-sm">
                                        Aceito os{" "}
                                        <a href="#" className="text-blue-600 hover:underline">
                                            Termos e Condições
                                        </a>{" "}
                                        *
                                    </Label>
                                </div>

                                {error && (
                                    <Alert variant="destructive">
                                        <AlertDescription>{error}</AlertDescription>
                                    </Alert>
                                )}

                                <Button
                                    onClick={handleConfirmarSubscricao}
                                    disabled={isProcessing}
                                    className="w-full bg-green-600 hover:bg-green-700"
                                >
                                    {isProcessing ? (
                                        <>
                                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                            Processando Pagamento...
                                        </>
                                    ) : (
                                        <>
                                            <CreditCard className="mr-2 h-4 w-4" />
                                            Confirmar Subscrição
                                        </>
                                    )}
                                </Button>
                            </CardContent>
                        </Card>
                    </div>

                    {/* Resumo da Simulação */}
                    <div>
                        <Card>
                            <CardHeader>
                                <CardTitle>Resumo do Seguro</CardTitle>
                            </CardHeader>
                            <CardContent>
                                {simulationData ? (
                                    <div className="space-y-4">
                                        <div className="p-4 bg-blue-50 rounded-lg">
                                            <h3 className="font-semibold text-blue-800 mb-2">Seguro Automóvel</h3>
                                            <div className="space-y-2 text-sm">
                                                <div className="flex justify-between">
                                                    <span className="text-gray-600">Marca:</span>
                                                    <span className="font-medium">{simulationData.marca}</span>
                                                </div>
                                                <div className="flex justify-between">
                                                    <span className="text-gray-600">Modelo:</span>
                                                    <span className="font-medium">{simulationData.modelo}</span>
                                                </div>
                                                <div className="flex justify-between">
                                                    <span className="text-gray-600">Matrícula:</span>
                                                    <span className="font-medium">{simulationData.matricula}</span>
                                                </div>
                                                <div className="flex justify-between">
                                                    <span className="text-gray-600">Fracionamento:</span>
                                                    <span className="font-medium">{simulationData.fracionamento}</span>
                                                </div>
                                            </div>
                                        </div>

                                        <div className="p-4 bg-green-50 rounded-lg border-2 border-green-200">
                                            <div className="text-center">
                                                <p className="text-sm text-green-700 mb-1">Prêmio Mensal</p>
                                                <p className="text-2xl font-bold text-green-600">
                                                    {simulationData.premio?.toLocaleString("pt-AO")} AKZ
                                                </p>
                                            </div>
                                        </div>

                                        <div className="text-xs text-gray-500 space-y-1">
                                            <p>• Cobertura de responsabilidade civil</p>
                                            <p>• Assistência em viagem 24h</p>
                                            <p>• Proteção jurídica incluída</p>
                                        </div>
                                    </div>
                                ) : (
                                    <div className="text-center py-8">
                                        <p className="text-gray-600">Carregando dados da simulação...</p>
                                    </div>
                                )}
                            </CardContent>
                        </Card>
                    </div>
                </div>
            </div>
        </div>
    )
}
