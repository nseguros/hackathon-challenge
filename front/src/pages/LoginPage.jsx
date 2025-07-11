import { useState } from "react"
import { useNavigate } from "react-router-dom"
import { Eye, EyeOff } from "lucide-react"
import { useAuth } from "../contexts/AuthContext"
import Card, { CardHeader, CardContent } from "../components/Card"
import logo from "../assets/logo.png"

const LoginPage = () => {
  const [telefone, setTelefone] = useState("")
  const [senha, setSenha] = useState("")
  const [mostrarSenha, setMostrarSenha] = useState(false)
  const [loading, setLoading] = useState(false)
  const [erro, setErro] = useState("")
  const [telefoneValido, setTelefoneValido] = useState(null)
  const [senhaValida, setSenhaValida] = useState(null)
  const [telefoneBlurred, setTelefoneBlurred] = useState(false)
  const [senhaBlurred, setSenhaBlurred] = useState(false)
  const { login } = useAuth()
  const navigate = useNavigate()

  const validarTelefone = (numero) => {
    // Remove espaços e caracteres especiais exceto +
    const numeroLimpo = numero.replace(/[^\d+]/g, '')
    
    // Verifica se começa com +244 seguido de 9 e tem 13 dígitos no total
    // ou se começa com 9 e tem 9 dígitos
    const formatoCompleto = /^\+2449\d{8}$/.test(numeroLimpo)
    const formatoSimples = /^9\d{8}$/.test(numeroLimpo)
    
    return formatoCompleto || formatoSimples
  }

  const validarSenha = (senha) => {
    // Pelo menos 6 caracteres e pelo menos 1 caractere especial
    const temTamanhoMinimo = senha.length >= 6
    const temCaractereEspecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(senha)
    
    return temTamanhoMinimo && temCaractereEspecial
  }

  const handleTelefoneChange = (e) => {
    const valor = e.target.value
    setTelefone(valor)
    
    // Validar em tempo real quando há valor
    if (valor) {
      setTelefoneValido(validarTelefone(valor))
    } else {
      setTelefoneValido(null)
    }
  }

  const handleSenhaChange = (e) => {
    const valor = e.target.value
    setSenha(valor)
    
    // Validar em tempo real quando há valor
    if (valor) {
      setSenhaValida(validarSenha(valor))
    } else {
      setSenhaValida(null)
    }
  }

  const handleTelefoneBlur = () => {
    setTelefoneBlurred(true)
    if (telefone) {
      setTelefoneValido(validarTelefone(telefone))
    }
  }

  const handleSenhaBlur = () => {
    setSenhaBlurred(true)
    if (senha) {
      setSenhaValida(validarSenha(senha))
    }
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    if (!telefone || !senha) return

    setLoading(true)
    setErro("")
    
    try {
      await login(telefone, senha)
      navigate("/home")
    } catch (error) {
      console.error("Erro no login:", error)
      setErro("Número de telemóvel ou senha incorretos. Tente novamente.")
    } finally {
      setLoading(false)
    }
  }

  const isFormValid = telefone.length > 0 && senha.length > 0 && telefoneValido === true && senhaValida === true

  return (
    <div className="min-h-screen flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center pb-2">
          <div className="mx-auto mb-6">
            <div className="w-15 h-10 mx-auto mb-4 flex items-center justify-center">
              <img 
                src={logo} 
                alt="NOSSA Seguros" 
                className="w-full h-full object-contain"
              />
            </div>
            <h2 className="text-xl font-semibold text-gray-700">Vamos começar</h2>
          </div>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            {erro && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
                {erro}
              </div>
            )}
            
            <div className="space-y-2">
              <label htmlFor="telefone" className="block text-sm font-medium text-gray-700">
                Número de telemóvel
              </label>
              <input
                id="telefone"
                type="tel"
                placeholder="Ex: 921 442 543"
                value={telefone}
                onChange={handleTelefoneChange}
                onBlur={handleTelefoneBlur}
                className={`input ${
                  telefone 
                    ? telefoneValido 
                      ? 'border-green-500 focus:ring-green-500' 
                      : 'border-red-500 focus:ring-red-500'
                    : ''
                }`}
              />
              {telefone && telefoneValido === false && (
                <p className="text-red-600 text-xs mt-1">
                  O número deve começar com "9" e ter 9 dígitos. Ex: 9xx xxx xxx
                </p>
              )}
              {telefone && telefoneValido === true && (
                <p className="text-green-600 text-xs mt-1">
                  ✓ Número válido
                </p>
              )}
            </div>

            <div className="space-y-2">
              <label htmlFor="senha" className="block text-sm font-medium text-gray-700">
                Senha
              </label>
              <div className="relative">
                <input
                  id="senha"
                  type={mostrarSenha ? "text" : "password"}
                  placeholder="Digite sua senha"
                  value={senha}
                  onChange={handleSenhaChange}
                  onBlur={handleSenhaBlur}
                  className={`input pr-10 ${
                    senha 
                      ? senhaValida 
                        ? 'border-green-500 focus:ring-green-500' 
                        : 'border-red-500 focus:ring-red-500'
                      : ''
                  }`}
                />
                <button
                  type="button"
                  onClick={() => setMostrarSenha(!mostrarSenha)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-500 hover:text-gray-700"
                >
                  {mostrarSenha ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
              {senha && senhaValida === false && (
                <p className="text-red-600 text-xs mt-1">
                  A senha deve ter pelo menos 6 caracteres e incluir um caractere especial (!@#$%^&*()_+-=[]{}|;':",./&lt;&gt;?)
                </p>
              )}
              {senha && senhaValida === true && (
                <p className="text-green-600 text-xs mt-1">
                  ✓ Senha válida
                </p>
              )}
            </div>

            <button
              type="submit"
              className={`btn btn-primary w-full py-3 ${!isFormValid || loading ? "btn-disabled" : ""}`}
              disabled={!isFormValid || loading}
            >
              {loading ? "Iniciando..." : "Iniciar Sessão"}
            </button>

            {/* <div className="mt-6 p-4 bg-gray-50 rounded-lg border">
              <p className="text-sm font-medium text-gray-700 mb-2">Credenciais de teste:</p>
              <p className="text-xs text-gray-600">Telefone: +244900000000 ou 900000000</p>
              <p className="text-xs text-gray-600">Senha: 123456@ (com caractere especial)</p>
            </div> */}
          </form>
        </CardContent>
      </Card>
    </div>
  )
}

export default LoginPage
