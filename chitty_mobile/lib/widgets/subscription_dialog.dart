import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SubscriptionDialog extends StatefulWidget {
  const SubscriptionDialog({super.key});

  @override
  State<SubscriptionDialog> createState() =>
      _SubscriptionDialogState();
}

class _SubscriptionDialogState
    extends State<SubscriptionDialog> {
  int? selectedCustomerId;
  int? selectedPlanId;

  List<dynamic> customers = [];
  List<dynamic> plans = [];
  bool isLoading = true;
  String? errorMessage;

  final TextEditingController
      dateController =
      TextEditingController(
    text: '09-06-2026',
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedCustomers = await AuthService.getCustomers();
      final fetchedPlans = await AuthService.getChitPlans();

      setState(() {
        customers = fetchedCustomers;
        plans = fetchedPlans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load data';
        isLoading = false;
      });
    }
  }

  Widget dropdownField({
    required String hint,
    required List<dynamic> items,
    required String labelKey,
    required int? value,
    required Function(int?) onChanged,
  }) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: value,
          dropdownColor: const Color(0xFF0F172A),
          hint: Text(
            hint,
            style: const TextStyle(
              color: Colors.white54,
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item['id'] as int,
              child: Text(
                (item[labelKey] ?? '').toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
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
                    'Enroll Customer in Chit Plan',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  IconButton(

                    onPressed: () {
                      Navigator.pop(context, null);
                    },

                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (errorMessage != null)
                Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Customer',

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    dropdownField(
                      hint: 'Choose customer...',
                      items: customers,
                      labelKey: 'full_name',
                      value: selectedCustomerId,

                      onChanged: (value) {
                        setState(() {
                          selectedCustomerId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Select Chit Plan',

                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    dropdownField(
                      hint: 'Choose plan...',
                      items: plans,
                      labelKey: 'chit_name',
                      value: selectedPlanId,

                      onChanged: (value) {
                        setState(() {
                          selectedPlanId = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),

              const Text(
                'Joined Date',

                style: TextStyle(
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              TextField(

                controller: dateController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    color: Colors.white70,
                  ),

                  filled: true,
                  fillColor:
                      const Color(0xFF0F172A),

                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),

                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {
                      Navigator.pop(context, null);
                    },

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 18),

                  ElevatedButton(
onPressed:
    selectedPlanId == null ||
            selectedCustomerId == null
        ? null
        : () async {
            await _enrollNow();
          },

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue,
                    ),

                    child: const Text(
                      'Enroll Now',
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

  Future<void> _enrollNow() async {
  if (selectedCustomerId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a customer'),
      ),
    );
    return;
  }

  if (selectedPlanId == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please select a chit plan'),
      ),
    );
    return;
  }

  final dateText = dateController.text.trim();

  String isoDate = dateText;

  final match =
      RegExp(r'^(\d{2})-(\d{2})-(\d{4})$')
          .firstMatch(dateText);

  if (match != null) {
    final day = match.group(1);
    final month = match.group(2);
    final year = match.group(3);

    isoDate = '$year-$month-$day';
  }

  final success =
      await AuthService.createSubscription(
    customerId: selectedCustomerId!,
    chitPlanId: selectedPlanId!,
    joinedDate: isoDate,
  );

  if (success) {
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to create subscription'),
      ),
    );
  }
}
}