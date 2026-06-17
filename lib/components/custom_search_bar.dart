import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  
  // Definição estrutural do tipo de teclado para adequação do input de dados
  final TextInputType keyboardType; 

  const CustomSearchBar({
    super.key,
    this.hintText = 'Buscar...',
    required this.onChanged,
    // Valor padrão (number) otimizado para o escopo principal de busca por identificador de mesa
    this.keyboardType = TextInputType.number, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.borderLight, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: AppTextStyles.bodyBold,
        // Injeção de dependência para adaptação dinâmica do teclado virtual
        keyboardType: keyboardType, 
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.body,
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 20.0,
          ),
        ),
      ),
    );
  }
}
