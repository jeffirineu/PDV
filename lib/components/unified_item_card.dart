import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UnifiedItemCard extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  final Widget trailing;
  final String? status; // <-- ESSA LINHA É OBRIGATÓRIA

  const UnifiedItemCard({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    required this.trailing,
    this.status, // <-- E ESSA LINHA TAMBÉM
  });

  @override
  Widget build(BuildContext context) {
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
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Foto com opacidade se cancelado
          Opacity(
            opacity: isCancelled ? 0.4 : 1.0,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2.0),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.grey,
                size: 48,
              ),
            ),
          ),
          const SizedBox(width: 18.0),

          // Informações de texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21.6,
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                    color: isCancelled ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  category,
                  style: TextStyle(
                    color: isCancelled ? Colors.grey : Colors.grey[600],
                    fontSize: 15.6,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  price,
                  style: TextStyle(
                    color: isCancelled ? Colors.grey : AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.8,
                    decoration: isCancelled ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),

          // Botões de ação ou status de pago
          isPaid
              ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
              : trailing,
        ],
      ),
    );
  }
}
