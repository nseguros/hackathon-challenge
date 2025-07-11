"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Loader2, Eye, EyeOff } from "lucide-react"

export default function LoginPage() {
  const [emailOrPhone, setEmailOrPhone] = useState("")
  const [password, setPassword] = useState("")
  const [showPassword, setShowPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState("")
  const [successMessage, setSuccessMessage] = useState("")
  const router = useRouter()
  const searchParams = useSearchParams()

  useEffect(() => {
    const message = searchParams.get("message")
    if (message) {
      setSuccessMessage(message)
    }
  }, [searchParams])

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError("")

    try {
      const response = await fetch("/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          emailOrPhone,
          password,
        }),
      })

      const data = await response.json()

      if (response.ok) {
        // Login bem-sucedido
        document.cookie = `auth-token=${data.token}; path=/; max-age=${60 * 60 * 24 * 7}` // 7 dias
        router.push("/dashboard")
      } else {
        setError(data.message || "Erro ao fazer login")
      }
    } catch (error) {
      setError("Erro de conexão. Tente novamente.")
    } finally {
      setIsLoading(false)
    }
  }

  return (
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50 flex items-center justify-center p-4">
        <div className="w-full max-w-md">
          <Card className="w-full">
            <CardHeader className="text-center space-y-4">
              <div className="flex justify-center">
                <img
                    src="https://www.nossaseguros.ao/assets/img/logo.png"
                    alt="Nossa Seguros"
                    className="h-16 w-auto object-contain"
                />
              </div>
              <div>
                <CardTitle className="text-2xl font-bold text-gray-900">Bem-vindo de volta</CardTitle>
                <CardDescription className="text-gray-600">Faça login em sua conta Nossa Seguros</CardDescription>
              </div>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleLogin} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="emailOrPhone">Email ou Telefone</Label>
                  <Input
                      id="emailOrPhone"
                      type="text"
                      placeholder="Digite seu e-mail ou telefone"
                      value={emailOrPhone}
                      onChange={(e) => setEmailOrPhone(e.target.value)}
                      required
                      className="w-full"
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="password">Senha</Label>
                  <div className="relative">
                    <Input
                        id="password"
                        type={showPassword ? "text" : "password"}
                        placeholder="Digite sua senha"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
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

                {successMessage && (
                    <Alert className="border-green-200 bg-green-50">
                      <AlertDescription className="text-green-800">{successMessage}</AlertDescription>
                    </Alert>
                )}

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
                        Entrando...
                      </>
                  ) : (
                      "Entrar"
                  )}
                </Button>
              </form>

              <div className="mt-6 text-center space-y-2">
                <a href="#" className="text-sm text-blue-600 hover:text-blue-800 hover:underline block">
                  Esqueceu sua senha?
                </a>
                <p className="text-sm text-gray-600">
                  Não tem uma conta?{" "}
                  <button
                      onClick={() => router.push("/register")}
                      className="text-blue-600 hover:text-blue-800 hover:underline font-medium"
                  >
                    Criar conta aqui
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
