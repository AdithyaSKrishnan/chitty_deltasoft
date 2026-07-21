import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'edit_customer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CustomerDetailsScreen extends StatefulWidget {
   final Map customer;

  const CustomerDetailsScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  String _role = '';
  bool _hasPendingRequest = false;
  bool _isLoadingPendingRequest = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final role = await AuthService.getRole() ?? '';
    setState(() {
      _role = role;
    });

    if (role == 'field_agent') {
      final hasPending = await AuthService.hasPendingEditRequest(widget.customer['id']);
      setState(() {
        _hasPendingRequest = hasPending;
        _isLoadingPendingRequest = false;
      });
    } else {
      setState(() {
        _isLoadingPendingRequest = false;
      });
    }
  }

  Future<void> _submitRequestEdit() async {
    setState(() {
      _isLoadingPendingRequest = true;
    });

    final success = await AuthService.createEditRequest(
      widget.customer['id'],
      "Profile modification request",
    );

    if (!mounted) return;

    setState(() {
      _isLoadingPendingRequest = false;
    });

    if (success) {
      setState(() {
        _hasPendingRequest = true;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text("Request Submitted", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: const Text(
            "Your edit permission request has been successfully sent to the administrators and sub-administrators. Please wait for authorization.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit request")),
      );
    }
  }

  String formatDateTime(dynamic val) {
    if (val == null) return '-';
    try {
      final dt = DateTime.parse(val.toString()).toLocal();
      final year = dt.year;
      final month = dt.month.toString().padLeft(2, '0');
      final day = dt.day.toString().padLeft(2, '0');
      final hourVal = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final hour = hourVal.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return "$year-$month-$day $hour:$minute $ampm";
    } catch (e) {
      return val.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customer = widget.customer;
    print("DETAIL CUSTOMER DATA:");

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
          if (_role == 'admin' || _role == 'subadmin') ...[
            if (customer['approval_status'] != 'Approved')
              IconButton(
                icon: const Icon(
                  Icons.verified,
                  color: Colors.green,
                ),
                onPressed: () async {
                  final success = await AuthService.approveCustomer(
                    customer['id'],
                  );

                  if (success) {
                    if (!mounted) return;
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
              ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
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
                  if (!mounted) return;
                  Navigator.pop(context, true);
                }
              },
            ),
          ] else if (_role == 'field_agent') ...[
            if (customer['edit_enabled'] == true)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
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
                    if (!mounted) return;
                    Navigator.pop(context, true);
                  }
                },
              )
            else if (!_isLoadingPendingRequest) ...[
              if (_hasPendingRequest)
                IconButton(
                  icon: const Icon(Icons.hourglass_empty, color: Colors.amber),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Edit request is pending approval by admin."),
                      ),
                    );
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.edit_off, color: Colors.blue),
                  onPressed: _submitRequestEdit,
                ),
            ],
          ],
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

              final success = await AuthService.deleteCustomer(
                customer['id'],
              );

              if (!mounted) return;

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
            if (customer['is_edit_unlocked'] == true) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF15803D).withOpacity(0.15),
                  border: Border.all(color: const Color(0xFF15803D).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_open, color: Color(0xFF4ADE80), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Color(0xFF4ADE80), fontSize: 13),
                          children: [
                            TextSpan(
                              text: "Edit Permission Granted! ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "Admin has unlocked this customer profile. You can now edit and update the details.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

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
              'Date Added',
              formatDateTime(customer['created_at']),
            ),

            buildTile(
              'Last Modified',
              formatDateTime(customer['updated_at'] ?? customer['created_at']),
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
    dynamic value,
  ) {
    final strVal = (value == null || value.toString().trim().isEmpty) ? '-' : value.toString();
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
          strVal,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}