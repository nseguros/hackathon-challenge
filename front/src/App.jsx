import { Routes, Route, Navigate } from "react-router-dom"
import LoginPage from "./pages/LoginPage"
import SubscricaoPage from "./pages/SubscricaoPage"
import HomePage from "./components/HomePage"
import SimuladorPage from "./components/SimuladorPage"
import ResultadoPage from "./components/ResultadoPage"
import { AuthProvider } from "./contexts/AuthContext"
import ProtectedRoute from "./components/ProtectedRoute"

function App() {
  return (
    <AuthProvider>
      <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50">
        <Routes>
          <Route path="/" element={<LoginPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route
            path="/home"
            element={
              <ProtectedRoute>
                <HomePage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/simulador"
            element={
              <ProtectedRoute>
                <SimuladorPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/resultado"
            element={
              <ProtectedRoute>
                <ResultadoPage />
              </ProtectedRoute>
            }
          />
          <Route
            path="/subscricao"
            element={
              <ProtectedRoute>
                <SubscricaoPage />
              </ProtectedRoute>
            }
          />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </div>
    </AuthProvider>
  )
}

export default App
