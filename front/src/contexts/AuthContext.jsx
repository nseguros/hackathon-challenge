import { createContext, useContext, useState, useEffect } from "react"

const AuthContext = createContext()

export const useAuth = () => {
  const context = useContext(AuthContext)
  if (!context) {
    throw new Error("useAuth deve ser usado dentro de um AuthProvider")
  }
  return context
}

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    // Verificar se há usuário logado no localStorage
    const userData = localStorage.getItem("user")
    const token = localStorage.getItem("token")
    if (userData && token) {
      setUser(JSON.parse(userData))
    }
    setLoading(false)
  }, [])

  const login = async (telefone, senha) => {
    try {
      const response = await fetch("http://localhost:3000/api/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          phone: telefone,
          password: senha,
        }),
      })

      const data = await response.json()

      if (!response.ok) {
        throw new Error(data.message || "Erro no login")
      }

      if (data.success) {
        const userData = {
          id: data.data.user.id,
          phone: data.data.user.phone,
        }
        
        setUser(userData)
        localStorage.setItem("user", JSON.stringify(userData))
        localStorage.setItem("token", data.data.token)
        
        return userData
      } else {
        throw new Error(data.message || "Credenciais inválidas")
      }
    } catch (error) {
      console.error("Erro no login:", error)
      throw error
    }
  }

  const logout = () => {
    setUser(null)
    localStorage.removeItem("user")
    localStorage.removeItem("token")
    localStorage.removeItem("simulacao")
  }

  const value = {
    user,
    login,
    logout,
    loading,
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
