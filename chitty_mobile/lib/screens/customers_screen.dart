import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'customer_details_screen.dart';
import 'add_customer/customer_form_data.dart';
import 'add_customer/add_customer_step1.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List customers = [];
  List filteredCustomers = [];
  String userRole = '';
  String activeTab = 'All';

  final searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRole();
    loadCustomers();
  }

  Future<void> loadRole() async {
    final role = await AuthService.getRole();
    if (mounted) {
      setState(() {
        userRole = role ?? '';
      });
    }
  }

  Future<void> loadCustomers() async {
    final data = await AuthService.getCustomers();

    if (!mounted) return;
    setState(() {
      customers = data;
      applyFilter();
      isLoading = false;
    });
  }

  void applyFilter() {
    final search = searchController.text.toLowerCase().trim();

    setState(() {
      filteredCustomers = customers.where((c) {
        final matchesSearch = search.isEmpty ||
            (c['full_name'] ?? '').toString().toLowerCase().contains(search) ||
            (c['customer_id'] ?? '').toString().toLowerCase().contains(search) ||
            (c['mobile_number'] ?? '').toString().toLowerCase().contains(search);

        final isApproved = c['approval_status'] == 'Approved';
        final matchesTab = activeTab == 'All' ||
            (activeTab == 'Pending' && !isApproved) ||
            (activeTab == 'Approved' && isApproved);

        return matchesSearch && matchesTab;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;
    final bgColor = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final searchFill = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF475569);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        title: Text(
          'Customer Directory',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Colors.indigo,
            ),
            tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
            onPressed: () async {
              await ThemeService.toggleTheme();
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER & ADD CUSTOMER BUTTON
              LayoutBuilder(
                builder: (context, constraints) {
                  bool mobile = constraints.maxWidth < 700;

                  Widget addButton = SizedBox(
                    width: mobile ? double.infinity : 200,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCustomerStep1(
                              formData: CustomerFormData(),
                            ),
                          ),
                        );
                        loadCustomers();
                      },
                      icon: const Icon(Icons.add_circle, color: Colors.white, size: 22),
                      label: const Text(
                        'Add Customer',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.blue.withOpacity(0.4),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  );

                  return mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Customers',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Manage all customer records',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 18),
                            addButton,
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customers',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Manage all customer records',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            addButton,
                          ],
                        );
                },
              ),

              const SizedBox(height: 25),

              /// CUSTOMER TABLE CONTAINER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: isDark
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TABS
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _tabButton('All', customers.length),
                          const SizedBox(width: 8),
                          _tabButton(
                            'Pending',
                            customers.where((c) => c['approval_status'] != 'Approved').length,
                            badgeColor: Colors.amber,
                          ),
                          const SizedBox(width: 8),
                          _tabButton(
                            'Approved',
                            customers.where((c) => c['approval_status'] == 'Approved').length,
                            badgeColor: Colors.green,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    /// SEARCH BAR
                    TextField(
                      controller: searchController,
                      onChanged: (_) => applyFilter(),
                      style: TextStyle(color: textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search by name, ID, or phone...',
                        hintStyle: TextStyle(color: isDark ? Colors.white54 : const Color(0xFF94A3B8)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
                        ),
                        filled: true,
                        fillColor: searchFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    /// CUSTOMERS LIST
                    isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : filteredCustomers.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(30),
                                child: Center(
                                  child: Text(
                                    'No customers found',
                                    style: TextStyle(color: textSecondary, fontSize: 16),
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  // Header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Customer",
                                            style: TextStyle(
                                              color: textSecondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Contact",
                                            style: TextStyle(
                                              color: textSecondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Divider(color: dividerColor),

                                  ...filteredCustomers.map((customer) {
                                    return InkWell(
                                      onTap: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CustomerDetailsScreen(
                                              customer: customer,
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          loadCustomers();
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                              customer['full_name'] ?? '',
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                color: textPrimary,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                          if (customer['edit_enabled'] == true) ...[
                                                            const SizedBox(width: 6),
                                                            const Text("🔓", style: TextStyle(fontSize: 14)),
                                                          ],
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Wrap(
                                                        crossAxisAlignment: WrapCrossAlignment.center,
                                                        spacing: 6,
                                                        runSpacing: 2,
                                                        children: [
                                                          Text(
                                                            customer['customer_id'] ?? '',
                                                            style: TextStyle(color: textSecondary, fontSize: 12),
                                                          ),
                                                          if (customer['approval_status'] != 'Approved')
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                              decoration: BoxDecoration(
                                                                color: Colors.amber.withOpacity(0.2),
                                                                borderRadius: BorderRadius.circular(4),
                                                                border: Border.all(color: Colors.amber, width: 0.5),
                                                              ),
                                                              child: const Text(
                                                                "Pending Approval",
                                                                style: TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  customer['mobile_number'] ?? '',
                                                  style: TextStyle(color: textSecondary, fontSize: 13),
                                                ),
                                                if ((userRole == 'admin' || userRole == 'subadmin') && customer['approval_status'] != 'Approved') ...[
                                                  const SizedBox(width: 4),
                                                  IconButton(
                                                    constraints: const BoxConstraints(),
                                                    padding: const EdgeInsets.all(6),
                                                    icon: const Icon(Icons.check_circle, color: Colors.green, size: 22),
                                                    tooltip: "Approve Customer",
                                                    onPressed: () async {
                                                      final success = await AuthService.approveCustomer(customer['id']);
                                                      if (success) {
                                                        if (!mounted) return;
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(content: Text("Customer Approved!")),
                                                        );
                                                        loadCustomers();
                                                      }
                                                    },
                                                  ),
                                                ] else ...[
                                                  const SizedBox(width: 6),
                                                  Icon(Icons.chevron_right, color: isDark ? Colors.white38 : Colors.black38, size: 20),
                                                ],
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: dividerColor,
                                            height: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, int count, {Color badgeColor = Colors.blue}) {
    final isDark = ThemeService.isDark;
    final bool isSelected = activeTab == title;
    final unselectedBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    final unselectedBorder = isDark ? Colors.white24 : const Color(0xFFCBD5E1);
    final unselectedText = isDark ? Colors.white70 : const Color(0xFF475569);

    return InkWell(
      onTap: () {
        setState(() {
          activeTab = title;
          applyFilter();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2563EB) : unselectedBg,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: unselectedBorder),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : unselectedText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.25) : badgeColor.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: isSelected ? Colors.white : badgeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}