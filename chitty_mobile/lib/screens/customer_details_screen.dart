import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'edit_customer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CustomerDetailsScreen extends StatelessWidget {
   final Map customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });
  @override
  Widget build(BuildContext context) {
    print("DETAIL CUSTOMER DATA:");
    //print(customer);

    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
  backgroundColor: const Color(0xFF020617),

  title: const Text(
    'Customer Details ',
    style: TextStyle(
      color: Colors.white,
    ),
  ),

  actions: [
    FutureBuilder<String?>(
  future: AuthService.getRole(),
  builder: (context, snapshot) {

    if (snapshot.data != "admin") {
      return const SizedBox.shrink();
    }

    if (customer['approval_status'] == "Approved") {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(
        Icons.verified,
        color: Colors.green,
      ),
      onPressed: () async {

        final success =
            await AuthService.approveCustomer(
          customer['id'],
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Customer Approved",
              ),
            ),
          );

          Navigator.pop(context, true);
        }
      },
    );
  },
),
     FutureBuilder<String>(
  future: SharedPreferences.getInstance().then(
    (prefs) => prefs.getString('role') ?? '',
  ),
  builder: (context, snapshot) {
    final role = snapshot.data ?? '';

    if (role == 'field_agent' &&
        customer['edit_enabled'] == false) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.edit),
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
          Navigator.pop(context, true);
        }
      },
    );
  },
),

    IconButton(
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ),

      onPressed: () async {

  final confirm = await showDialog<bool>(

    context: context,

    builder: (context) {

      return AlertDialog(

        title: const Text("Delete Customer"),

        content: const Text(
          "Are you sure you want to delete this customer?",
        ),

        actions: [

          TextButton(

            onPressed: () {

              Navigator.pop(context, false);

            },

            child: const Text("Cancel"),

          ),

          ElevatedButton(

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed: () {

              Navigator.pop(context, true);

            },

            child: const Text("Delete"),

          ),

        ],

      );

    },

  );

  if (confirm != true) return;

  // Delete API call goes here next.
  final success = await AuthService.deleteCustomer(
  customer['id'],
);

if (!context.mounted) return;

if (success) {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Customer deleted successfully"),
    ),
  );

  Navigator.pop(context, true);

} else {

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Failed to delete customer"),
    ),
  );

}

},
    ),

  ],
),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [

            buildTile(
              'Customer ID',
              customer['customer_id'] ?? '-',
            ),

            buildTile(
              'Full Name',
              customer['full_name'] ?? '-',
            ),

            buildTile(
              'Mobile',
              customer['mobile_number'] ?? '-',
            ),

            buildTile(
              'Alternate Number',
              customer['alternate_number'] ?? '-',
            ),

            buildTile(
              'Email',
              customer['email'] ?? '-',
            ),
            buildTile(
  'Customer Type',
  customer['customer_type'] ?? '-',
),
buildTile(
  'Approval Status',
  customer['approval_status'] ?? '-',
),

buildTile(
  'Edit Status',
  customer['edit_enabled'] == true
      ? 'Enabled'
      : 'Disabled',
),

            buildTile(
              'Created At',
              customer['created_at'] ?? '-',
            ),

            const SizedBox(height: 20),

            const Text(
              'Home Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildTile(
              'House Name',
              customer['home_address']?['house_name'] ?? '-',
            ),

            buildTile(
              'Village',
              customer['home_address']?['village'] ?? '-',
            ),

            buildTile(
              'Taluk',
              customer['home_address']?['taluk'] ?? '-',
            ),

            buildTile(
              'District',
              customer['home_address']?['district'] ?? '-',
            ),

            buildTile(
              'State',
              customer['home_address']?['state'] ?? '-',
            ),

            buildTile(
              'Pincode',
              customer['home_address']?['pincode'] ?? '-',
            ),
            const SizedBox(height: 20),
const SizedBox(height: 20),

const Text(
  'Current Address',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

buildTile(
  'House Name',
  customer['current_address']?['house_name'] ?? '-',
),

buildTile(
  'Building Name',
  customer['current_address']?['building_name'] ?? '-',
),

buildTile(
  'Landmark',
  customer['current_address']?['landmark'] ?? '-',
),

buildTile(
  'Village',
  customer['current_address']?['village'] ?? '-',
),

buildTile(
  'Taluk',
  customer['current_address']?['taluk'] ?? '-',
),

buildTile(
  'District',
  customer['current_address']?['district'] ?? '-',
),

buildTile(
  'State',
  customer['current_address']?['state'] ?? '-',
),

buildTile(
  'Pincode',
  customer['current_address']?['pincode'] ?? '-',
),

buildTile(
  'Google Maps',
  customer['current_address']?['google_maps_link'] ?? '-',
),
const Text(
  'Work Address',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

buildTile(
  'Company Name',
  customer['work_address']?['building_name'] ?? '-',
),

buildTile(
  'Office Address',
  customer['work_address']?['house_name'] ?? '-',
),

buildTile(
  'Landmark',
  customer['work_address']?['landmark'] ?? '-',
),

buildTile(
  'Village',
  customer['work_address']?['village'] ?? '-',
),

buildTile(
  'Taluk',
  customer['work_address']?['taluk'] ?? '-',
),

buildTile(
  'District',
  customer['work_address']?['district'] ?? '-',
),

buildTile(
  'State',
  customer['work_address']?['state'] ?? '-',
),

buildTile(
  'Pincode',
  customer['work_address']?['pincode'] ?? '-',
),

buildTile(
  'Google Maps',
  customer['work_address']?['google_maps_link'] ?? '-',
),
const SizedBox(height: 20),

const Text(
  'KYC Documents',
  style: TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

if (customer['customer_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Customer Photo',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['customer_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),

if (customer['address_proof'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['address_proof'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),

if (customer['id_proof'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'ID Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['id_proof'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['home_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Home Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['home_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['current_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Current Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['current_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
  if (customer['work_address']?['address_photo'] != null)
  Card(
    color: const Color(0xFF1E293B),
    child: Column(
      children: [
        const SizedBox(height: 10),
        const Text(
          'Work Address Proof',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        Image.network(
          customer['work_address']['address_photo'],
          height: 250,
        ),
        const SizedBox(height: 10),
      ],
    ),
  ),
          ],
        ),
      ),
    );
  }

  Widget buildTile(
    String title,
    String value,
  ) {
    return Card(
      color: const Color(0xFF1E293B),

      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        subtitle: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}