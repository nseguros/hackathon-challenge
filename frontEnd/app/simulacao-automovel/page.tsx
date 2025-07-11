"use client"

import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Loader2, Car, Calculator, Mail, ArrowLeft } from "lucide-react"
import {Card, CardContent, CardHeader, CardTitle} from "@/components/ui/card";
import {Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle} from "@/components/ui/dialog"


const SIMULATION_MATRIX = [
    {
        marca: "toyota",
        modelo: "corolla",
        cilindradaRange: "Entre 1.601 CC e 2.000 CC",
        escalaoCapital: "13.376.000,00 AKZ",
        fracionamento: "Mensal",
        factorBase: 1,
        factorEscalao: 1,
        factorFracionamento: 1,
    },
    {
        marca: "toyota",
        modelo: "rav4",
        cilindradaRange: "Entre 2.001 CC e 2.500 CC",
        escalaoCapital: "26.752.000,00 AKZ",
        fracionamento: "Mensal",
        factorBase: 1.2,
        factorEscalao: 1.1,
        factorFracionamento: 1,
    },
    {
        marca: "hyundai",
        modelo: "elantra",
        cilindradaRange: "Entre 1.601 CC e 2.000 CC",
        escalaoCapital: "26.752.000,00 AKZ",
        fracionamento: "Mensal",
        factorBase: 1.1,
        factorEscalao: 1.1,
        factorFracionamento: 1,
    },
    {
        marca: "hyundai",
        modelo: "tucson",
        cilindradaRange: "Entre 2.001 CC e 2.500 CC",
        escalaoCapital: "40.128.000,00 AKZ",
        fracionamento: "Mensal",
        factorBase: 1.3,
        factorEscalao: 1.2,
        factorFracionamento: 1,
    },
]

const VALOR_BASE_PREMIO = 10000

interface SimulationFormData {
    marca: string
    modelo: string
    dataMatricula: string
    matricula: string
    escalaoCapital: string
    fracionamento: string
    dataInicio: string
    categoria: string
    cilindrada: string
}

export default function SimulacaoAutomovelPage() {
    const router = useRouter()
    const [formData, setFormData] = useState<SimulationFormData>({
        marca: "",
        modelo: "",
        dataMatricula: "",
        matricula: "",
        escalaoCapital: "",
        fracionamento: "Mensal",
        dataInicio: "",
        categoria: "Ligeiro Particular",
        cilindrada: "",
    })
    const [isSimulating, setIsSimulating] = useState(false)
    const [simulationResult, setSimulationResult] = useState<number | null>(null)
    const [error, setError] = useState("")
    const [emailRecipient, setEmailRecipient] = useState("")
    const [showPreviewModal, setShowPreviewModal] = useState(false)
    const [showEmailConfirmation, setShowEmailConfirmation] = useState(false)

    useEffect(() => {
        const match = SIMULATION_MATRIX.find(e => e.marca === formData.marca && e.modelo === formData.modelo)
        setFormData(prev => ({
            ...prev,
            cilindrada: match?.cilindradaRange || "",
            categoria: "Ligeiro Particular"
        }))
    }, [formData.marca, formData.modelo])

    const handleInputChange = (field: keyof SimulationFormData, value: string) => {
        setFormData(prev => ({ ...prev, [field]: value }))
        setSimulationResult(null)
        setError("")
    }

    const getModelosByMarca = (marca: string) => {
        if (marca === "toyota") return [{ value: "corolla", label: "Corolla" }, { value: "rav4", label: "RAV4" }]
        if (marca === "hyundai") return [{ value: "elantra", label: "Elantra" }, { value: "tucson", label: "Tucson" }]
        return []
    }

    const calculatePremium = (): number | null => {
        const match = SIMULATION_MATRIX.find(e =>
            e.marca === formData.marca &&
            e.modelo === formData.modelo &&
            e.escalaoCapital === formData.escalaoCapital &&
            e.fracionamento === formData.fracionamento
        )
        if (!match) return null
        return VALOR_BASE_PREMIO * match.factorBase * match.factorEscalao * match.factorFracionamento
    }

    const handleSimulation = () => {
        setShowPreviewModal(false)
        setError("")
        const requiredFields: Array<keyof SimulationFormData> = ["marca", "modelo", "dataMatricula", "matricula", "escalaoCapital", "fracionamento", "dataInicio"]
        const empty = requiredFields.filter(field => !formData[field].trim())
        if (empty.length > 0) {
            setError("Por favor, preencha todos os campos obrigatórios.")
            return
        }
        setIsSimulating(true)
        setTimeout(() => {
            const result = calculatePremium()
            result !== null ? setSimulationResult(result) : setError("Não foi possível calcular o prémio.")
            setIsSimulating(false)
        }, 1500)
    }

    const handleEnviarEmail = () => {
        if (!emailRecipient.trim()) return alert("Digite um e-mail.")
        setShowEmailConfirmation(true)
        setEmailRecipient("")
    }

    const handleSair = () => router.push("/simulacao")

    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-green-50">
            <header className="bg-white shadow-sm border-b">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div className="flex justify-between items-center h-16">
                        <div className="flex items-center space-x-4">
                            <Button variant="ghost" onClick={() => router.back()} className="flex items-center space-x-2">
                                <ArrowLeft className="h-4 w-4" />
                                <span>Voltar</span>
                            </Button>
                            <img src="https://www.nossaseguros.ao/assets/img/logo.png" alt="Nossa Seguros" className="h-8 w-auto" />
                        </div>
                    </div>
                </div>
            </header>

            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <div className="text-center mb-8">
                    <div className="flex justify-center mb-4">
                        <div className="w-16 h-16 bg-blue-500 rounded-full flex items-center justify-center">
                            <Car className="h-8 w-8 text-white" />
                        </div>
                    </div>
                    <h1 className="text-3xl font-bold text-gray-900 mb-2">Simulação de Seguro Automóvel</h1>
                    <p className="text-gray-600">Preencha os dados do seu veículo para calcular o prémio</p>
                </div>

                <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
                    <div>
                        <Card>
                            <CardHeader>
                                <CardTitle className="flex items-center space-x-2">
                                    <Calculator className="h-5 w-5" />
                                    <span>Dados do Veículo</span>
                                </CardTitle>
                            </CardHeader>
                            <CardContent className="space-y-6">
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <Label>Marca *</Label>
                                        <Select onValueChange={(v) => handleInputChange("marca", v)}>
                                            <SelectTrigger>
                                                <SelectValue placeholder="Selecione a marca" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="toyota">Toyota</SelectItem>
                                                <SelectItem value="hyundai">Hyundai</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <div>
                                        <Label>Modelo *</Label>
                                        <Select onValueChange={(v) => handleInputChange("modelo", v)} disabled={!formData.marca}>
                                            <SelectTrigger>
                                                <SelectValue placeholder="Selecione o modelo" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                {getModelosByMarca(formData.marca).map(({ value, label }) => (
                                                    <SelectItem key={value} value={value}>{label}</SelectItem>
                                                ))}
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <InputWithLabel id="categoria" label="Categoria" value={formData.categoria} disabled />
                                    <InputWithLabel id="cilindrada" label="Cilindrada" value={formData.cilindrada} disabled />
                                    <InputWithLabel id="dataMatricula" label="Data da 1.ª Matrícula *" type="date"
                                                    value={formData.dataMatricula}
                                                    onChange={(e) => handleInputChange("dataMatricula", e.target.value)} />
                                    <InputWithLabel id="matricula" label="Matrícula *" placeholder="AA-00-00-AA"
                                                    value={formData.matricula}
                                                    onChange={(e) => handleInputChange("matricula", e.target.value)} />
                                    <div>
                                        <Label>Escalão de Capital *</Label>
                                        <Select onValueChange={(v) => handleInputChange("escalaoCapital", v)}>
                                            <SelectTrigger><SelectValue placeholder="Selecione o escalão" /></SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="13.376.000,00 AKZ">A - 13.376.000,00 AKZ</SelectItem>
                                                <SelectItem value="26.752.000,00 AKZ">B - 26.752.000,00 AKZ</SelectItem>
                                                <SelectItem value="40.128.000,00 AKZ">C - 40.128.000,00 AKZ</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <div>
                                        <Label>Fracionamento *</Label>
                                        <Select onValueChange={(v) => handleInputChange("fracionamento", v)} value="Mensal">
                                            <SelectTrigger><SelectValue /></SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="Mensal">Mensal</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </div>
                                    <InputWithLabel id="dataInicio" label="Data de Início *" type="date"
                                                    value={formData.dataInicio}
                                                    onChange={(e) => handleInputChange("dataInicio", e.target.value)} />
                                </div>

                                {error && <Alert variant="destructive"><AlertDescription>{error}</AlertDescription></Alert>}

                                <Button onClick={() => setShowPreviewModal(true)} disabled={isSimulating} className="w-full bg-blue-600 hover:bg-blue-700">
                                    <Calculator className="mr-2 h-4 w-4" />
                                    Simular Prêmio
                                </Button>
                            </CardContent>
                        </Card>
                    </div>

                    <div>
                        <Card>
                            <CardHeader>
                                <CardTitle>Resultado da Simulação</CardTitle>
                            </CardHeader>
                            <CardContent>
                                {simulationResult ? (
                                    <div className="space-y-6">
                                        <div className="text-center p-6 bg-green-50 rounded-lg border-2 border-green-200">
                                            <h3 className="text-lg font-semibold text-green-800 mb-2">
                                                O seu prémio está estimado em
                                            </h3>
                                            <p className="text-3xl font-bold text-green-600">
                                                {simulationResult.toLocaleString("pt-AO")} AKZ/mês
                                            </p>
                                            <p className="text-sm text-gray-600 mt-2">
                                                Adira já, em 3 minutos, e evite constrangimentos.
                                            </p>
                                        </div>

                                        <Button
                                            className="w-full bg-green-600 hover:bg-green-700"
                                            onClick={() => {
                                                localStorage.setItem(
                                                    "simulationData",
                                                    JSON.stringify({ ...formData, premio: simulationResult })
                                                )
                                                router.push("/subscricao")
                                            }}
                                        >
                                            Aderir
                                        </Button>

                                        <Button
                                            onClick={handleSair}
                                            className="w-full bg-red-600 hover:bg-red-700"
                                        >
                                            Sair
                                        </Button>

                                        <div className="text-xs text-gray-500 space-y-1">
                                            <p>• Valores sujeitos a análise de risco</p>
                                            <p>• Condições especiais podem aplicar-se</p>
                                            <p>• Simulação válida por 30 dias</p>
                                        </div>
                                    </div>
                                ) : (
                                    <div className="text-center py-8 text-gray-600">
                                        <Calculator className="h-12 w-12 text-gray-400 mx-auto mb-4" />
                                        Preencha o formulário e clique em "Simular Prêmio"
                                    </div>
                                )}
                            </CardContent>
                        </Card>

                    </div>
                </div>
            </div>

            {/* MODAL DE PREVIEW */}
            <Dialog open={showPreviewModal} onOpenChange={setShowPreviewModal}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Confirmar Dados da Simulação</DialogTitle>
                        <DialogDescription>Revise os dados antes de calcular.</DialogDescription>
                    </DialogHeader>
                    <div className="text-sm space-y-1">
                        {Object.entries(formData).map(([k, v]) => (
                            <p key={k}><strong>{k}:</strong> {v}</p>
                        ))}
                    </div>
                    <DialogFooter className="flex justify-end gap-2 mt-4">
                        <Button variant="outline" onClick={() => setShowPreviewModal(false)}>Cancelar</Button>
                        <Button onClick={handleSimulation} disabled={isSimulating}>
                            {isSimulating ? <><Loader2 className="mr-2 h-4 w-4 animate-spin" />Calculando...</> :
                                <><Calculator className="mr-2 h-4 w-4" />Confirmar</>}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>
            <Dialog open={showEmailConfirmation} onOpenChange={setShowEmailConfirmation}>
                <DialogContent>
                    <DialogHeader>
                        <DialogTitle>Simulação Enviada</DialogTitle>
                        <DialogDescription>
                            A simulação foi enviada com sucesso para <strong>{emailRecipient || "o e-mail indicado"}</strong>.
                        </DialogDescription>
                    </DialogHeader>
                    <DialogFooter>
                        <Button onClick={() => setShowEmailConfirmation(false)}>Fechar</Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

        </div>
    )
}

// Componente auxiliar para inputs com rótulo
function InputWithLabel({ id, label, ...props }: any) {
    return (
        <div>
            <Label htmlFor={id}>{label}</Label>
            <Input id={id} {...props} />
        </div>
    )
}
