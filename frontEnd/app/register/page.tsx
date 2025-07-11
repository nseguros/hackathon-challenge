"use client"

import type React from "react"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Checkbox } from "@/components/ui/checkbox"
import { Loader2, Eye, EyeOff, UserPlus, ArrowLeft } from "lucide-react"

interface RegisterData {
    name: string
    phone: string
    email: string
    password: string
    identity: string
    identity_type: string
    confirmPassword: string
    acceptTerms: boolean
}

export default function RegisterPage() {
    const [formData, setFormData] = useState<RegisterData>({
        name: "",
        phone: "",
        email: "",
        password: "",
        identity: "",
        identity_type: "",
        confirmPassword: "",
        acceptTerms: false,
    })
    const [showPassword, setShowPassword] = useState(false)
    const [showConfirmPassword, setShowConfirmPassword] = useState(false)
    const [isLoading, setIsLoading] = useState(false)
    const [error, setError] = useState("")
    const router = useRouter()

    const handleInputChange = (field: keyof RegisterData, value: string | boolean) => {
        setFormData((prev) => ({
            ...prev,
            [field]: value,
        }))
    }

    const validateForm = () => {
        const { name, phone, email, password, identity, identity_type, confirmPassword, acceptTerms } = formData

        if (!name.trim()) return "Nome é obrigatório"
        if (!phone.trim()) return "Telefone é obrigatório"
        if (!email.trim()) return "E-mail é obrigatório"
        if (!password.trim()) return "Senha é obrigatória"
        if (!identity.trim()) return "Documento de identidade é obrigatório"
        if (!identity_type) return "Tipo de identidade é obrigatório"
        if (!confirmPassword.trim()) return "Confirmação de senha é obrigatória"
        if (!acceptTerms) return "Deve aceitar os Termos e Condições"

        // Validação básica de email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(email)) return "E-mail inválido"

        // Validação básica de telefone
        if (phone.length < 9) return "Telefone deve ter pelo menos 9 dígitos"

        // Validação de senha
        if (password.length < 6) return "Senha deve ter pelo menos 6 caracteres"
        if (password !== confirmPassword) return "Senhas não coincidem"

        // Validação básica de identidade
        if (identity.length < 6) return "Documento de identidade inválido"

        return null
    }

    const handleRegister = async (e: React.FormEvent) => {
        e.preventDefault()
        setError("")

        const validationError = validateForm()
        if (validationError) {
            setError(validationError)
            return
        }

        setIsLoading(true)

        try {
            const response = await fetch("http://localhost:9850/api/v1/users/register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    name: formData.name,
                    phone: formData.phone,
                    email: formData.email,
                    password: formData.password,
                    identity: formData.identity,
                    identity_type: formData.identity_type,
                }),
            })

            const data = await response.json()

            if (response.ok) {
                // Registro bem-sucedido
                router.push("/login?message=Conta criada com sucesso! Faça login para continuar.")
            } else {
                setError(data.message || data.error || "Erro ao criar conta")
            }
        } catch (error) {
            setError("Erro de conexão. Verifique sua conexão com a internet ou o servidor.")
        } finally {
            setIsLoading(false)
        }
    }

    const getIdentityPlaceholder = () => {
        switch (formData.identity_type) {
            case "BI":
                return "Ex: 123456789BA123"
            case "NIF":
                return "Ex: 123456789"
            case "PASSAPORT":
                return "Ex: A1234567"
            default:
                return "Digite seu documento de identidade"
        }
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50 flex items-center justify-center p-4">
            <div className="w-full max-w-md">
                <Card className="w-full">
                    <CardHeader className="text-center space-y-4">
                        <div className="flex justify-center items-center space-x-4">
                            <Button variant="ghost" size="sm" onClick={() => router.push("/login")} className="absolute left-4 top-4">
                                <ArrowLeft className="h-4 w-4" />
                            </Button>
                            <img
                                src="https://www.nossaseguros.ao/assets/img/logo.png"
                                alt="Nossa Seguros"
                                className="h-16 w-auto object-contain"
                            />
                        </div>
                        <div>
                            <CardTitle className="text-2xl font-bold text-gray-900">Criar Nova Conta</CardTitle>
                            <CardDescription className="text-gray-600">
                                Junte-se à Nossa Seguros e proteja o que mais importa
                            </CardDescription>
                        </div>
                    </CardHeader>
                    <CardContent>
                        <form onSubmit={handleRegister} className="space-y-4">
                            <div className="space-y-2">
                                <Label htmlFor="name">Nome Completo *</Label>
                                <Input
                                    id="name"
                                    type="text"
                                    placeholder="Digite seu nome completo"
                                    value={formData.name}
                                    onChange={(e) => handleInputChange("name", e.target.value)}
                                    required
                                    className="w-full"
                                />
                            </div>

                            <div className="grid grid-cols-2 gap-3">
                                <div className="space-y-2">
                                    <Label htmlFor="identity_type">Tipo de Identidade *</Label>
                                    <Select onValueChange={(value) => handleInputChange("identity_type", value)}>
                                        <SelectTrigger>
                                            <SelectValue placeholder="Selecione" />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem value="BI">BI</SelectItem>s
                                            <SelectItem value="NIF">NIF</SelectItem>
                                            <SelectItem value="PASSAPORT">PASSAPORTE</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="identity">Nº do Documento *</Label>
                                    <Input
                                        id="identity"
                                        type="text"
                                        placeholder={getIdentityPlaceholder()}
                                        value={formData.identity}
                                        onChange={(e) => handleInputChange("identity", e.target.value)}
                                        required
                                        className="w-full"
                                    />
                                </div>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="phone">Telefone *</Label>
                                <Input
                                    id="phone"
                                    type="tel"
                                    placeholder="Ex: +244 912 345 678"
                                    value={formData.phone}
                                    onChange={(e) => handleInputChange("phone", e.target.value)}
                                    required
                                    className="w-full"
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="email">E-mail *</Label>
                                <Input
                                    id="email"
                                    type="email"
                                    placeholder="Digite seu e-mail"
                                    value={formData.email}
                                    onChange={(e) => handleInputChange("email", e.target.value)}
                                    required
                                    className="w-full"
                                />
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="password">Senha *</Label>
                                <div className="relative">
                                    <Input
                                        id="password"
                                        type={showPassword ? "text" : "password"}
                                        placeholder="Digite sua senha (mín. 6 caracteres)"
                                        value={formData.password}
                                        onChange={(e) => handleInputChange("password", e.target.value)}
                                        required
                                        className="w-full pr-10"
                                    />
                                    <Button
                                        type="button"
                                        variant="ghost"
                                        size="sm"
                                        className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                                        onClick={() => setShowPassword(!showPassword)}
                                    >
                                        {showPassword ? (
                                            <EyeOff className="h-4 w-4 text-gray-400" />
                                        ) : (
                                            <Eye className="h-4 w-4 text-gray-400" />
                                        )}
                                    </Button>
                                </div>
                            </div>

                            <div className="space-y-2">
                                <Label htmlFor="confirmPassword">Confirmar Senha *</Label>
                                <div className="relative">
                                    <Input
                                        id="confirmPassword"
                                        type={showConfirmPassword ? "text" : "password"}
                                        placeholder="Confirme sua senha"
                                        value={formData.confirmPassword}
                                        onChange={(e) => handleInputChange("confirmPassword", e.target.value)}
                                        required
                                        className="w-full pr-10"
                                    />
                                    <Button
                                        type="button"
                                        variant="ghost"
                                        size="sm"
                                        className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                                        onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                                    >
                                        {showConfirmPassword ? (
                                            <EyeOff className="h-4 w-4 text-gray-400" />
                                        ) : (
                                            <Eye className="h-4 w-4 text-gray-400" />
                                        )}
                                    </Button>
                                </div>
                            </div>

                            <div className="flex items-center space-x-2">
                                <Checkbox
                                    id="terms"
                                    checked={formData.acceptTerms}
                                    onCheckedChange={(checked) => handleInputChange("acceptTerms", checked as boolean)}
                                />
                                <Label htmlFor="terms" className="text-sm">
                                    Aceito os{" "}
                                    <a href="#" className="text-blue-600 hover:underline">
                                        Termos e Condições
                                    </a>{" "}
                                    e{" "}
                                    <a href="#" className="text-blue-600 hover:underline">
                                        Política de Privacidade
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
                                type="submit"
                                className="w-full bg-gradient-to-r from-blue-600 to-green-500 hover:from-blue-700 hover:to-green-600"
                                disabled={isLoading}
                            >
                                {isLoading ? (
                                    <>
                                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                        Criando conta...
                                    </>
                                ) : (
                                    <>
                                        <UserPlus className="mr-2 h-4 w-4" />
                                        Criar Conta
                                    </>
                                )}
                            </Button>
                        </form>

                        <div className="mt-6 text-center">
                            <p className="text-sm text-gray-600">
                                Já tem uma conta?{" "}
                                <button
                                    onClick={() => router.push("/login")}
                                    className="text-blue-600 hover:text-blue-800 hover:underline font-medium"
                                >
                                    Faça login aqui
                                </button>
                            </p>
                        </div>
                    </CardContent>
                </Card>

                {/* Certification Seals */}
                <div className="mt-8 flex justify-center items-center space-x-6">
                    <div className="flex items-center space-x-4">
                        <img
                            src="https://www.nossaseguros.ao/assets/img/NOSSA%20SEGUROS%202.png"
                            alt="Nossa Seguros Certification"
                            className="h-16 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                        />
                        <img
                            src="https://www.nossaseguros.ao/assets/img/Selo%20SFA%20-%20Servi%C3%A7os%20de%20Seguradora.png"
                            alt="SFA - Serviços de Seguradora"
                            className="h-16 w-auto object-contain opacity-80 hover:opacity-100 transition-opacity"
                        />
                    </div>
                </div>

                {/* Trust Message */}
                <div className="mt-4 text-center">
                    <p className="text-xs text-gray-500">
                        Empresa licenciada e regulamentada pela Superintendência de Seguros de Angola
                    </p>
                </div>
            </div>
        </div>
    )
}
