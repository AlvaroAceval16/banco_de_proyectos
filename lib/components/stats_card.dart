import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String number;
  final String subtitle;

  const StatsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.number,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            spacing: 8,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFF5285E8),
                child: Icon(icon, color: Colors.black, size: 20),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            number,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.green,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                "Ver todo",
                style: TextStyle(
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Icon(Icons.arrow_forward, size: 14, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }
}
