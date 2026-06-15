import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomProductItem extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CustomProductItem({
    super.key,
    required this.title,
    required this.price,
    required this.category,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6), // Off-white
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.lightBlueAccent.withOpacity(
            0.2,
          ), // Bordas azuladas claras
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // 1. IMAGEM DO PRODUTO (90x90)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.image, color: Colors.grey, size: 40.0),
            ),
          ),

          // 2. TEXTOS (Título, Valor e Categoria sutil abaixo)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  // Categoria exibida de forma sutil abaixo do valor
                  Text(
                    category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BOTÕES DE AÇÃO (Lixeira e Editar empilhados)
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão de Excluir (Vermelho)
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 54.0,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.delete, color: Colors.white, size: 16.0),
                        SizedBox(height: 2.0),
                        Text(
                          'EXCLUIR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8.0), // Espaçamento entre os dois botões
                // Botão de Editar (Azul do tema)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 54.0,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.edit, color: Colors.white, size: 16.0),
                        SizedBox(height: 2.0),
                        Text(
                          'EDITAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
