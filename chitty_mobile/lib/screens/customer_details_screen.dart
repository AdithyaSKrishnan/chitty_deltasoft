import 'package:flutter/material.dart';
//import 'edit_customer_screen.dart';
class CustomerDetailsScreen extends StatelessWidget {
  final Map customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    print("DETAIL CUSTOMER DATA:");
    print(customer);

    return Scaffold(
      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
  backgroundColor: const Color(0xFF020617),

  title: const Text(
    'Customer Details TEST',
    style: TextStyle(
      color: Colors.white,
    ),
  ),

  
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
  'Office Phone',
  customer['work_address']?['pincode'] ?? '-',
),

buildTile(
  'Office Landmark',
  customer['work_address']?['landmark'] ?? '-',
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