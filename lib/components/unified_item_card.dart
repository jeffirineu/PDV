import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UnifiedItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  // Componente injetável para ações secundárias (ex: botões de incremento/decremento)
  final Widget trailing;
  // Parâmetro de controle de máquina de estado (ex: 'cancelado', 'pago')
  final String? status; 

  const UnifiedItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    required this.trailing,
    this.status, 
  });

  @override
  Widget build(BuildContext context) {
    // Avaliação do estado atual da entidade para renderização condicional
    bool isCancelled = status == 'cancelado';
    bool isPaid = status == 'pago';

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isCancelled
            ? Colors.grey[100]
            : (isPaid ? Colors.green[50] : Colors.white),
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: isCancelled
              ? Colors.grey[300]!
              : (isPaid ? Colors.green[200]! : AppColors.borderLight),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 4.0, 
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Placeholder de imagem com feedback visual de opacidade para itens invalidados
          Opacity(
            opacity: isCancelled ? 0.4 : 1.0,
            child: Container(
              width: 96.0,
              height: 96.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.grey,
                size: 48.0,
              ),
            ),
          ),
          const SizedBox(width: 18.0),

          // Metadados textuais do item com aplicação de escala par (Even scale)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0, // Escala ajustada (antigo 21.6)
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    color: isCancelled ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  category,
                  style: TextStyle(
                    color: isCancelled ? Colors.grey : Colors.grey[600],
                    fontSize: 16.0, // Escala ajustada (antigo 15.6)
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  price,
                  style: TextStyle(
                    color: isCancelled ? Colors.grey : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Escala ajustada (antigo 16.8)
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),

          // Substituição dinâmica do painel de controle interativo por badge estático caso pago
          isPaid
              ? const Icon(Icons.check_circle, color: Colors.green, size: 40.0)
              : trailing,
        ],
      ),
    );
  }
}