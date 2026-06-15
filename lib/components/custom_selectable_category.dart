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
    this.isSelected = false, // Por padrão, não está selecionado
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Se estiver selecionado no futuro modo de exclusão, fica vermelho. Senão, cinza.
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
              size: 38.0, // Aumentado em 20%
            ),
            const SizedBox(height: 6.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0, // Aumentado em 20%
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
