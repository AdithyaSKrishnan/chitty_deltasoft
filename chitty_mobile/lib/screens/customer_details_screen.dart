import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _openMapLocation(Map? addrData) async {
    if (addrData == null) return;
    final lat = addrData['latitude'];
    final lng = addrData['longitude'];
    final link = addrData['google_maps_link'];

    String urlStr = '';
    if (lat != null && lng != null && lat.toString().isNotEmpty && lng.toString().isNotEmpty) {
      urlStr = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    } else if (link != null && link.toString().isNotEmpty) {
      urlStr = link.toString();
    }

    if (urlStr.isNotEmpty) {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch map URL: $urlStr")),
        );
      }
    }
  }

  Widget _buildEmbeddedMapCard(Map? addrData, String label) {
    if (addrData == null) return const SizedBox.shrink();

    final latVal = double.tryParse(addrData['latitude']?.toString() ?? '');
    final lngVal = double.tryParse(addrData['longitude']?.toString() ?? '');

    if (latVal == null || lngVal == null || (latVal == 0 && lngVal == 0)) {
      return const SizedBox.shrink();
    }

    final pos = LatLng(latVal, lngVal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: pos,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(label),
                  position: pos,
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Lat: ${latVal.toStringAsFixed(6)}, Lng: ${lngVal.toStringAsFixed(6)}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              TextButton.icon(
                onPressed: () => _openMapLocation(addrData),
                icon: const Icon(Icons.open_in_new, size: 16, color: Colors.blue),
                label: const Text("Open Maps", style: TextStyle(color: Colors.blue, fontSize: 12)),
              ),
  void _showUpdateKycModal() {
    File? newPhoto;
    File? newAddressProof;
    File? newIdProof;
    bool isUploading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final ImagePicker picker = ImagePicker();

            Future<void> pickImg(String target) async {
              final XFile? file = await picker.pickImage(source: ImageSource.gallery);
              if (file != null) {
                setModalState(() {
                  if (target == 'photo') newPhoto = File(file.path);
                  if (target == 'address') newAddressProof = File(file.path);
                  if (target == 'id') newIdProof = File(file.path);
                });
              }
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upload / Update KYC Documents",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Customer Photo Picker
                    ListTile(
                      leading: Icon(Icons.person, color: newPhoto != null ? Colors.green : Colors.blue),
                      title: Text(
                        newPhoto != null ? "Customer Photo Selected" : "Customer Photo",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        newPhoto != null ? newPhoto!.path.split('/').last : "Tap to choose image",
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: () => pickImg('photo'),
                      trailing: const Icon(Icons.upload_file, color: Colors.blue),
                    ),

                    // Address Proof Picker
                    ListTile(
                      leading: Icon(Icons.home, color: newAddressProof != null ? Colors.green : Colors.blue),
                      title: Text(
                        newAddressProof != null ? "Address Proof Selected" : "Address Proof Document",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        newAddressProof != null ? newAddressProof!.path.split('/').last : "Tap to choose image",
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: () => pickImg('address'),
                      trailing: const Icon(Icons.upload_file, color: Colors.blue),
                    ),

                    // ID Proof Picker
                    ListTile(
                      leading: Icon(Icons.badge, color: newIdProof != null ? Colors.green : Colors.blue),
                      title: Text(
                        newIdProof != null ? "ID Proof Selected" : "ID Proof Document",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        newIdProof != null ? newIdProof!.path.split('/').last : "Tap to choose image",
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      onTap: () => pickImg('id'),
                      trailing: const Icon(Icons.upload_file, color: Colors.blue),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: isUploading
                            ? null
                            : () async {
                                if (newPhoto == null && newAddressProof == null && newIdProof == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please select at least one document to upload")),
                                  );
                                  return;
                                }

                                setModalState(() {
                                  isUploading = true;
                                });

                                final success = await AuthService.updateCustomerKyc(
                                  customerId: widget.customer['id'],
                                  customerPhoto: newPhoto,
                                  addressProof: newAddressProof,
                                  idProof: newIdProof,
                                );

                                if (!mounted) return;
                                Navigator.pop(ctx);

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("KYC Documents Uploaded Successfully")),
                                  );
                                  setState(() {});
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Failed to upload KYC documents")),
                                  );
                                }
                              },
                        child: isUploading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Submit KYC Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
            if ((_role == 'admin' || _role == 'subadmin') && customer['approval_status'] != 'Approved') ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.15),
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.how_to_reg, color: Colors.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Pending Onboarding Approval",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "This customer was onboarded by an agent and requires your approval.",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle, color: Colors.white),
                        label: const Text(
                          "Approve Customer Onboarding",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () async {
                          final success = await AuthService.approveCustomer(customer['id']);
                          if (success) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Customer Onboarding Approved!")),
                            );
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

            buildTile('House Name', customer['home_address']?['house_name'] ?? '-'),
            buildTile('Village', customer['home_address']?['village'] ?? '-'),
            buildTile('Taluk', customer['home_address']?['taluk'] ?? '-'),
            buildTile('District', customer['home_address']?['district'] ?? '-'),
            buildTile('State', customer['home_address']?['state'] ?? '-'),
            buildTile('Pincode', customer['home_address']?['pincode'] ?? '-'),

            _buildEmbeddedMapCard(customer['home_address'], 'Home Location'),

            const SizedBox(height: 25),

            const Text(
              'Current Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            buildTile('House Name', customer['current_address']?['house_name'] ?? '-'),
            buildTile('Building Name', customer['current_address']?['building_name'] ?? '-'),
            buildTile('Landmark', customer['current_address']?['landmark'] ?? '-'),
            buildTile('Village', customer['current_address']?['village'] ?? '-'),
            buildTile('Taluk', customer['current_address']?['taluk'] ?? '-'),
            buildTile('District', customer['current_address']?['district'] ?? '-'),
            buildTile('State', customer['current_address']?['state'] ?? '-'),
            buildTile('Pincode', customer['current_address']?['pincode'] ?? '-'),

            _buildEmbeddedMapCard(customer['current_address'], 'Current Location'),

            const SizedBox(height: 25),

            const Text(
              'Work Address',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            buildTile('Company Name', customer['work_address']?['building_name'] ?? '-'),
            buildTile('Office Address', customer['work_address']?['house_name'] ?? '-'),
            buildTile('Landmark', customer['work_address']?['landmark'] ?? '-'),
            buildTile('Village', customer['work_address']?['village'] ?? '-'),
            buildTile('Taluk', customer['work_address']?['taluk'] ?? '-'),
            buildTile('District', customer['work_address']?['district'] ?? '-'),
            buildTile('State', customer['work_address']?['state'] ?? '-'),
            buildTile('Pincode', customer['work_address']?['pincode'] ?? '-'),

            _buildEmbeddedMapCard(customer['work_address'], 'Work Location'),
const SizedBox(height: 20),

Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'KYC Documents',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    ElevatedButton.icon(
      onPressed: _showUpdateKycModal,
      icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
      label: const Text("Update KYC", style: TextStyle(color: Colors.white, fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  ],
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