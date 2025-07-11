import { type NextRequest, NextResponse } from "next/server"

export async function POST(request: NextRequest) {
    try {
        const { name, phone, email, password, identity, identity_type } = await request.json()

        if (!name || !phone || !email || !password || !identity || !identity_type) {
            return NextResponse.json({ message: "Todos os campos são obrigatórios" }, { status: 400 })
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
        if (!emailRegex.test(email)) {
            return NextResponse.json({ message: "E-mail inválido" }, { status: 400 })
        }

        if (password.length < 6) {
            return NextResponse.json({ message: "Senha deve ter pelo menos 6 caracteres" }, { status: 400 })
        }
        if (phone.length < 9) {
            return NextResponse.json({ message: "Telefone deve ter pelo menos 9 dígitos" }, { status: 400 })
        }

        if (identity.length < 6) {
            return NextResponse.json({ message: "Documento de identidade inválido" }, { status: 400 })
        }

        const externalApiResponse = await fetch("http://localhost:9850/api/v1/users/register", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({
                name,
                phone,
                email,
                password,
                identity,
                identity_type,
            }),
        })

        const externalApiData = await externalApiResponse.json()

        if (externalApiResponse.ok) {
            return NextResponse.json(externalApiData, { status: externalApiResponse.status })
        } else {
            return NextResponse.json(
                { message: externalApiData.message || externalApiData.error || "Erro ao registrar usuário na API externa" },
                { status: externalApiResponse.status || 500 },
            )
        }
    } catch (error) {
        console.error("Erro no servidor ao processar registro:", error)
        return NextResponse.json({ message: "Erro interno do servidor" }, { status: 500 })
    }
}
