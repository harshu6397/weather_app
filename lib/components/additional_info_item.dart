
import 'package:flutter/material.dart';

class AdditionalDetailsCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const AdditionalDetailsCard(
    this.title,
    this.value,
    this.unit,
    this.icon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            size: 40,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "$value $unit",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}