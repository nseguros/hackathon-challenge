import { type NextRequest, NextResponse } from "next/server"

export async function POST(request: NextRequest) {
  try {
    const { emailOrPhone, password } = await request.json()

    const response = await fetch('http://localhost:9850/api/v1/auth/login', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ username: emailOrPhone, password }),
    })

    const data = await response.json()

    if (response.ok && data.token) {
      const token = data.token

      return NextResponse.json({
        success: true,
        token,
        user: {
          id: data.id,
          email: data.username,
        },
      })
    }

    return NextResponse.json({ message: "Credenciais inválidas" }, { status: 401 })
  } catch (error) {
    return NextResponse.json({ message: "Credenciais inválidas" }, { status: 500 })
  }
}
