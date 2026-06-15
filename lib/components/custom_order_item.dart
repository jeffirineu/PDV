import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomOrderItem extends StatelessWidget {
  final String title;
  final String price;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const CustomOrderItem({
    super.key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9F6),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.lightBlueAccent.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 90.0,
              height: 90.0,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey, size: 40.0),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20.0, // Arredondado para 20
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 20.0, // Arredondado para 20
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onDecrement,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.danger.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.danger,
                      size: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 20.0, // Arredondado para 20
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onIncrement,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(6.0),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
