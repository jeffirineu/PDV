import 'package:flutter/material.dart';

class PaymentUtils {
  static double calcularTotal(
    double subtotal,
    double pagos,
    double cancelados,
  ) {
    return subtotal - pagos - cancelados;
  }

  static Widget buildSummaryRow(
    String label,
    double value,
    Color color, {
    bool isStrikethrough = false,
  }) {
    String formattedValue = value < 0
        ? '- R\$ ${value.abs().toStringAsFixed(2).replaceAll('.', ',')}'
        : 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: _textStyle(color, isStrikethrough, false)),
        Text(formattedValue, style: _textStyle(color, isStrikethrough, true)),
      ],
    );
  }

  static TextStyle _textStyle(Color color, bool strike, bool bold) => TextStyle(
    fontSize: 16.0,
    color: color,
    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
    decoration: strike ? TextDecoration.lineThrough : TextDecoration.none,
  );
}
