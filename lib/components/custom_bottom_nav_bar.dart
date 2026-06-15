import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPillButton(0, 'MESAS'),
          _buildPillButton(1, 'CARDÁPIO'),
          _buildPillButton(2, 'VENDAS'),
        ],
      ),
    );
  }

  Widget _buildPillButton(int index, String label) {
    bool isSelected = currentIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),

              // BORDAS COM MEDIDAS EXATAS DO FIGMA
              border: Border.all(
                color: isSelected
                    ? Colors.lightBlue
                    // Borda A2A2A2 com 70% de opacidade no estado não pressionado
                    : const Color(0xFFA2A2A2).withOpacity(0.7),
                width: isSelected ? 2.0 : 1.0,
              ),

              // SOMBRA EXTERNA COM MEDIDAS EXATAS DO FIGMA
              boxShadow: isSelected
                  ? [] // Sem sombra externa quando pressionado
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25), // Preto 25%
                        blurRadius: 4.0, // Desfoque = 4
                        spreadRadius: 0.0, // Distribuição = 0
                        offset: const Offset(0, 4), // X = 0, Y = 4
                      ),
                    ],
            ),

            // SOMBRA INTERNA (Estado Pressionado)
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.25)),
                          const BoxShadow(
                            color: Colors.white,
                            spreadRadius: 0.0,
                            blurRadius: 6.0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      )
                    : null,
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
