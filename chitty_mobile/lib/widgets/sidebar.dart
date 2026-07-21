import 'package:flutter/material.dart';
import '../screens/subscriptions_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/customers_screen.dart';
import '../screens/employees_screen.dart';
import '../screens/chit_plans_screen.dart';
import '../screens/login_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../services/auth_service.dart';
class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int pendingCount = 0;

  @override
  void initState() {
    super.initState();
    loadPendingCount();
  }

  Future<void> loadPendingCount() async {
    try {
      final list = await AuthService.getCustomers();
      final pending = list.where((c) => c['approval_status'] == 'Pending').length;
      if (mounted) {
        setState(() {
          pendingCount = pending;
        });
      }
    } catch (_) {}
  }

  Widget menuItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen, {
    bool active = false,
    int badgeCount = 0,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF1E3A8A)
              : Colors.transparent,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Row(
          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (badgeCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 260,

      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Color(0xFF081028),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          /// LOGO
          Row(
            children: [

              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius:
                      BorderRadius.circular(18),
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

                  SizedBox(height: 4),

                  Text(
                    'Admin Panel',

                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          /// DASHBOARD
          menuItem(
            context,
            Icons.dashboard,
            'Dashboard',
            const DashboardScreen(),
          ),

          /// CUSTOMERS
          menuItem(
            context,
            Icons.people,
            'Customers',
            const CustomersScreen(),
            badgeCount: pendingCount,
          ),

          /// EMPLOYEES
          menuItem(
            context,
            Icons.badge,
            'Employees',
            const EmployeesScreen(),
          ),

          /// CHIT PLANS
          menuItem(
            context,
            Icons.description,
            'Chit Plans',
            const ChitPlansScreen(),
          ),

          /// SUBSCRIPTIONS
          menuItem(
  context,
  Icons.subscriptions,
  'Subscriptions',
  const SubscriptionsScreen(),
),

          /// REPORTS
          menuItem(
            context,
            Icons.bar_chart,
            'Reports',
            const ReportsScreen(),
          ),

          /// SETTINGS
          menuItem(
            context,
            Icons.settings,
            'Settings',
            const SettingsScreen(),
          ),

          const Spacer(),

          /// ADMIN SECTION
          Container(

            padding: const EdgeInsets.only(top: 20),

            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color:
                      Colors.white.withOpacity(0.08),
                ),
              ),
            ),

            child: Column(
              children: [

                /// ADMIN INFO
                Row(
                  children: [

                    CircleAvatar(
                      radius: 22,

                      backgroundColor:
                          Colors.greenAccent,

                      child: const Text(
                        'A',

                        style: TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Text(
                      'Admin',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// BUTTONS
                Row(
                  children: [

                    /// THEME BUTTON
                    Expanded(
                      child: Container(
                        height: 50,

                        decoration: BoxDecoration(
                          color:
                              const Color(0xFF334155),

                          borderRadius:
                              BorderRadius.circular(
                                  12),
                        ),

                        child: IconButton(
                          onPressed: () {},

                          icon: const Icon(
                            Icons.dark_mode,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// LOGOUT BUTTON
                    Expanded(
                      child: InkWell(

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

                        child: Container(
                          height: 50,

                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF3B1D2E),

                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),

                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Icon(
                                Icons.logout,
                                color: Colors.redAccent,
                                size: 20,
                              ),

                              SizedBox(width: 8),

                              Text(
                                'Logout',

                                style: TextStyle(
                                  color:
                                      Colors.redAccent,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}