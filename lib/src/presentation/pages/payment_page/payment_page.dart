import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nossa_app_hackton/src/presentation/components/custom_button_component.dart';
import 'package:nossa_app_hackton/src/presentation/pages/home_page/home_page.dart';
import 'package:nossa_app_hackton/src/presentation/utils/app_consts_utils.dart';
import 'package:nossa_app_hackton/src/presentation/utils/navigator_util.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _nifController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  String? _metodoPagamento;
  bool _aceitaTermos = false;
  bool _isProcessing = false;

  final List<String> _metodosPagamento = [
    'Transferência',
    'Referência Multicaixa',
    'BAI Paga'
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _nifController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscrição de Seguro'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dados do Tomador do Seguro',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstsUtils.fontBold
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildNomeField(),
                    const SizedBox(height: 16),
                    _buildNifField(),
                    const SizedBox(height: 16),
                    _buildTelefoneField(),
                    const SizedBox(height: 16),
                    _buildEmailField(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Método de Pagamento',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstsUtils.fontBold
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    _buildMetodoPagamentoDropdown(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildTermosCheckbox(),
              ),
              const SizedBox(height: 30),
              _buildConfirmarButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNomeField() {
    return TextFormField(
      controller: _nomeController,
      decoration: const InputDecoration(
        labelText: 'Nome Completo *',
        hintText: 'Digite o seu nome completo',
        prefixIcon: Icon(CupertinoIcons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nome é obrigatório';
        }
        if (value.trim().length < 3) {
          return 'Nome deve ter pelo menos 3 caracteres';
        }
        return null;
      },
    );
  }

  Widget _buildNifField() {
    return TextFormField(
      controller: _nifController,
      decoration: const InputDecoration(
        labelText: 'NIF *',
        hintText: 'Digite o seu NIF',
        prefixIcon: Icon(CupertinoIcons.doc),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'NIF é obrigatório';
        }
        if (value.trim().length < 9) {
          return 'NIF deve ter pelo menos 9 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildTelefoneField() {
    return TextFormField(
      controller: _telefoneController,
      decoration: const InputDecoration(
        labelText: 'Número de Telefone *',
        hintText: 'Digite o seu número de telefone',
        prefixIcon: Icon(CupertinoIcons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Número de telefone é obrigatório';
        }
        if (value.trim().length < 9) {
          return 'Número de telefone inválido';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'E-mail *',
        hintText: 'Digite o seu e-mail',
        prefixIcon: Icon(CupertinoIcons.mail),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'E-mail é obrigatório';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'E-mail inválido';
        }
        return null;
      },
    );
  }

  Widget _buildMetodoPagamentoDropdown() {
    return DropdownButtonFormField<String>(
      value: _metodoPagamento,
      decoration: const InputDecoration(
        labelText: 'Selecione o método de pagamento *',
        prefixIcon: Icon(CupertinoIcons.money_dollar),
      ),
      items: _metodosPagamento.map((String metodo) {
        return DropdownMenuItem<String>(
          value: metodo,
          child: Text(metodo),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _metodoPagamento = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Método de pagamento é obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildTermosCheckbox() {
    return CheckboxListTile(
      title: const Text(
        'Aceito os Termos e Condições *',
        style: TextStyle(fontSize: 16),
      ),
      subtitle: const Text(
        'Li e concordo com os termos e condições do seguro',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
      value: _aceitaTermos,
      onChanged: (bool? value) {
        setState(() {
          _aceitaTermos = value ?? false;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.blue[700],
    );
  }

  Widget _buildConfirmarButton() {
    return _isProcessing 
      ? Center(child: const CircularProgressIndicator())
      : CustomButtonComponent(
      onPressed: _isProcessing ? null : _confirmarSubscricao,
      text: 'Confirmar Subscrição',
    );
  }

  Widget _buildSuccess() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 100,
            color: AppConstsUtils.secondaryColor,
          ),
          const SizedBox(height: 10),
          
          Text(
            'Sucesso!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstsUtils.secondaryColor,
            ),
          ),
          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'A sua subscrição foi concluída com sucesso. Receberá a apólice por e-mail nas próximas horas.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontFamily: AppConstsUtils.fontRegular
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          CustomButtonComponent(
            onPressed: () => NavigatorUtils.gotoWithoutReturn(context, page: HomePage()),
            text: 'Voltar à Página Inicial',
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarSubscricao() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    if (!_aceitaTermos) {
      _showErrorSnackBar('Deve aceitar os Termos e Condições para continuar.');
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 3));

      setState(() {
        _isProcessing = false;
      });

      if(mounted) {
        showDialog(
          barrierDismissible: false,
          context: context, 
          builder: (ctx) => Dialog(
            child: _buildSuccess(),
          )
        );
      }

    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      _showErrorSnackBar('Erro ao processar pagamento. Tente novamente.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}