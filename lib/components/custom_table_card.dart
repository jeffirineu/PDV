import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

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
    // Definição da cor do card baseada no estado de ocupação (danger/success)
    final Color stateColor = isOccupied ? AppColors.danger : AppColors.success;

    // Lista de sombras para renderização do contorno tipográfico de legibilidade
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
              color: stateColor,
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
                // Identificador fixo posicionado no topo
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.0),
                    child: Text(
                      'MESA',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                        shadows: softOutline,
                      ),
                    ),
                  ),
                ),

                // Valor numérico posicionado centralmente
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    '$tableNumber',
                    style: TextStyle(
                      fontSize: constraints.maxHeight * 0.51, // Escalonamento proporcional à altura
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.0,
                      shadows: softOutline,
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
