import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/components/custom_button_component.dart';
import 'package:nossa_app_hackton/src/presentation/pages/payment_page/payment_page.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/navigator_util.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  final formKey = GlobalKey<FormState>();
  final matriculaController = TextEditingController();
  
  String? selectedMarca;
  String? selectedModelo;
  DateTime? dataPrimeiraMatricula;
  String? selectedEscalaoCapital;
  final String _categoria = "Ligeiro Particular";
  String cilindrada      = "";
  String fraccionamento  = "Mensal";
  
  DateTime? dataInicio;
  
  double? premioEstimado;
  bool showResult = false;

  final Map<String, List<String>> modelosPorMarca = {
    'Toyota': ['Corolla', 'RAV4'],
    'Hyundai': ['Elantra', 'Tucson'],
  };

  final Map<String, String> cilindradaPorModelo = {
    'Corolla': 'Entre 1.601 CC e 2.000 CC',
    'RAV4': 'Entre 2.001 CC e 2.500 CC',
    'Elantra': 'Entre 1.601 CC e 2.000 CC',
    'Tucson': 'Entre 2.001 CC e 2.500 CC',
  };

  final List<Map<String, String>> escalaoCapital = [
    {'value': 'A', 'label': 'A - 13.376.000,00 AKZ'},
    {'value': 'B', 'label': 'B - 26.752.000,00 AKZ'},
    {'value': 'C', 'label': 'C - 40.128.000,00 AKZ'},
  ];

  final List<String> fraccionamentoOptions = [
    'Mensal',
    'Trimestral',
    'Semestral',
    'Anual'
  ];

  final double valorBase = 10000.0;

  final List<Map<String, dynamic>> matrizSimulacao = [
    {
      'marca': 'Toyota',
      'modelo': 'Corolla',
      'cilindrada': 1300,
      'escalaoCapital': 'A',
      'fraccionamento': 'Mensal',
      'factorBase': 1.0,
      'factorEscalao': 1.0,
      'factorFraccionamento': 1.0,
    },
    {
      'marca': 'Toyota',
      'modelo': 'RAV4',
      'cilindrada': 2000,
      'escalaoCapital': 'B',
      'fraccionamento': 'Mensal',
      'factorBase': 1.2,
      'factorEscalao': 1.1,
      'factorFraccionamento': 1.0,
    },
    {
      'marca': 'Hyundai',
      'modelo': 'Elantra',
      'cilindrada': 1600,
      'escalaoCapital': 'B',
      'fraccionamento': 'Mensal',
      'factorBase': 1.1,
      'factorEscalao': 1.1,
      'factorFraccionamento': 1.0,
    },
    {
      'marca': 'Hyundai',
      'modelo': 'Tucson',
      'cilindrada': 2200,
      'escalaoCapital': 'C',
      'fraccionamento': 'Mensal',
      'factorBase': 1.3,
      'factorEscalao': 1.2,
      'factorFraccionamento': 1.0,
    },
  ];

  final Map<String, double> factoresFraccionamento = {
    'Mensal': 1.0,
    'Trimestral': 0.95, 
    'Semestral': 0.90, 
    'Anual': 0.85,
  };

  @override
  void dispose() {
    matriculaController.dispose();
    super.dispose();
  }

  void onMarcaChanged(String? value) {
    setState(() {
      selectedMarca = value;
      selectedModelo = null;
      cilindrada = "";
      showResult = false;
    });
  }

  void onModeloChanged(String? value) {
    setState(() {
      selectedModelo = value;
      if (value != null) {
        cilindrada = cilindradaPorModelo[value] ?? "";
      }
      showResult = false;
    });
  }

  double calcularPremio() {
    if (selectedMarca == null || selectedModelo == null || selectedEscalaoCapital == null) {
      return 0.0;
    }
    Map<String, dynamic>? configuracao = matrizSimulacao.firstWhere(
      (config) => 
        config['marca'] == selectedMarca && 
        config['modelo'] == selectedModelo &&
        config['escalaoCapital'] == selectedEscalaoCapital,
      orElse: () => {},
    );

    if (configuracao.isEmpty) {
      configuracao = {
        'factorBase': 1.0,
        'factorEscalao': _getFactorEscalao(selectedEscalaoCapital!),
        'factorFraccionamento': 1.0,
      };
    }

    double factorFraccionamento = factoresFraccionamento[fraccionamento] ?? 1.0;
    double premio = valorBase * configuracao['factorBase'] * configuracao['factorEscalao'] * factorFraccionamento;

    return premio;
  }

  double _getFactorEscalao(String escalao) {
    switch (escalao) {
      case 'A':
        return 1.0;
      case 'B':
        return 1.1;
      case 'C':
        return 1.2;
      default:
        return 1.0;
    }
  }

  String _formatCurrency(double value) {
    return '${value.toStringAsFixed(2).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )} AKZ';
  }

  Future<void> _selectDate(BuildContext context, bool isPrimeiraMatricula) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'PT'),
    );
    
    if (picked != null) {
      setState(() {
        if (isPrimeiraMatricula) {
          dataPrimeiraMatricula = picked;
        } else {
          dataInicio = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void simulation() {
    if (formKey.currentState!.validate()) {
      if (dataPrimeiraMatricula == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecione a data da 1ª matrícula'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      if (dataInicio == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecione a data de início'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      double premio = calcularPremio();
      
      setState(() {
        premioEstimado = premio;
        showResult = true;
      });

      showModalBottomSheet(
        context: context, 
        builder: (ctx) => _buildConfirmData()
      );
    }
  }

  Widget _buildResult() {
    if (!showResult || premioEstimado == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Text(
            'Resultado da Simulação de Seguro Automóvel',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppConstsUtils.primaryColor,
            ),
          ),
          const Divider(height: 20),
          
          _buildSummaryRow('Marca:', selectedMarca ?? ''),
          _buildSummaryRow('Modelo:', selectedModelo ?? ''),
          _buildSummaryRow('Categoria:', _categoria),
          _buildSummaryRow('Cilindrada:', cilindrada),
          _buildSummaryRow('Escalão de Capital:', escalaoCapital.firstWhere((e) => e['value'] == selectedEscalaoCapital)['label'] ?? ''),
          _buildSummaryRow('Fraccionamento:', fraccionamento),
          
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppConstsUtils.secondaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstsUtils.secondaryColor,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Text(
                  'O seu prémio está estimado em ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(         
                  '${_formatCurrency(premioEstimado!)} /mês. ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  'Adira já, em 3 minutos, e evite constrangimentos financeiros!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          Text(
            '* Valores estimados para fins de simulação. Os valores reais podem variar.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),

          CustomButtonComponent(
            text: "Aderir",
            backgroundColor: AppConstsUtils.secondaryColor,
            onPressed: () => NavigatorUtils.goTo(context, page: PaymentPage()),
          )
        ],
      ),
    );
  }


  Widget _buildConfirmData() {
    if (!showResult || premioEstimado == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          Text(
            'Confirmar Dados',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppConstsUtils.primaryColor,
            ),
          ),
          const Divider(height: 20),
          
          _buildSummaryRow('Marca:', selectedMarca ?? ''),
          _buildSummaryRow('Modelo:', selectedModelo ?? ''),
          _buildSummaryRow('Categoria:', _categoria),
          _buildSummaryRow('Cilindrada:', cilindrada),
          _buildSummaryRow("Data da 1º matrícula:", _formatDate(dataPrimeiraMatricula)),
          _buildSummaryRow("Matrícula:", matriculaController.text),
          _buildSummaryRow("Data de início", _formatDate(dataInicio)),

          _buildSummaryRow('Escalão de Capital:', escalaoCapital.firstWhere((e) => e['value'] == selectedEscalaoCapital)['label'] ?? ''),
          _buildSummaryRow('Fraccionamento:', fraccionamento),
          
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CustomButtonComponent(
                  text: "Simular",
                  backgroundColor: AppConstsUtils.secondaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(context: context, builder: (ctx) => _buildResult());
                  },
                )
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButtonComponent(
                  text: "Editar",
                  onPressed: () => Navigator.pop(context),
                )
              ),

            ],
          ),
          
          
          const SizedBox(height: 12),
          Text(
            'Verifique os dados antes de confirmar. Caso necessário, corrija os dados.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulação de S. de Automóvel'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Preencha os campos abaixo de forma correcta para simular o seguro de automóvel',
              style: TextStyle(
                color: Colors.grey
              ),
            ),
            const SizedBox(height: 20),

            // Marca e Modelo
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedMarca,
                    items: modelosPorMarca.keys.map((String marca) {
                      return DropdownMenuItem(
                        value: marca,
                        child: Text(marca),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      labelText: "Marca *",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecione uma marca';
                      }
                      return null;
                    },
                    onChanged: onMarcaChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedModelo,
                    items: selectedMarca != null
                        ? modelosPorMarca[selectedMarca]!.map((String modelo) {
                            return DropdownMenuItem(
                              value: modelo,
                              child: Text(modelo),
                            );
                          }).toList()
                        : [],
                    decoration: const InputDecoration(
                      labelText: "Modelo *",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecione um modelo';
                      }
                      return null;
                    },
                    onChanged: onModeloChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: "Categoria",
              ),
              readOnly: true,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: TextEditingController(text: cilindrada),
              decoration: const InputDecoration(
                labelText: "Cilindrada",
              ),
              readOnly: true,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () => _selectDate(context, true),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Data da 1ª matrícula *",
                  suffixIcon: Icon(CupertinoIcons.calendar),
                ),
                child: Text(
                  _formatDate(dataPrimeiraMatricula).isEmpty 
                      ? 'Selecione a data' 
                      : _formatDate(dataPrimeiraMatricula),
                  style: TextStyle(
                    color: _formatDate(dataPrimeiraMatricula).isEmpty 
                        ? Colors.grey[600] 
                        : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: matriculaController,
              decoration: const InputDecoration(
                labelText: "Matrícula *",
                hintText: "Ex: LD-12-34-AB",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor insira a matrícula';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedEscalaoCapital,
              items: escalaoCapital.map((escalao) {
                return DropdownMenuItem(
                  value: escalao['value'],
                  child: Text(escalao['label']!),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Escalão de capital *",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor selecione um escalão de capital';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  selectedEscalaoCapital = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Fraccionamento
            DropdownButtonFormField<String>(
              value: fraccionamento,
              items: fraccionamentoOptions.map((String option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              decoration: const InputDecoration(labelText: "Fraccionamento"),
              onChanged: (value) => setState(() => fraccionamento = value!)
            ),
            const SizedBox(height: 16),

            InkWell(
              onTap: () => _selectDate(context, false),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: "Data de início *",
                  suffixIcon: Icon(CupertinoIcons.calendar),
                ),
                child: Text(
                  _formatDate(dataInicio).isEmpty 
                      ? 'Selecione a data' 
                      : _formatDate(dataInicio),
                  style: TextStyle(
                    color: _formatDate(dataInicio).isEmpty 
                        ? Colors.grey[600] 
                        : Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            CustomButtonComponent(
              text: "Simular",
              onPressed: simulation,
            )
          ],
        ),
      ),
    );
  }
}