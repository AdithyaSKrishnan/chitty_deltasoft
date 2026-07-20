import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.03),
            ],
          ),

          border: Border.all(
            color: Colors.white10,
          ),
        ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    );
  }
}