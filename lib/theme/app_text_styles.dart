import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importação do catálogo de cores para estruturação tipográfica

class AppTextStyles {
  // Construtor privado para impedir a instanciação desta classe utilitária
  AppTextStyles._();

  // ==========================================
  // TIPOGRAFIA DE EXIBIÇÃO (DISPLAY)
  // Utilizada para métricas e componentes de alta hierarquia visual
  // ==========================================
  static const TextStyle display = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ==========================================
  // TIPOGRAFIA DE CABEÇALHOS (TITLE)
  // Utilizada para barras de navegação e títulos de componentes modais
  // ==========================================
  static const TextStyle title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ==========================================
  // TIPOGRAFIA DE AÇÃO E ÊNFASE (BUTTON/LABEL)
  // Utilizada em controles interativos e identificação nominal de entidades
  // ==========================================
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ==========================================
  // TIPOGRAFIA DE CORPO (BODY)
  // Utilizada para estruturação de blocos informativos e metadados
  // ==========================================
  static const TextStyle body = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ==========================================
  // TIPOGRAFIA AUXILIAR (CAPTION)
  // Utilizada para legendas contextuais, badges e indicadores de status
  // ==========================================
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
}
