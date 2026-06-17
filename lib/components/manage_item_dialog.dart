import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import 'custom_bottom_button.dart';

class ManageItemDialog extends StatefulWidget {
  final String itemName;
  final int initialQuantity;
  // Callbacks para delegação de eventos de manipulação da entidade
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
  // Controladores de estado local para gestão quantitativa
  late TextEditingController _qtdController;
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity;
    // Inicialização do controlador de texto com o estado numérico injetado
    _qtdController = TextEditingController(text: _currentQuantity.toString());
  }

  @override
  void dispose() {
    // Desalocação de recursos em memória para evitar vazamentos (memory leaks)
    _qtdController.dispose();
    super.dispose();
  }

  // Mutação de estado progressiva
  void _increment() {
    setState(() {
      _currentQuantity++;
      _qtdController.text = _currentQuantity.toString();
    });
  }

  // Mutação de estado regressiva com trava de limite inferior estrito
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
    // Base estrutural do componente modal flutuante
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      backgroundColor: Colors.white,
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // Contração do eixo principal para adaptação dinâmica ao conteúdo (Wrap Content)
          mainAxisSize: MainAxisSize.min, 
          children: [
            // Cabeçalho tipográfico de instrução de contexto
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

            // Placeholder estrutural para representação gráfica do item (Thumbnail)
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

            // Rótulo textual referenciando a entidade injetada via parâmetro
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

            // Painel de controle interativo para manipulação do estado quantitativo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildActionSquare(Icons.remove, AppColors.danger, _decrement),
                const SizedBox(width: 16.0),

                // Componente de entrada bidirecional (Manual Input/Display)
                SizedBox(
                  width: 80.0,
                  child: TextField(
                    controller: _qtdController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      // Filtro de validação de entrada estrita para caracteres numéricos
                      FilteringTextInputFormatter.digitsOnly, 
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
                      // Sincronização do estado em tempo real durante a digitação
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

            // Painel de submissão de ações de fechamento de ciclo (Exclusão/Pagamento)
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

  // Componente utilitário de composição visual para os controles de incremento e decremento
  Widget _buildActionSquare(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          // Definição de opacidade aderente às especificações recentes do framework
          color: color.withValues(alpha: 0.1), 
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: color, width: 2.0),
        ),
        child: Icon(icon, color: color, size: 24.0),
      ),
    );
  }
}