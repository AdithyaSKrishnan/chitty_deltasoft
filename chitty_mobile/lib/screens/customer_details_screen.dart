import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import 'edit_customer_screen.dart';

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
      "Profile & KYC modification request",
    );

    if (!mounted) return;

    setState(() {
      _isLoadingPendingRequest = false;
    });

    final isDark = ThemeService.isDark;

    if (success) {
      setState(() {
        _hasPendingRequest = true;
      });

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          title: Text(
            "Request Submitted",
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Your edit permission request has been successfully sent to the administrators and sub-administrators. Please wait for authorization before editing or updating KYC documents.",
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              fontSize: 14,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => Navigator.pop(context),
              child: const Text("Okay", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit edit request")),
      );
    }
  }

  /// Allows any employee (including field agents) to update KYC documents
  void _handleUpdateKycTap() {
    _showUpdateKycModal();
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
    if (lat != null && lng != null && lat.toString().isNotEmpty && lat.toString() != '0' && lng.toString() != '0') {
      urlStr = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    } else if (link != null && link.toString().isNotEmpty) {
      urlStr = link.toString();
    }

    if (urlStr.isNotEmpty) {
      try {
        final uri = Uri.parse(urlStr);
        bool launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Could not open Google Maps for: $urlStr")),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error opening maps: $e")),
        );
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No GPS coordinates or Google Maps location saved for this address.")),
      );
    }
  }

  Widget _buildEmbeddedMapCard(Map? addrData, String label) {
    final isDark = ThemeService.isDark;
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF475569);

    final latVal = double.tryParse(addrData?['latitude']?.toString() ?? '');
    final lngVal = double.tryParse(addrData?['longitude']?.toString() ?? '');

    final hasCoords = latVal != null && lngVal != null && (latVal != 0 || lngVal != 0);
    final pos = hasCoords ? LatLng(latVal!, lngVal!) : const LatLng(8.8932, 76.6141);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          "$label Map",
          style: TextStyle(
            color: textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
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
              onTap: null, // Read-only in view mode: location cannot be changed
              scrollGesturesEnabled: false, // Read-only: cannot pan/drag to move location pin
              rotateGesturesEnabled: false,
              tiltGesturesEnabled: false,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  hasCoords
                      ? "Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}"
                      : "Location Pin (Default)",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    fontSize: 12,
                  ),
                ),
              ),
              if (addrData != null)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _openMapLocation(addrData),
                  icon: const Icon(Icons.map_outlined, size: 16),
                  label: const Text("Open in Google Maps", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUpdateKycModal() {
    File? newPhoto;
    File? newAddressProof;
    File? newIdProof;
    bool isUploading = false;
    final isDark = ThemeService.isDark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
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

            final cardBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
            final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
            final subColor = isDark ? Colors.white54 : const Color(0xFF64748B);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Upload / Update KYC Documents",
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: titleColor),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Customer Photo Picker
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.person,
                          color: newPhoto != null ? Colors.green : Colors.blue,
                        ),
                        title: Text(
                          newPhoto != null ? "Customer Photo Selected" : "Customer Photo",
                          style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          newPhoto != null ? newPhoto!.path.split('/').last : "Tap to choose image",
                          style: TextStyle(color: subColor, fontSize: 12),
                        ),
                        onTap: () => pickImg('photo'),
                        trailing: const Icon(Icons.upload_file, color: Colors.blue),
                      ),
                    ),

                    // Address Proof Picker
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.home,
                          color: newAddressProof != null ? Colors.green : Colors.blue,
                        ),
                        title: Text(
                          newAddressProof != null ? "Address Proof Selected" : "Address Proof Document",
                          style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          newAddressProof != null ? newAddressProof!.path.split('/').last : "Tap to choose image",
                          style: TextStyle(color: subColor, fontSize: 12),
                        ),
                        onTap: () => pickImg('address'),
                        trailing: const Icon(Icons.upload_file, color: Colors.blue),
                      ),
                    ),

                    // ID Proof Picker
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.badge,
                          color: newIdProof != null ? Colors.green : Colors.blue,
                        ),
                        title: Text(
                          newIdProof != null ? "ID Proof Selected" : "ID Proof Document",
                          style: TextStyle(color: titleColor, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          newIdProof != null ? newIdProof!.path.split('/').last : "Tap to choose image",
                          style: TextStyle(color: subColor, fontSize: 12),
                        ),
                        onTap: () => pickImg('id'),
                        trailing: const Icon(Icons.upload_file, color: Colors.blue),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
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
                            : const Text(
                                "Submit KYC Update",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
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
    final isDark = ThemeService.isDark;

    final bgColor = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textPrimary),
        title: Text(
          'Customer Details',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Theme Toggle Button
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
                    setState(() {
                      customer['approval_status'] = 'Approved';
                      customer['edit_enabled'] = false;
                      _hasPendingRequest = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Customer Approved"),
                      ),
                    );

                    Navigator.pop(context, true);
                  }
                },
              ),
            IconButton(
              icon: Icon(
                customer['edit_enabled'] == true ? Icons.lock_open : Icons.lock,
                color: customer['edit_enabled'] == true ? Colors.green : Colors.orange,
              ),
              tooltip: customer['edit_enabled'] == true ? "Lock Agent Edit" : "Unlock Agent Edit",
              onPressed: () async {
                final newStatus = !(customer['edit_enabled'] == true);
                final success = await AuthService.toggleCustomerEditPermission(customer['id'], newStatus);
                if (success) {
                  setState(() {
                    customer['edit_enabled'] = newStatus;
                  });
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(newStatus ? "Agent Editing Unlocked" : "Agent Editing Locked")),
                  );
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
                    backgroundColor: cardBg,
                    title: Text("Delete Customer", style: TextStyle(color: textPrimary)),
                    content: Text(
                      "Are you sure you want to delete this customer?",
                      style: TextStyle(color: textSecondary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: Text("Cancel", style: TextStyle(color: textSecondary)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Delete", style: TextStyle(color: Colors.white)),
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
            if ((_role == 'admin' || _role == 'subadmin') && _hasPendingRequest) ...[
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_notifications, color: Colors.blue, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Field Agent Requested Edit Access", style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text("Agent needs permission to modify profile data & KYC", style: TextStyle(color: textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () async {
                        final success = await AuthService.toggleCustomerEditPermission(customer['id'], true);
                        if (success) {
                          setState(() {
                            customer['edit_enabled'] = true;
                            _hasPendingRequest = false;
                          });
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Approved! Agent editing unlocked.")),
                          );
                        }
                      },
                      child: const Text("Unlock", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
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
                    Text(
                      "This customer was onboarded by an agent and requires your approval.",
                      style: TextStyle(color: textSecondary, fontSize: 13),
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
                            setState(() {
                              customer['approval_status'] = 'Approved';
                              customer['edit_enabled'] = false;
                              _hasPendingRequest = false;
                            });
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
            if (customer['edit_enabled'] == true) ...[
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
                              text: "Admin has unlocked this customer profile. You can edit profile and update KYC documents.",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            buildTile('Customer ID', customer['customer_id'] ?? '-'),
            buildTile('Full Name', customer['full_name'] ?? '-'),
            buildTile('Mobile', customer['mobile_number'] ?? '-'),
            buildTile('Alternate Number', customer['alternate_number'] ?? '-'),
            buildTile('Email', customer['email'] ?? '-'),
            buildTile('Customer Type', customer['customer_type'] ?? '-'),
            buildTile('Approval Status', customer['approval_status'] ?? '-'),
            buildTile('Edit Status', customer['edit_enabled'] == true ? 'Enabled' : 'Disabled'),
            buildTile('Date Added', formatDateTime(customer['created_at'])),
            buildTile('Last Modified', formatDateTime(customer['updated_at'] ?? customer['created_at'])),

            const SizedBox(height: 20),

            Text(
              'Home Address',
              style: TextStyle(
                color: textPrimary,
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

            Text(
              'Current Address',
              style: TextStyle(
                color: textPrimary,
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

            Text(
              'Work Address',
              style: TextStyle(
                color: textPrimary,
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
                Text(
                  'KYC Documents',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _handleUpdateKycTap,
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Customer Photo', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Address Proof', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('ID Proof', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Home Address Proof', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Current Address Proof', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
                color: cardBg,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Work Address Proof', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600)),
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
    final isDark = ThemeService.isDark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF475569);

    final strVal = (value == null || value.toString().trim().isEmpty) ? '-' : value.toString();
    return Card(
      color: cardBg,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: textSecondary,
          ),
        ),
        subtitle: Text(
          strVal,
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}