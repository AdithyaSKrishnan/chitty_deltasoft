import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {

  final String title;
  final Widget child;

  const InfoContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(24),

        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.06),
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

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}