"use client"

import { useRouter } from "next/navigation"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import {ArrowLeft, Car, Heart, Shield} from "lucide-react"

export default function SimulacaoPage() {
    const router = useRouter()

    const handleAutomovelClick = () => {
        router.push("/simulacao-automovel")
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50">
            {/* Header */}
            <header className="bg-white shadow-sm border-b">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center h-16">
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
            </header>

            <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
                {/* Title */}
                <div className="text-center mb-12">
                    <h1 className="text-3xl font-bold text-gray-900 mb-4">Escolha o tipo de seguro que pretende simular</h1>
                </div>

                {/* Insurance Cards */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
                    {/* Seguro Automóvel - Active */}
                    <Card className="cursor-pointer hover:shadow-lg transition-shadow border-2 border-blue-500 bg-blue-50">
                        <CardHeader className="text-center pb-4">
                            <div className="flex justify-center mb-4">
                                <div className="w-16 h-16 bg-blue-500 rounded-full flex items-center justify-center">
                                    <Car className="h-8 w-8 text-white" />
                                </div>
                            </div>
                            <CardTitle className="text-xl font-bold text-blue-700">Seguro Automóvel</CardTitle>
                        </CardHeader>
                        <CardContent className="text-center">
                            <p className="text-gray-600 mb-6">Proteja o seu veículo com a nossa cobertura completa</p>
                            <Button onClick={handleAutomovelClick} className="w-full bg-blue-600 hover:bg-blue-700 text-white">
                                Simular Agora
                            </Button>
                        </CardContent>
                    </Card>

                    {/* Seguro Saúde - Inactive */}
                    <Card className="cursor-not-allowed opacity-60">
                        <CardHeader className="text-center pb-4">
                            <div className="flex justify-center mb-4">
                                <div className="w-16 h-16 bg-gray-400 rounded-full flex items-center justify-center">
                                    <Shield className="h-8 w-8 text-white" />
                                </div>
                            </div>
                            <CardTitle className="text-xl font-bold text-gray-500">Seguro Saúde</CardTitle>
                        </CardHeader>
                        <CardContent className="text-center">
                            <p className="text-gray-400 mb-6">Cuide da sua saúde com a nossa proteção médica</p>
                            <Button disabled className="w-full bg-gray-300 text-gray-500 cursor-not-allowed">
                                Em Breve
                            </Button>
                        </CardContent>
                    </Card>

                    {/* Seguro Vida - Inactive */}
                    <Card className="cursor-not-allowed opacity-60">
                        <CardHeader className="text-center pb-4">
                            <div className="flex justify-center mb-4">
                                <div className="w-16 h-16 bg-gray-400 rounded-full flex items-center justify-center">
                                    <Heart className="h-8 w-8 text-white" />
                                </div>
                            </div>
                            <CardTitle className="text-xl font-bold text-gray-500">Seguro Vida</CardTitle>
                        </CardHeader>
                        <CardContent className="text-center">
                            <p className="text-gray-400 mb-6">Garanta o futuro da sua família com segurança</p>
                            <Button disabled className="w-full bg-gray-300 text-gray-500 cursor-not-allowed">
                                Em Breve
                            </Button>
                        </CardContent>
                    </Card>
                </div>
            </div>
        </div>
    )
}
