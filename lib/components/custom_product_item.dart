import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomProductItem extends StatelessWidget {
  final String title;
  final String price;
  final String category;
  // Callbacks para manipulação do estado da entidade
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
        color: const Color(0xFFFAF9F6), 
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.lightBlueAccent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          // Container para exibição da imagem do produto (Placeholder de 90x90)
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

          // Bloco de informações textuais (Identificação, Precificação e Classificação)
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
                  // Renderização do metadado de classificação (Categoria)
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

          // Painel de controles de gerenciamento (Ações de Exclusão e Edição em empilhamento vertical)
          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ação destrutiva (Exclusão)
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    width: 54.0,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      children: [
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

                const SizedBox(height: 8.0), 
                
                // Ação de retificação (Edição)
                GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 54.0,
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Column(
                      children: [
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
