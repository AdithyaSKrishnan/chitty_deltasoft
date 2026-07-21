import 'package:flutter/material.dart';
//import 'add_customer_screen.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/info_container.dart';
import '../widgets/sidebar.dart';
import 'customers_screen.dart';
import 'subscriptions_screen.dart';
import 'employees_screen.dart';
import 'chit_plans_screen.dart';
import 'reports_screen.dart';
import '../services/dashboard_service.dart';
import '../services/auth_service.dart';
import 'add_customer/add_customer_step1.dart';
import 'add_customer/customer_form_data.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
      Map<String, dynamic>? stats;
     

List recentCustomers = [];
int pendingKycCount = 0;
List recentSubscriptions = [];
bool isLoading = true;

@override
void initState() {
  super.initState();
  loadStats();
  loadDashboard();

}

Future<void> loadStats() async {
  try {
    final data = await DashboardService.getStats();
    final customersList = await AuthService.getCustomers();
    if (!mounted) return;
    setState(() {
      stats = data;
      stats!['total_customers'] = customersList.length;
      isLoading = false;
    });
  } catch (e) {
    final customersList = await AuthService.getCustomers();
    if (!mounted) return;
    setState(() {
      stats = {'total_customers': customersList.length};
      isLoading = false;
    });
  }
}
Future<void> loadDashboard() async {
  print("LOAD DASHBOARD CALLED");

  try {

    recentCustomers =
        await AuthService.getRecentCustomers();
    print(recentCustomers.first.keys);

    print('Customers loaded');
    for (var customer in recentCustomers) {
      print(customer);
}

    final count = recentCustomers.where((customer) {

  final status =
      customer['kyc_status']
          ?.toString()
          .trim()
          .toLowerCase();

  print(
    "${customer['full_name']} => '$status'"
  );

  return status == 'pending';

}).length;

    print("==========");
    print("final count = $count");
    print("==========");

    recentSubscriptions =
        await AuthService.getRecentSubscriptions();

    setState(() {

      pendingKycCount = count;

    });
    //print("FINAL COUNT = $pendingKycCount");
  } catch (e) {

    print(e);

  }
}
Widget actionCard(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
  Widget screen,
) {
  return InkWell(
  onTap: () async {

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => screen,
    ),
  );

  if (result == true) {
    await loadStats();
    await loadDashboard();
  }
},
    borderRadius: BorderRadius.circular(20),
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
  Widget customerTile(
    String name,
    String? photoUrl,
    String id,
    String amount,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: Colors.blue,
            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                ? NetworkImage(photoUrl)
                : null,
            child: (photoUrl == null || photoUrl.isEmpty)
                ? Text(
                    name.split(' ').map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').take(2).join(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  id,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget subscriptionTile(
    String customerName,
    String? photoUrl,
    String planName,
    String amount,
    String paymentStatus,
  ) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      child: Row(

        children: [

          CircleAvatar(
            backgroundColor: Colors.purple,
            backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                ? NetworkImage(photoUrl)
                : null,
            child: (photoUrl == null || photoUrl.isEmpty)
                ? Text(
                    customerName.split(' ').map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').take(2).join(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  planName,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                paymentStatus,
                style: TextStyle(
                  color: paymentStatus.toLowerCase() == 'paid' ? Colors.green : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
  return const Scaffold(
    backgroundColor: Color(0xFF020617),
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

    final width = MediaQuery.of(context).size.width;

    final isMobile = width < 700;
    final isTablet = width >= 700 && width < 1100;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      drawer: isMobile ? const Drawer(
        child: Sidebar(),
      ) : null,

      appBar: isMobile
          ? AppBar(
              backgroundColor: const Color(0xFF081028),
            )
          : null,

      body: Row(

        children: [

          if (!isMobile)
            const Sidebar(),

          Expanded(

            child: Padding(

              padding: const EdgeInsets.all(20),

              child: SingleChildScrollView(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(
  mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
  children: [

    const Text(
      'Dashboard',
      style: TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    ),

    Stack(
      children: [

        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Pending KYC'),
                content: Text(
                  '$pendingKycCount customer(s) have pending KYC',
                ),
              ),
            );},
        ),

        if (pendingKycCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$pendingKycCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  ],
),

                    const SizedBox(height: 10),

                    const Text(
                      "Welcome back! Here's your overview.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    GridView.count(

                      crossAxisCount:
                          isMobile ? 1 : (isTablet ? 2 : 3),

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,

                      childAspectRatio: isMobile ? 2.2 : 1.4,

                      children: [
                        DashboardCard(
                          title: 'Total Customers',
                          value: '${stats?['total_customers'] ?? 0}',
                          icon: Icons.people,
                          color: Colors.blue,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomersScreen())),
                        ),
                        DashboardCard(
                          title: 'Active Chitties',
                          value: '${stats?['active_subscriptions'] ?? 0}',
                          icon: Icons.account_balance_wallet,
                          color: Colors.green,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionsScreen())),
                        ),

                        DashboardCard(
                          title: 'Monthly Collection',
                          value: '₹${stats?['monthly_collections_total'] ?? 0}',
                          icon: Icons.currency_rupee,
                          color: Colors.lightBlueAccent,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportsScreen())),
                        ),

                        DashboardCard(
                          title: 'Pending Payments',
                          value: '${stats?['pending_payments'] ?? 0}',
                          icon: Icons.access_time,
                          color: Colors.orange,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SubscriptionsScreen())),
                        ),

                        DashboardCard(
                          title: 'Active Plans',
                          value: '${stats?['active_chit_plans'] ?? 0}',
                          icon: Icons.description,
                          color: Colors.lightGreen,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChitPlansScreen())),
                        ),

                        DashboardCard(
                          title: 'Reports',
                          value: '12',
                          icon: Icons.bar_chart,
                          color: Colors.purple,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.count(
  crossAxisCount: isMobile ? 2 : 4,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.2,

  children: [

    actionCard(
      context,
      'Add Customer',
      Icons.person_add,
      Colors.blue,
      AddCustomerStep1(
  formData: CustomerFormData(),
),
    ),

    actionCard(
  context,
  'Add Employee',
  Icons.badge,
  Colors.green,
  const EmployeesScreen(),
),

    actionCard(
  context,
  'Create Plan',
  Icons.description,
  Colors.orange,
  const ChitPlansScreen(),
),

   actionCard(
  context,
  'View Reports',
  Icons.bar_chart,
  Colors.purple,
  const ReportsScreen(),
),
  ],
),
                    const SizedBox(height: 40),

                    isMobile

                        ? Column(
                            children: [

                              InfoContainer(
                                title: 'Recent Customers',

                                child: Column(
  children: recentCustomers.map<Widget>((customer) {
    return customerTile(
      customer['full_name'] ?? '',
      customer['customer_photo'],
      customer['customer_id'] ?? '',
      '',
    );
  }).toList(),
),
                              ),

                              const SizedBox(height: 20),

                              InfoContainer(
                                title: 'Active Subscriptions',

                                child: Column(
  children: recentSubscriptions.map<Widget>((subscription) {

    return subscriptionTile(
      subscription['customer_name'] ?? '',
      subscription['customer_photo'],
      subscription['chit_plan_name'] ?? '',
      '₹${subscription['monthly_payment']}',
      subscription['payment_status'] ?? '',
    );

  }).toList(),
),
                              ),
                            ],
                          )

                        : Row(

                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Expanded(

                                child: InfoContainer(

                                  title: 'Recent Customers',

                                  child: Column(
  children: recentCustomers.map<Widget>((customer) {
    return customerTile(
      customer['full_name'] ?? '',
      customer['customer_photo'],
      customer['customer_id'] ?? '',
      '',
    );
  }).toList(),
),
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(

                                child: InfoContainer(

                                  title:
                                      'Active Subscriptions',

                                 child: Column(
  children: recentSubscriptions.map<Widget>((subscription) {

    return subscriptionTile(
      subscription['customer_name'] ?? '',
      subscription['customer_photo'],
      subscription['chit_plan_name'] ?? '',
      '₹${subscription['monthly_payment']}',
      subscription['payment_status'] ?? '',
    );

  }).toList(),
),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}