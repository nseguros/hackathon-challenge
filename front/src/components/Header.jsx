"use client"

import { useState } from "react"
import { LogOut } from "lucide-react"
import { useNavigate } from "react-router-dom"
import { useAuth } from "../contexts/AuthContext"
import logo from "../assets/logo.png"

const Header = () => {
  const navigate = useNavigate()
  const { logout } = useAuth()
  const [showLogoutModal, setShowLogoutModal] = useState(false)

  const handleLogoClick = () => {
    navigate("/home")
  }

  const handleLogout = () => {
    setShowLogoutModal(true)
  }

  const confirmarLogout = () => {
    logout()
    navigate("/")
  }

  const cancelarLogout = () => {
    setShowLogoutModal(false)
  }

  return (
    <>
      <header className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <button 
              onClick={handleLogoClick}
              className="w-15 h-10 flex items-center justify-center hover:opacity-80 transition-opacity"
            >
              <img 
                src={logo} 
                alt="NOSSA SEGUROS" 
                className="w-full h-full object-contain"
              />
            </button>
            
            <button
              onClick={handleLogout}
              className="flex items-center space-x-2 px-4 py-2 text-gray-600 hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors"
              title="Sair"
            >
              <LogOut size={20} />
              <span className="hidden sm:inline">Sair</span>
            </button>
          </div>
        </div>
      </header>

      {/* Modal de Confirmação de Logout */}
      {showLogoutModal && (
        <div 
          className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50"
          onClick={cancelarLogout}
        >
          <div 
            className="bg-white rounded-lg max-w-md w-full p-6"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="text-center">
              <div className="mb-4">
                <LogOut className="w-12 h-12 text-red-500 mx-auto mb-3" />
                <h3 className="text-lg font-semibold text-gray-800 mb-2">
                  Confirmar Saída
                </h3>
                <p className="text-gray-600">
                  Tem certeza de que deseja sair da aplicação?
                </p>
              </div>
              
              <div className="flex gap-3">
                <button
                  onClick={cancelarLogout}
                  className="btn btn-secondary flex-1"
                >
                  Cancelar
                </button>
                <button
                  onClick={confirmarLogout}
                  className="btn btn-primary flex-1 bg-red-600 hover:bg-red-700"
                >
                  Sair
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
    </>
  )
}

export default Header
