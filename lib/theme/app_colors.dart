import 'package:flutter/material.dart';

class AppColors {
  // Construtor privado para evitar que a classe seja instanciada sem querer
  AppColors._();

  // --- CORES PRINCIPAIS ---
  static const Color primary = Colors.blueAccent;
  static const Color primaryLight = Color(
    0xFFF0F6FF,
  ); // Fundo azul lavado do botão pressionado
  static const Color background = Colors.white;

  // --- CORES DE AÇÃO E STATUS ---
  static const Color success = Color(
    0xFF00E676,
  ); // Verde de Confirmar e Mesa Livre
  static const Color danger =
      Colors.redAccent; // Vermelho de Cancelar, Excluir e Mesa Ocupada
  static const Color warning =
      Colors.amber; // Amarelo da interrogação do pop-up

  // --- TEXTOS ---
  static const Color textPrimary = Colors.black;
  static const Color textSecondary =
      Colors.grey; // Textos de apoio e subtítulos

  // --- BORDAS E SOMBRAS (Efeito 3D/Neomorfismo) ---
  static const Color borderLight = Color.fromARGB(
    255,
    215,
    215,
    215,
  ); // Cinza claro padrão
  static const Color shadowLight =
      Colors.black12; // Sombra externa suave (12% de opacidade)
  static const Color shadowDark =
      Colors.black; // Usado com opacidade na sombra interna
}
