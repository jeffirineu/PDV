import 'package:flutter/material.dart';

class CustomSelectableCategory extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomSelectableCategory({
    super.key,
    required this.title,
    required this.icon,
    // Valor padrão (false) para inicializar o componente no estado inativo
    this.isSelected = false, 
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define a cor do item com base no estado de seleção
    final Color itemColor = isSelected ? Colors.red : Colors.grey;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: itemColor,
              size: 38.0, // Escala gráfica ajustada
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0, // Escala tipográfica
                color: itemColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
