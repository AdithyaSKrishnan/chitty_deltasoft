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

  final searchController =
    TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    final data = await AuthService.getCustomers();
    final approvedData = data.where((item) => item['approval_status'] == 'Approved').toList();

    print("CUSTOMERS DATA (APPROVED ONLY):");
    print(approvedData);
    print("COUNT = ${approvedData.length}");

    setState(() {
      customers = approvedData;
      filteredCustomers = approvedData;
      isLoading = false;
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
                  children: [

                    /// SEARCH
                    TextField(
  controller: searchController,

  onChanged: (value) {

    setState(() {

      filteredCustomers = customers.where((customer) {

        final search =
            value.toLowerCase();

        return (customer['full_name'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search) ||

            (customer['customer_id'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search) ||

            (customer['mobile_number'] ?? '')
                .toString()
                .toLowerCase()
                .contains(search);

      }).toList();
    });
  },

  style: const TextStyle(
    color: Colors.white,
  ),

                      decoration: InputDecoration(
                        hintText:
                            'Search by name, ID, or phone...',

                        hintStyle:
                            const TextStyle(color: Colors.white54),

                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white54,
                        ),

                        filled: true,
                        fillColor: const Color(0xFF0F172A),

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
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
      flex: 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            customer['full_name'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          if (customer['is_edit_unlocked'] == true) ...[
            const SizedBox(width: 6),
            const Text(
              "🔓",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
    ),

    Expanded(
      child: Text(
        customer['mobile_number'] ?? '',
        textAlign: TextAlign.right,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),

    const SizedBox(width: 8),

    const Icon(
      Icons.chevron_right,
      color: Colors.white38,
      size: 20,
    ),

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
}