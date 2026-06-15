import 'package:flutter/material.dart';

class CustomBottomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;

  const CustomBottomButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.white,
              child: Icon(icon, color: color, size: 16.0),
            ),
            const SizedBox(width: 8.0),
            Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
