import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AgentSubscriptionsScreen extends StatefulWidget {
  const AgentSubscriptionsScreen({super.key});

  @override
  State<AgentSubscriptionsScreen> createState() =>
      _AgentSubscriptionsScreenState();
}

class _AgentSubscriptionsScreenState extends State<AgentSubscriptionsScreen> {
  List<dynamic> subscriptions = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedSubscriptions = await AuthService.getSubscriptions();
      print('Subscriptions: $fetchedSubscriptions');
      setState(() {
        subscriptions = fetchedSubscriptions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load subscriptions';
        isLoading = false;
      });
    }
  }

  List<DataRow> _buildSubscriptionRows() {
    return subscriptions.map((subscription) {
      final paymentStatus =
          subscription['payment_status']?.toString() ?? '';
      final actionButton = paymentStatus.toLowerCase() == 'pending'
          ? ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Collect'),
            )
          : OutlinedButton(
              onPressed: () {},
              child: const Text('View'),
            );

      return DataRow(cells: [
        DataCell(
          Text(subscription['customer_name']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['chit_plan_name']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['chit_plan_code']?.toString() ?? ''),
        ),
        DataCell(
          Text(subscription['subscription_status']?.toString() ?? ''),
        ),
        DataCell(actionButton),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        elevation: 0,
        title: const Text(
          'My Subscriptions',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'My Subscriptions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Manage customer collections',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: [

                Expanded(
                  child: buildCard(
                    'Active',
                    '18',
                    Icons.subscriptions,
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: buildCard(
                    'Pending',
                    '₹25,000',
                    Icons.warning_amber_rounded,
                  ),
                ),

                const SizedBox(width: 20),

                Expanded(
                  child: buildCard(
                    'Collected',
                    '₹1,20,000',
                    Icons.currency_rupee,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Assigned Subscriptions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (errorMessage != null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else if (subscriptions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'No subscriptions found',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        dataTextStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        columns: const [
                          DataColumn(label: Text('Customer')),
                          DataColumn(label: Text('Plan')),
                          DataColumn(label: Text('Amount')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: _buildSubscriptionRows(),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(
                     "Today's Collection Summary",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const ListTile(
                    leading: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    title: Text(
                      '12 Collections Completed',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const ListTile(
                    leading: Icon(
                      Icons.currency_rupee,
                      color: Colors.blue,
                    ),
                    title: Text(
                      '₹45,000 Collected Today',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  const ListTile(
                    leading: Icon(
                      Icons.pending_actions,
                      color: Colors.orange,
                    ),
                    title: Text(
                      '6 Payments Pending',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.blue,
            size: 32,
          ),

          const SizedBox(height: 15),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}