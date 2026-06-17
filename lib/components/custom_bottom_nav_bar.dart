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

              // Controle de espessura e tonalidade da borda com base no estado ativo/inativo
              border: Border.all(
                color: isSelected
                    ? Colors.lightBlue
                    : const Color(0xFFA2A2A2).withValues(alpha: 0.7),
                width: isSelected ? 2.0 : 1.0,
              ),

              // Projeção de sombra externa (drop shadow) exclusiva para o estado inativo
              boxShadow: isSelected
                  ? [] 
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25), 
                        blurRadius: 4.0, 
                        spreadRadius: 0.0, 
                        offset: const Offset(0, 4), 
                      ),
                    ],
            ),

            // Composição de sombra interna (inner shadow) aplicada ao estado ativo
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.25)),
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
