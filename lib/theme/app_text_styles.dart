import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importamos as cores para usar nos textos

class AppTextStyles {
  // Construtor privado para proteção
  AppTextStyles._();

  // --- TÍTULOS GIGANTES ---
  // Usado para: Valor Total na tela de pagamento, Número da mesa no grid
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

  // --- TÍTULOS E CABEÇALHOS ---
  // Usado para: AppBar, Títulos de Pop-ups (ex: "EXCLUIR PRODUTO?")
  static const TextStyle title = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // --- BOTÕES E DESTAQUES ---
  // Usado para: Textos dentro dos botões (CONFIRMAR, CANCELAR) e nomes de produtos
  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // --- TEXTO CORRIDO (CORPO) ---
  // Usado para: Textos explicativos, descrições secundárias
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

  // --- TEXTOS PEQUENOS (LEGENDAS) ---
  // Usado para: "Livre" ou "Ocupada" debaixo da mesa, ícones pequenos
  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textSecondary,
  );
}
