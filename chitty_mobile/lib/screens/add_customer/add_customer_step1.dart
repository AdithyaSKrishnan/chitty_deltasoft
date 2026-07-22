import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';
import '../../services/theme_service.dart';
import 'customer_form_data.dart';

class AddCustomerStep1 extends StatefulWidget {
  final CustomerFormData formData;

  const AddCustomerStep1({
    super.key,
    required this.formData,
  });

  @override
  State<AddCustomerStep1> createState() => _AddCustomerStep1State();
}

class _AddCustomerStep1State extends State<AddCustomerStep1> {
  int _currentStep = 0; // 0: Personal Info, 1: Current Address, 2: Permanent Address, 3: Work Address
  bool _isSaving = false;
  int? _createdCustomerId;

  // PAGE 1: Personal Info Controllers
  String selectedCustomerType = "Customer";
  final otherCustomerTypeController = TextEditingController();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  File? customerPhotoFile;

  // PAGE 2: Current Address Controllers
  final currentHouseController = TextEditingController();
  final currentBuildingController = TextEditingController();
  final currentLandmarkController = TextEditingController();
  final currentVillageController = TextEditingController();
  final currentTalukController = TextEditingController();
  final currentDistrictController = TextEditingController();
  final currentStateController = TextEditingController();
  final currentPincodeController = TextEditingController();
  GoogleMapController? currentMapController;
  LatLng currentLocation = const LatLng(8.8932, 76.6141);
  File? currentAddressProofFile;

  // PAGE 3: Permanent (Home) Address Controllers
  bool sameAsCurrentAddress = false;
  final homeHouseController = TextEditingController();
  final homeBuildingController = TextEditingController();
  final homeLandmarkController = TextEditingController();
  final homeVillageController = TextEditingController();
  final homeTalukController = TextEditingController();
  final homeDistrictController = TextEditingController();
  final homeStateController = TextEditingController();
  final homePincodeController = TextEditingController();
  GoogleMapController? homeMapController;
  LatLng homeLocation = const LatLng(8.8932, 76.6141);
  File? homeAddressProofFile;

  // PAGE 4: Work Address Controllers
  final companyNameController = TextEditingController();
  final officeAddressController = TextEditingController();
  final workLandmarkController = TextEditingController();
  final workVillageController = TextEditingController();
  final workTalukController = TextEditingController();
  final workDistrictController = TextEditingController();
  final workStateController = TextEditingController();
  final workPincodeController = TextEditingController();
  GoogleMapController? workMapController;
  LatLng workLocation = const LatLng(8.8932, 76.6141);
  File? workAddressProofFile;

  @override
  void initState() {
    super.initState();
    _initFormData();
    _fetchCurrentGpsLocation();
  }

  void _initFormData() {
    final d = widget.formData;
    selectedCustomerType = d.customerType.isNotEmpty ? d.customerType : 'Customer';
    otherCustomerTypeController.text = d.otherCustomerType;
    nameController.text = d.fullName;
    mobileController.text = d.mobileNumber;
    alternateController.text = d.alternateNumber;
    emailController.text = d.email;
    customerPhotoFile = d.customerPhoto;

    // Current
    currentHouseController.text = d.currentHouseName;
    currentBuildingController.text = d.currentBuildingName;
    currentLandmarkController.text = d.currentLandmark;
    currentVillageController.text = d.currentVillage;
    currentTalukController.text = d.currentTaluk;
    currentDistrictController.text = d.currentDistrict;
    currentStateController.text = d.currentState;
    currentPincodeController.text = d.currentPincode;
    currentAddressProofFile = d.currentAddressProof;

    // Home
    homeHouseController.text = d.homeHouseName;
    homeBuildingController.text = d.homeBuildingName;
    homeLandmarkController.text = d.homeLandmark;
    homeVillageController.text = d.homeVillage;
    homeTalukController.text = d.homeTaluk;
    homeDistrictController.text = d.homeDistrict;
    homeStateController.text = d.homeState;
    homePincodeController.text = d.homePincode;
    homeAddressProofFile = d.homeAddressProof;

    // Work
    companyNameController.text = d.companyName;
    officeAddressController.text = d.officeAddress;
    workLandmarkController.text = d.workLandmark;
    workVillageController.text = d.workVillage;
    workTalukController.text = d.workTaluk;
    workDistrictController.text = d.workDistrict;
    workStateController.text = d.workState;
    workPincodeController.text = d.workPincode;
    workAddressProofFile = d.workAddressProof;
  }

  Future<void> _fetchCurrentGpsLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      setState(() {
        currentLocation = latLng;
        homeLocation = latLng;
        workLocation = latLng;
      });
    } catch (_) {}
  }

  void _copyCurrentToHomeAddress(bool value) {
    setState(() {
      sameAsCurrentAddress = value;
      if (value) {
        homeHouseController.text = currentHouseController.text;
        homeBuildingController.text = currentBuildingController.text;
        homeLandmarkController.text = currentLandmarkController.text;
        homeVillageController.text = currentVillageController.text;
        homeTalukController.text = currentTalukController.text;
        homeDistrictController.text = currentDistrictController.text;
        homeStateController.text = currentStateController.text;
        homePincodeController.text = currentPincodeController.text;
        homeLocation = currentLocation;
        homeAddressProofFile = currentAddressProofFile;
      }
    });
  }

  Future<void> _pickImage(String target) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        if (target == 'customer_photo') customerPhotoFile = File(file.path);
        if (target == 'current_address_proof') currentAddressProofFile = File(file.path);
        if (target == 'home_address_proof') homeAddressProofFile = File(file.path);
        if (target == 'work_address_proof') workAddressProofFile = File(file.path);
      });
    }
  }

  /// Saves form data to database and completes onboarding
  Future<bool> _saveCurrentProgress({bool isFinal = true}) async {
    final name = nameController.text.trim();
    final mobile = mobileController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Customer Name to save")),
      );
      return false;
    }

    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Primary Mobile Number to save")),
      );
      return false;
    }

    setState(() {
      _isSaving = true;
    });

    final res = await AuthService.createCustomer(
      fullName: name,
      mobileNumber: mobile,
      alternateNumber: alternateController.text.trim(),
      email: emailController.text.trim(),
      customerType: selectedCustomerType,
      otherCustomerType: otherCustomerTypeController.text.trim(),

      // Home
      houseName: homeHouseController.text.trim(),
      landmark: homeLandmarkController.text.trim(),
      village: homeVillageController.text.trim(),
      taluk: homeTalukController.text.trim(),
      district: homeDistrictController.text.trim(),
      state: homeStateController.text.trim(),
      pincode: homePincodeController.text.trim(),
      homeLatitude: homeLocation.latitude,
      homeLongitude: homeLocation.longitude,

      // Current
      currentHouseName: currentHouseController.text.trim(),
      currentLandmark: currentLandmarkController.text.trim(),
      currentVillage: currentVillageController.text.trim(),
      currentTaluk: currentTalukController.text.trim(),
      currentDistrict: currentDistrictController.text.trim(),
      currentState: currentStateController.text.trim(),
      currentPincode: currentPincodeController.text.trim(),
      currentLatitude: currentLocation.latitude,
      currentLongitude: currentLocation.longitude,

      // Work
      companyName: companyNameController.text.trim(),
      officeAddress: officeAddressController.text.trim(),
      workLandmark: workLandmarkController.text.trim(),
      workVillage: workVillageController.text.trim(),
      workTaluk: workTalukController.text.trim(),
      workDistrict: workDistrictController.text.trim(),
      workState: workStateController.text.trim(),
      workPincode: workPincodeController.text.trim(),
      workLatitude: workLocation.latitude,
      workLongitude: workLocation.longitude,

      // Files
      customerPhoto: customerPhotoFile,
      homeAddressProof: homeAddressProofFile,
      currentAddressProof: currentAddressProofFile,
      workAddressProof: workAddressProofFile,
    );

    if (!mounted) return false;

    setState(() {
      _isSaving = false;
    });

    if (res != null) {
      if (res['id'] != null) {
        _createdCustomerId = res['id'];

        // Auto-approve for admin/subadmin — no separate onboarding step needed
        final role = await AuthService.getRole();
        if (role == 'admin' || role == 'subadmin') {
          await AuthService.approveCustomer(res['id']);
        }
      }

      if (!mounted) return false;

      final role = await AuthService.getRole();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (role == 'admin' || role == 'subadmin')
                ? "Customer Onboarded and Approved Successfully!"
                : "Onboarding Request Submitted Successfully!",
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save customer data")),
      );
      return false;
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter Customer Name")),
        );
        return;
      }
      if (mobileController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter Primary Mobile Number")),
        );
        return;
      }
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.isDark;
    final bgColor = isDark ? const Color(0xFF020617) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? Colors.white70 : const Color(0xFF475569);
    final inputFill = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);

    final stepTitles = [
      "1. Personal Information",
      "2. Current Address",
      "3. Permanent Address",
      "4. Work Address",
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        title: Text(
          "Add Customer",
          style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : Colors.indigo,
            ),
            onPressed: () async {
              await ThemeService.toggleTheme();
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            /// STEP INDICATOR HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: cardBg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stepTitles[_currentStep],
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Step ${_currentStep + 1} of 4",
                        style: TextStyle(color: textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(4, (index) {
                      final isActive = index <= _currentStep;
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.blue : (isDark ? Colors.white24 : Colors.black12),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            /// PAGE STEP CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildCurrentStepContent(cardBg, textPrimary, textSecondary, inputFill, isDark),
              ),
            ),

            /// BOTTOM NAVIGATION BAR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _prevStep,
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text("Back"),
                    ),
                    const SizedBox(width: 10),
                  ],

                  if (_currentStep < 3) ...[
                    /// SAVE BUTTON (PAGES 1, 2, 3)
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSaving ? null : () => _saveCurrentProgress(isFinal: true),
                        icon: _isSaving
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save, size: 18),
                        label: const Text(
                          "Save",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// NEXT BUTTON
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSaving ? null : _nextStep,
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text(
                          "Next",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ] else ...[
                    /// PAGE 4: COMBINED SINGLE "SAVE & FINISH" BUTTON
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isSaving ? null : () => _saveCurrentProgress(isFinal: true),
                        icon: _isSaving
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.check_circle, size: 20),
                        label: const Text(
                          "Save & Finish",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(Color cardBg, Color textPrimary, Color textSecondary, Color inputFill, bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Personal(cardBg, textPrimary, textSecondary, inputFill, isDark);
      case 1:
        return _buildStep2CurrentAddress(cardBg, textPrimary, textSecondary, inputFill, isDark);
      case 2:
        return _buildStep3PermanentAddress(cardBg, textPrimary, textSecondary, inputFill, isDark);
      case 3:
        return _buildStep4WorkAddress(cardBg, textPrimary, textSecondary, inputFill, isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  // ===========================================================================
  // PAGE 1: PERSONAL INFORMATION
  // ===========================================================================
  Widget _buildStep1Personal(Color cardBg, Color textPrimary, Color textSecondary, Color inputFill, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Information",
          style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Enter basic profile details and primary contact information",
          style: TextStyle(color: textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),

        /// CUSTOMER TYPE DROPDOWN
        Text("Customer Type", style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCustomerType,
              isExpanded: true,
              dropdownColor: cardBg,
              style: TextStyle(color: textPrimary, fontSize: 15),
              items: ["Customer", "Subscriber", "Agent", "Other"].map((val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => selectedCustomerType = val);
              },
            ),
          ),
        ),
        if (selectedCustomerType == 'Other') ...[
          const SizedBox(height: 14),
          _buildTextField("Specify Customer Type", otherCustomerTypeController, textSecondary, inputFill, textPrimary),
        ],

        const SizedBox(height: 16),
        _buildTextField("Customer Full Name *", nameController, textSecondary, inputFill, textPrimary, hint: "Enter full name"),
        const SizedBox(height: 16),
        _buildTextField("Primary Mobile Number *", mobileController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.phone, hint: "10-digit mobile number"),
        const SizedBox(height: 16),
        _buildTextField("Alternate Mobile Number", alternateController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.phone, hint: "Optional contact number"),
        const SizedBox(height: 16),
        _buildTextField("Email Address", emailController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.emailAddress, hint: "name@example.com"),
        const SizedBox(height: 20),

        /// CUSTOMER PHOTO PICKER
        Text("Customer Photo", style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage('customer_photo'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: inputFill,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: customerPhotoFile != null ? Colors.green : (isDark ? Colors.white24 : Colors.black12)),
            ),
            child: Row(
              children: [
                Icon(
                  customerPhotoFile != null ? Icons.check_circle : Icons.add_a_photo,
                  color: customerPhotoFile != null ? Colors.green : Colors.blue,
                  size: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerPhotoFile != null ? "Photo Attached" : "Upload Customer Photo",
                        style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        customerPhotoFile != null ? customerPhotoFile!.path.split('/').last : "Tap to pick image from gallery",
                        style: TextStyle(color: textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.upload_file, color: Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // PAGE 2: CURRENT ADDRESS
  // ===========================================================================
  Widget _buildStep2CurrentAddress(Color cardBg, Color textPrimary, Color textSecondary, Color inputFill, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Address",
          style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Where the customer currently resides",
          style: TextStyle(color: textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),

        _buildTextField("House Name / Flat No.", currentHouseController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Building Name / Landmark", currentBuildingController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Village / Area", currentVillageController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Taluk", currentTalukController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("District", currentDistrictController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("State", currentStateController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Pincode", currentPincodeController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.number),
        const SizedBox(height: 20),

        /// INTERACTIVE MAP PICKER
        _buildMapSection("Current Location Map", currentLocation, currentMapController, (pos) {
          setState(() => currentLocation = pos);
        }, 'current', textSecondary, isDark),

        const SizedBox(height: 20),
        _buildPhotoPickerTile("Current Address Proof Document", currentAddressProofFile, 'current_address_proof', textPrimary, textSecondary, inputFill, isDark),
      ],
    );
  }

  // ===========================================================================
  // PAGE 3: PERMANENT ADDRESS (HOME ADDRESS)
  // ===========================================================================
  Widget _buildStep3PermanentAddress(Color cardBg, Color textPrimary, Color textSecondary, Color inputFill, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Permanent / Home Address",
          style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Native or permanent house details",
          style: TextStyle(color: textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),

        /// SAME AS CURRENT ADDRESS CHECKBOX
        Container(
          decoration: BoxDecoration(
            color: inputFill,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CheckboxListTile(
            activeColor: Colors.blue,
            title: Text("Same as Current Address", style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
            value: sameAsCurrentAddress,
            onChanged: (val) => _copyCurrentToHomeAddress(val ?? false),
          ),
        ),
        const SizedBox(height: 16),

        _buildTextField("House Name", homeHouseController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Landmark / Building", homeLandmarkController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Village / Area", homeVillageController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Taluk", homeTalukController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("District", homeDistrictController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("State", homeStateController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Pincode", homePincodeController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.number),
        const SizedBox(height: 20),

        /// INTERACTIVE MAP PICKER
        _buildMapSection("Permanent Location Map", homeLocation, homeMapController, (pos) {
          setState(() => homeLocation = pos);
        }, 'home', textSecondary, isDark),

        const SizedBox(height: 20),
        _buildPhotoPickerTile("Permanent Address Proof Document", homeAddressProofFile, 'home_address_proof', textPrimary, textSecondary, inputFill, isDark),
      ],
    );
  }

  // ===========================================================================
  // PAGE 4: WORK ADDRESS & FINISH
  // ===========================================================================
  Widget _buildStep4WorkAddress(Color cardBg, Color textPrimary, Color textSecondary, Color inputFill, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Work Address",
          style: TextStyle(color: textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          "Office or business place details",
          style: TextStyle(color: textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),

        _buildTextField("Company / Business Name", companyNameController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Office Address", officeAddressController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Landmark", workLandmarkController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Village / Area", workVillageController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Taluk", workTalukController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("District", workDistrictController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("State", workStateController, textSecondary, inputFill, textPrimary),
        const SizedBox(height: 14),
        _buildTextField("Pincode", workPincodeController, textSecondary, inputFill, textPrimary, keyboardType: TextInputType.number),
        const SizedBox(height: 20),

        /// INTERACTIVE MAP PICKER
        _buildMapSection("Work Location Map", workLocation, workMapController, (pos) {
          setState(() => workLocation = pos);
        }, 'work', textSecondary, isDark),

        const SizedBox(height: 20),
        _buildPhotoPickerTile("Work Address Proof Document", workAddressProofFile, 'work_address_proof', textPrimary, textSecondary, inputFill, isDark),
      ],
    );
  }

  // ===========================================================================
  // HELPER WIDGETS
  // ===========================================================================

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    Color labelColor,
    Color fillColor,
    Color textColor, {
    TextInputType keyboardType = TextInputType.text,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: labelColor.withOpacity(0.6), fontSize: 13),
            filled: true,
            fillColor: fillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchAndSetDeviceLocation(
    String targetKey,
    ValueChanged<LatLng> onLocationChanged,
    GoogleMapController? mapCtrl,
  ) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      onLocationChanged(latLng);

      final ctrl = (targetKey == 'current')
          ? currentMapController
          : (targetKey == 'home')
              ? homeMapController
              : workMapController;
      ctrl?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 16));
    } catch (e) {
      debugPrint("Error fetching GPS location: $e");
    }
  }

  Widget _buildMapSection(
    String title,
    LatLng pos,
    GoogleMapController? mapCtrl,
    ValueChanged<LatLng> onLocationChanged,
    String targetKey,
    Color textSecondary,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(color: textSecondary, fontSize: 13, fontWeight: FontWeight.w600)),
            TextButton.icon(
              style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 24)),
              onPressed: () => _fetchAndSetDeviceLocation(targetKey, onLocationChanged, mapCtrl),
              icon: const Icon(Icons.my_location, size: 16, color: Colors.blue),
              label: const Text("Use My Location", style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 180,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: pos, zoom: 14),
              onMapCreated: (ctrl) {
                if (targetKey == 'current') currentMapController = ctrl;
                if (targetKey == 'home') homeMapController = ctrl;
                if (targetKey == 'work') workMapController = ctrl;
              },
              onTap: onLocationChanged,
              markers: {
                Marker(
                  markerId: MarkerId(targetKey),
                  position: pos,
                  draggable: true,
                  onDragEnd: onLocationChanged,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Icon(Icons.pin_drop, size: 16, color: Colors.red),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF334155),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPickerTile(
    String label,
    File? file,
    String targetKey,
    Color textPrimary,
    Color textSecondary,
    Color inputFill,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => _pickImage(targetKey),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: inputFill,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: file != null ? Colors.green : (isDark ? Colors.white24 : Colors.black12)),
        ),
        child: Row(
          children: [
            Icon(
              file != null ? Icons.check_circle : Icons.insert_drive_file,
              color: file != null ? Colors.green : Colors.blue,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file != null ? "$label Selected" : label,
                    style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    file != null ? file.path.split('/').last : "Tap to select file / photo",
                    style: TextStyle(color: textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.upload_file, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }
}