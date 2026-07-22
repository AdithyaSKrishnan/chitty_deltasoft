import 'package:flutter/material.dart';
import 'agent_subscriptions_screen.dart';
import 'customers_screen.dart';
import 'customer_details_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() =>
      _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> with WidgetsBindingObserver {
  int totalCustomers = 0;
  int activeSubscriptions = 0;

  List<dynamic> recentCustomers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    loadDashboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadDashboard();
    }
  }

  Future<void> loadDashboard() async {
    final data = await AuthService.getAgentDashboard();
    final allCustomers = await AuthService.getCustomers();

    List<dynamic> customersList = data['recent_customers'] as List? ?? [];
    if (customersList.length < allCustomers.length) {
      customersList = allCustomers;
    }

    if (mounted) {
      setState(() {
        totalCustomers = allCustomers.length;
        activeSubscriptions = data['active_subscriptions'] ?? 0;
        recentCustomers = customersList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    bool mobile = width < 900;

    return Scaffold(
  backgroundColor: const Color(0xFF020617),

  appBar: mobile
      ? AppBar(
          backgroundColor: const Color(0xFF020617),
          elevation: 0,
          iconTheme:
            const IconThemeData(
           color: Colors.white,
        ),
      )
      : null,

  drawer: mobile
      ? Drawer(
          child: Material(
            color: const Color(0xFF081028),
            child: Column(
              children: [
                const SizedBox(height: 50),

                ListTile(
                  leading: const Icon(Icons.dashboard,
                      color: Colors.white),
                  title: const Text(
                    'Dashboard',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AgentDashboardScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.people,
                      color: Colors.white),
                  title: const Text(
                    'Customers',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CustomersScreen(),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.subscriptions,
                      color: Colors.white),
                  title: const Text(
                    'Subscriptions',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const AgentSubscriptionsScreen(),
                      ),
                    );
                  },
                ),

                const Spacer(),

                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        )
      : null,

  body: Row(

        children: [

          /// SIDEBAR
          if (!mobile)
            Container(

              width: 260,

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Color(0xFF081028),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Container(

                        padding:
                            const EdgeInsets.all(14),

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius:
                              BorderRadius.circular(
                                  18),
                        ),

                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            'ChittyFinance',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          Text(
                            'Agent Panel',

                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  sidebarItem(
                    context,
                    Icons.dashboard,
                    'Dashboard',
                    const AgentDashboardScreen(),
                    true,
                  ),

                  sidebarItem(
                    context,
                    Icons.people,
                    'Customers',
                    const CustomersScreen(),
                    false,
                  ),

                  sidebarItem(
  context,
  Icons.subscriptions,
  'Subscriptions',
  const AgentSubscriptionsScreen(),
  false,
),
                  const Spacer(),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      onPressed: () {

                        Navigator.pushReplacement(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                                const LoginScreen(),
                          ),
                        );
                      },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.redAccent,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),

                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),

                      label: const Text(
                        'Logout',

                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          /// MAIN CONTENT
          Expanded(

            child: SafeArea(

              child: SingleChildScrollView(

                padding: const EdgeInsets.all(24),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    /// HEADER
                    const Text(

                      'Agent Dashboard',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(

                      'Welcome back, Agent',

                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// STATS
                    GridView.count(

                      shrinkWrap: true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      crossAxisCount:
                          mobile ? 1 : 2,

                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,

                      childAspectRatio: 2.3,

                      children: [

                        statsCard(
                          'Total Customers',
                          totalCustomers.toString(),
                          Icons.people,
                          Colors.blue,
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomersScreen()));
                            loadDashboard();
                          },
                        ),

                        statsCard(
                          'Active Subscriptions',
                          activeSubscriptions.toString(),
                          Icons.subscriptions,
                          Colors.green,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AgentSubscriptionsScreen())),
                        ),
                        
                      ],
                    ),

                    const SizedBox(height: 35),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Customer Directory (${recentCustomers.length})',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mobile ? 20 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CustomersScreen()),
                            );
                            loadDashboard();
                          },
                          icon: const Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
                          label: const Text("View All", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    tableContainer(
                      child: Column(
                        children: [
                          tableRow(
                            true,
                            'Customer Name',
                            'Phone / ID',
                            'Status',
                            'Action',
                          ),
                          ...recentCustomers.map(
                            (customer) => InkWell(
                              onTap: () async {
                                final refresh = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomerDetailsScreen(customer: customer),
                                  ),
                                );
                                if (refresh == true) {
                                  loadDashboard();
                                }
                              },
                              child: tableRow(
                                false,
                                (customer['full_name'] ?? customer['name'] ?? '').toString(),
                                "${customer['mobile_number'] ?? customer['phone'] ?? ''}",
                                (customer['approval_status'] ?? 'Approved').toString(),
                                'View / Edit ➔',
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget sidebarItem(

    BuildContext context,

    IconData icon,

    String title,

    Widget page,

    bool active,
  ) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) => page,
          ),
        );
      },

      child: Container(

        margin:
            const EdgeInsets.only(bottom: 14),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        decoration: BoxDecoration(

          color: active
              ? const Color(0xFF1E3A8A)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(16),
        ),

        child: Row(

          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),

            const SizedBox(width: 14),

            Text(

              title,

              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),

          borderRadius:
              BorderRadius.circular(24),
        ),

        child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: color.withOpacity(0.15),

              borderRadius:
                  BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),

          const SizedBox(width: 20),

          Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(
                value,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                title,

                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget sectionTitle(String title) {

    return Text(

      title,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget tableContainer({
    required Widget child,
  }) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),

        borderRadius:
            BorderRadius.circular(24),
      ),

      child: child,
    );
  }

  Widget tableRow(

    bool header,

    String c1,

    String c2,

    String c3,

    String c4,
  ) {

    final style = TextStyle(

      color:
          header ? Colors.white : Colors.white70,

      fontWeight:
          header ? FontWeight.bold : FontWeight.normal,
    );

    return Padding(

      padding:
          const EdgeInsets.symmetric(vertical: 14),

      child: Row(

        children: [

          Expanded(
            child: Text(c1, style: style),
          ),

          Expanded(
            child: Text(c2, style: style),
          ),

          Expanded(
            child: Text(c3, style: style),
          ),

          Expanded(
            child: Text(c4, style: style),
          ),
        ],
      ),
    );
  }
}