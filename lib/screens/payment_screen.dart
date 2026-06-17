import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_button.dart';
import '../utils/payment_logic.dart';

class PaymentScreen extends StatefulWidget {
  final double totalConta;
  final int numeroDaMesa;

  const PaymentScreen({
    super.key,
    required this.totalConta,
    required this.numeroDaMesa,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String metodoSelecionado = '';

  // Variáveis de estado para o resumo financeiro (integração futura com Firestore)
  final double valorItensPagos = 0.0;
  final double valorCancelado = 0.0;

  // Rotina de exibição do modal de cálculo de troco para pagamentos em espécie
  void _abrirCalculadoraTroco(double valorTotal) {
    double valorRecebido = 0.0;
    TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            double troco = valorRecebido - valorTotal;
            if (troco < 0) troco = 0.0;

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calculate,
                      size: 48.0,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 12.0),
                    const Text(
                      'Calculadora de Troco',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    TextField(
                      controller: valorController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\,?\d*'),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          valorRecebido =
                              double.tryParse(value.replaceAll(',', '.')) ??
                                  0.0;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Valor recebido',
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: AppColors.success,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: troco > 0
                            ? AppColors.success.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Troco:',
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'R\$ ${troco.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: troco > 0
                                  ? AppColors.success
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      child: CustomBottomButton(
                        label: 'FINALIZAR',
                        icon: Icons.check_circle,
                        color: AppColors.success,
                        textColor: Colors.black,
                        onPressed: () => Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Componente construtor das opções de método de pagamento
  Widget _buildPaymentOption(IconData icon, String title, Color color) {
    bool isSelected = metodoSelecionado == title;
    return GestureDetector(
      onTap: () => setState(() => metodoSelecionado = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withValues(alpha: 0.3),
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: color),
            const SizedBox(height: 12.0),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 20.0,
                color: isSelected ? color : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double valorTotal = widget.totalConta;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'FECHAR CONTA', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Painel de exibição do valor total a ser pago
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Total a Pagar',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'R\$ ${valorTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Seção de seleção de métodos de pagamento
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.grey.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                Text(
                  'MÉTODO DE PAGAMENTO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.withValues(alpha: 0.6),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildPaymentOption(Icons.pix, 'PIX', Colors.teal),
                _buildPaymentOption(
                  Icons.credit_card,
                  'Crédito',
                  Colors.orange,
                ),
                _buildPaymentOption(Icons.credit_score, 'Débito', Colors.blue),
                _buildPaymentOption(Icons.payments, 'Dinheiro', Colors.green),
              ],
            ),
            const SizedBox(height: 32),
            Divider(color: Colors.grey.withValues(alpha: 0.2), thickness: 2.0),
            const SizedBox(height: 24),
            
            // Seção de resumo financeiro da composição da conta
            const Text(
              'Composição da Conta',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, width: 2),
              ),
              child: Column(
                children: [
                  PaymentUtils.buildSummaryRow(
                    'Subtotal consumido',
                    valorTotal,
                    Colors.grey[800]!,
                  ),
                  PaymentUtils.buildSummaryRow(
                    'Itens já pagos',
                    -valorItensPagos,
                    Colors.green[800]!,
                  ),
                  PaymentUtils.buildSummaryRow(
                    'Itens cancelados',
                    -valorCancelado,
                    Colors.grey[500]!,
                    isStrikethrough: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  PaymentUtils.buildSummaryRow(
                    'Falta Pagar',
                    valorTotal,
                    AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: CustomBottomButton(
                  label: 'CANCELAR',
                  icon: Icons.close,
                  color: AppColors.danger,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomBottomButton(
                  label: 'CONFIRMAR',
                  icon: Icons.check,
                  color: AppColors.success,
                  textColor: Colors.black,
                  onPressed: () => metodoSelecionado == 'Dinheiro'
                      ? _abrirCalculadoraTroco(valorTotal)
                      : Navigator.popUntil(context, (r) => r.isFirst),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}