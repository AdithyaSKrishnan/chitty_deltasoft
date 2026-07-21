import 'package:flutter/material.dart';
//import 'add_customer_screen.dart';
import '../services/auth_service.dart';
import 'customer_details_screen.dart';
//import 'edit_customer_screen.dart';
import 'add_customer/customer_form_data.dart';
import 'add_customer/add_customer_step1.dart';
class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() =>
      _CustomersScreenState();
}

class _CustomersScreenState
    extends State<CustomersScreen> {

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
  /*Future<void> deleteCustomer(
  int customerId,
) async {

  bool success =
      await AuthService.deleteCustomer(
    customerId,
  );

  if (success) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Customer Deleted',
        ),
      ),
    );

    loadCustomers();
  }
}*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// HEADER
              LayoutBuilder(
                builder: (context, constraints) {

                  bool mobile = constraints.maxWidth < 700;

                  return mobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const Text(
                              'Customers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Manage all customer records',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,

                              child: ElevatedButton.icon(
                                onPressed: () async{

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AddCustomerStep1(
                                            formData: CustomerFormData(),
                                          ),
                                    ),
                                  );
                                  loadCustomers();
                                },

                                icon: const Icon(Icons.add),

                                label: const Text(
                                  'Add Customer',
                                ),

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                      : Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,

                          children: [

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: const [

                                Text(
                                  'Customers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 8),

                                Text(
                                  'Manage all customer records',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

                            ElevatedButton.icon(
                              onPressed: () async{

                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        AddCustomerStep1(
                                           formData: CustomerFormData(),
                                        ),
                                  ),
                                );
                                loadCustomers();
                              },

                              icon: const Icon(Icons.add),

                              label: const Text(
                                'Add Customer',
                              ),

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ],
                        );
                },
              ),

              const SizedBox(height: 30),

              /// CUSTOMER TABLE CARD
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(24),
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

                    const SizedBox(height: 16),

                    /// SEARCH
                    TextField(
                      controller: searchController,
                      onChanged: (_) => applyFilter(),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search by name, ID, or phone...',
                        hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF0F172A),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// TABLE
                    /*SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: DataTable(

                        headingRowColor:
                            MaterialStateProperty.all(
                          const Color(0xFF1E293B),
                        ),

                        dataRowColor:
                            MaterialStateProperty.all(
                          const Color(0xFF1E293B),
                        ),

                        columns: const [

                          DataColumn(
                            label: Text(
                              'CUSTOMER',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'CONTACT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'EMAIL',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'LOCATION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          DataColumn(
                            label: Text(
                              'ACTION',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
rows: filteredCustomers.map<DataRow>((customer)  {

  return DataRow(

    cells: [

      DataCell(
  Row(
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: Colors.blue,
        backgroundImage: (customer['customer_photo'] != null && (customer['customer_photo'] as String).isNotEmpty)
            ? NetworkImage(customer['customer_photo'])
            : null,
        child: (customer['customer_photo'] == null || (customer['customer_photo'] as String).isEmpty)
            ? Text(
                (customer['full_name'] ?? '').toString().split(' ').map((e) => e.isNotEmpty ? e[0].toUpperCase() : '').take(2).join(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )
            : null,
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            customer['full_name'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: customer['kyc_status'] == 'Completed'
                  ? Colors.green
                  : Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              customer['kyc_status'] ?? 'Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
),

      DataCell(
        Text(
          customer['mobile_number'] ?? '',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      DataCell(
        Text(
          customer['email'] ?? '',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      DataCell(
  Text(
    customer['home_address'] != null
        ? customer['home_address']['district'] ?? '-'
        : '-',
    style: const TextStyle(
      color: Colors.white,
    ),
  ),
),

  DataCell(
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [

      // View
      IconButton(
        icon: const Icon(
          Icons.visibility,
          color: Colors.blue,
        ),
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomerDetailsScreen(
                customer: customer,
              ),
            ),
          );
        },
      ),

      // Edit
      IconButton(
        icon: const Icon(
          Icons.edit,
          color: Colors.orange,
        ),
    onPressed: () async {

  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => EditCustomerScreen(
        customer: customer,
      ),
    ),
  );

  if (result == true) {
    loadCustomers();
  }
},
      ),

      // Delete
      IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),

  onPressed: () async {

    bool? confirm =
        await showDialog<bool>(

      context: context,

      builder: (_) => AlertDialog(

        title: const Text(
          'Delete Customer',
        ),

        content: const Text(
          'Are you sure?',
        ),

        actions: [

          TextButton(
            onPressed: () {

              Navigator.pop(
                context,
                false,
              );
            },

            child: const Text(
              'Cancel',
            ),
          ),

          ElevatedButton(
            onPressed: () {

              Navigator.pop(
                context,
                true,
              );
            },

            child: const Text(
              'Delete',
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {

      deleteCustomer(
        customer['id'],
      );
    }
  },
),
    ],
  ),
),
    ],
  );

}).toList(),
                      ),
                    ),*/
                    Column(
  children: [

    // Header
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      child: Row(
        children: const [

          Expanded(
            flex: 2,
            child: Text(
              "Customer",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Expanded(
            child: Text(
              "Contact",
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    ),

    const Divider(color: Colors.white24),

    ...filteredCustomers.map((customer) {

      return InkWell(

        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CustomerDetailsScreen(
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
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),

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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (customer['is_edit_unlocked'] == true) ...[
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
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
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
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
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
                    const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
                  ],
                ],
              ),
            ),

            const Divider(
              color: Colors.white12,
              height: 1,
            ),
          ],
        ),
      );
    }).toList(),
  ],
)
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
    final bool isSelected = activeTab == title;
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
          color: isSelected ? Colors.blue : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : badgeColor.withOpacity(0.2),
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