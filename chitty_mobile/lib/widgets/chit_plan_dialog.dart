import 'package:flutter/material.dart';

class ChitPlanDialog extends StatelessWidget {
  const ChitPlanDialog({super.key});

  Widget field(String hint) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF0F172A),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(16),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor: Colors.transparent,

      child: Container(

        width: 500,

        padding: const EdgeInsets.all(28),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
        ),

        child: SingleChildScrollView(

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Create Chit Plan',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                children: [

                  Expanded(
                    child:
                        field('Plan Name'),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child:
                        field('Plan Code'),
                  ),
                ],
              ),

              field('Total Amount'),

              Row(
                children: [

                  Expanded(
                    child: field(
                      'Number of Installments',
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: field(
                      'Monthly Payment',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(

                    onPressed: () {},

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Create Plan',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}