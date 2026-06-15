import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomConsumedItem extends StatelessWidget {
  final String title;
  final String price;
  final int quantity;
  final VoidCallback onManage; // Dispara a caixa de diálogo de retificação

  const CustomConsumedItem({
    super.key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.lightBlueAccent.withOpacity(0.2),
          width: 2.0, // Escala par
        ),
      ),
      child: Row(
        children: [
          // Foto Padronizada em 90x90
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey, size: 40.0),
            ),
          ),

          // Nome e Valor Ajustados para escala par (20.0)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bloco de Ações (Quantidade e Lápis de Gestão)
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                // Indicador de Quantidade
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.shade300, width: 2.0),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Qtd.',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$quantity',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),

                // ÍCONE DO LÁPIS (Acessibilidade para alteração/retificação)
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: Colors
                        .blueGrey[600], // Cor neutra que indica gerenciamento
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    onPressed: onManage, // Abre o pop-up
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
