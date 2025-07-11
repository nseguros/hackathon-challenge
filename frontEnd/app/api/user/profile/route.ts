import { type NextRequest, NextResponse } from "next/server"

export async function GET(request: NextRequest) {
  try {
    const token = request.cookies.get("auth-token")?.value

    if (!token) {
      return NextResponse.json({ message: "Token não encontrado" }, { status: 401 })
    }

    const response = await fetch('http://localhost:9850/api/v1/auth/profile', {
      method: 'POST',
      headers: {
        'Accept': '*/*',
        'Authorization': `Bearer ${token}`,
      },
    })

    const userData = await response.json()

    if (response.ok) {
      const user = {
        id: userData.id,
        name: userData.name,
        email: userData.email,
        phone: userData.phone,
        identity: userData.identity,

        policies: [
          {
            id: "1",
            type: "Vida",
            status: "ativo",
            premium: 15000.0,
            nextPayment: "15/08/2024",
          },
          {
            id: "2",
            type: "Saúde",
            status: "ativo",
            premium: 28000.0,
            nextPayment: "20/08/2024",
          },
          {
            id: "3",
            type: "Escolar",
            status: "pendente",
            premium: 9500.0,
            nextPayment: "10/08/2024",
          },
        ],
      }

      return NextResponse.json(user)
    } else {
      return NextResponse.json({ message: "Erro ao recuperar dados do usuário" }, { status: 500 })
    }
  } catch (error) {
    return NextResponse.json({ message: "Erro interno do servidor" }, { status: 500 })
  }
}
