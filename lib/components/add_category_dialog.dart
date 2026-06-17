import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddCategoryDialog extends StatelessWidget {
  const AddCategoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      title: const Center(
        child: Text(
          'NOVA CATEGORIA',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Restringe a dimensão vertical ao tamanho estrito do conteúdo
        children: [
          // Componente visual reservado para a inserção de imagem
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_a_photo, color: Colors.grey, size: 32.0),
                SizedBox(height: 4.0),
                Text(
                  'FOTO',
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Campo de entrada de dados para a nomenclatura da categoria
          TextField(
            decoration: InputDecoration(
              hintText: 'NOME DA CATEGORIA',
              hintStyle: TextStyle(
                color: Colors.grey.withValues(alpha: 0.5),
                fontSize: 14.0,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Remove a instância do modal da pilha de navegação
          child: const Text(
            'CANCELAR',
            style: TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            // Rotina temporária de confirmação de persistência
            print("Categoria salva!");
            Navigator.pop(context); // Finaliza o fluxo e fecha o modal
          },
          child: const Text(
            'SALVAR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
