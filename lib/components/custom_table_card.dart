import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
// import '../theme/app_text_styles.dart'; // Omitido aqui pois definimos os estilos direto no card

class CustomTableCard extends StatelessWidget {
  final int tableNumber;
  final bool isOccupied;
  final VoidCallback onTap;

  const CustomTableCard({
    super.key,
    required this.tableNumber,
    required this.isOccupied,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Fundo puxando a cor real do estado
    final Color stateColor = isOccupied ? AppColors.danger : AppColors.success;

    // Constante para o contorno suave (reaproveitada no título e no número)
    const List<Shadow> softOutline = [
      Shadow(offset: Offset(-1, -1), color: Colors.black38, blurRadius: 2.0),
      Shadow(offset: Offset(1, -1), color: Colors.black38, blurRadius: 2.0),
      Shadow(offset: Offset(-1, 1), color: Colors.black38, blurRadius: 2.0),
      Shadow(offset: Offset(1, 1), color: Colors.black38, blurRadius: 2.0),
    ];

    return GestureDetector(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: stateColor, // Fundo todo vermelho ou todo verde
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                // 1. TÍTULO FIXADO NO TOPO (+50% de tamanho e Contorno)
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'MESA',
                      style: TextStyle(
                        fontSize:
                            22.0, // Aumentado para 22 seguindo boas práticas
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                        shadows: softOutline, // Efeito de contorno suave
                      ),
                    ),
                  ),
                ),

                // 2. NÚMERO FIXADO NO CENTRO ABSOLUTO (+10% de tamanho e Contorno)
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$tableNumber',
                    style: TextStyle(
                      fontSize:
                          constraints.maxHeight * 0.51, // Exatos 51% da altura
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                      shadows: softOutline, // Efeito de contorno suave
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
