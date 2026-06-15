import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'custom_bottom_button.dart';

class ManageItemDialog extends StatefulWidget {
  final String itemName;
  final int initialQuantity;
  final VoidCallback onDelete;
  final VoidCallback onPay;

  const ManageItemDialog({
    super.key,
    required this.itemName,
    required this.initialQuantity,
    required this.onDelete,
    required this.onPay,
  });

  @override
  State<ManageItemDialog> createState() => _ManageItemDialogState();
}

class _ManageItemDialogState extends State<ManageItemDialog> {
  late TextEditingController _qtdController;
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity;
    // Inicializa o controlador com a quantidade atual recebida
    _qtdController = TextEditingController(text: _currentQuantity.toString());
  }

  @override
  void dispose() {
    _qtdController.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentQuantity++;
      _qtdController.text = _currentQuantity.toString();
    });
  }

  void _decrement() {
    if (_currentQuantity > 1) {
      setState(() {
        _currentQuantity--;
        _qtdController.text = _currentQuantity.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      backgroundColor: Colors.white,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ajusta o tamanho da coluna ao conteúdo
          children: [
            // Título do modal
            Text(
              'O que deseja fazer?',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),

            // Imagem representativa do item
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: Colors.grey.shade300, width: 2.0),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey, size: 48.0),
            ),
            const SizedBox(height: 16.0),

            // Exibição do nome do item passado por parâmetro
            Text(
              widget.itemName,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),

            // Controles de quantidade (decremento, campo de texto, incremento)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionSquare(Icons.remove, AppColors.danger, _decrement),
                const SizedBox(width: 16.0),

                // Campo de entrada manual da quantidade
                SizedBox(
                  width: 80.0,
                  child: TextField(
                    controller: _qtdController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // Limita a entrada apenas para caracteres numéricos
                    ],
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _currentQuantity = int.parse(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16.0),

                _buildActionSquare(Icons.add, AppColors.primary, _increment),
              ],
            ),
            const SizedBox(height: 32.0),

            // Botões de ação principal
            Row(
              children: [
                Expanded(
                  child: CustomBottomButton(
                    label: 'APAGAR',
                    icon: Icons.delete_sweep,
                    color: AppColors.danger,
                    textColor: Colors.white,
                    onPressed: widget.onDelete,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomBottomButton(
                    label: 'PAGAR',
                    icon: Icons.payments,
                    color: AppColors.success,
                    textColor: Colors.black,
                    onPressed: widget.onPay,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir os botões de incremento e decremento
  Widget _buildActionSquare(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1), // Atualizado para evitar o uso de withOpacity depreciado
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: color, width: 2.0),
        ),
        child: Icon(icon, color: color, size: 24.0),
      ),
    );
  }
}
