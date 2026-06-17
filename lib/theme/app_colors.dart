import 'package:flutter/material.dart';

class AppColors {
  // Construtor privado para impedir a instanciação desta classe utilitária
  AppColors._();

  // ==========================================
  // CORES PRIMÁRIAS E DE FUNDO
  // ==========================================
  static const Color primary = Colors.blueAccent;
  
  // Tonalidade clara para estados de interação e seleção
  static const Color primaryLight = Color(0xFFF0F6FF); 
  
  static const Color background = Colors.white;

  // ==========================================
  // CORES DE SEMÂNTICA E STATUS
  // ==========================================
  
  // Indicador de sucesso e disponibilidade estrutural
  static const Color success = Color(0xFF00E676); 
  
  // Indicador de alerta crítico, cancelamento e indisponibilidade
  static const Color danger = Colors.redAccent; 
  
  // Indicador de aviso e requisições pendentes
  static const Color warning = Colors.amber; 

  // ==========================================
  // TIPOGRAFIA
  // ==========================================
  static const Color textPrimary = Colors.black;
  
  // Cor aplicada a elementos textuais auxiliares e legendas
  static const Color textSecondary = Colors.grey; 

  // ==========================================
  // BORDAS E EFEITOS DE PROFUNDIDADE
  // ==========================================
  
  // Valoração padrão para delimitadores e contornos estruturais
  static const Color borderLight = Color.fromARGB(255, 215, 215, 215); 
  
  // Projeção de sombra de baixa densidade (12% de opacidade fixa)
  static const Color shadowLight = Colors.black12; 
  
  // Base de sombreamento para aplicação dinâmica de opacidade
  static const Color shadowDark = Colors.black; 
}