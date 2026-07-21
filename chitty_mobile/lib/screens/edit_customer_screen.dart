import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class EditCustomerScreen extends StatefulWidget {
  final Map customer;

  const EditCustomerScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EditCustomerScreen> createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController alternateController;

  late TextEditingController houseController;
  late TextEditingController landmarkController;
  late TextEditingController villageController;
  late TextEditingController talukController;
  late TextEditingController districtController;
  late TextEditingController stateController;
  late TextEditingController pincodeController;
  late TextEditingController mapUrlController;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();

    final homeAddr = widget.customer['home_address'] ?? widget.customer['current_address'] ?? {};

    nameController = TextEditingController(text: widget.customer['full_name'] ?? '');
    mobileController = TextEditingController(text: widget.customer['mobile_number'] ?? '');
    emailController = TextEditingController(text: widget.customer['email'] ?? '');
    alternateController = TextEditingController(text: widget.customer['alternate_number'] ?? '');

    houseController = TextEditingController(text: homeAddr['house_name'] ?? '');
    landmarkController = TextEditingController(text: homeAddr['landmark'] ?? '');
    villageController = TextEditingController(text: homeAddr['village'] ?? '');
    talukController = TextEditingController(text: homeAddr['taluk'] ?? '');
    districtController = TextEditingController(text: homeAddr['district'] ?? '');
    stateController = TextEditingController(text: homeAddr['state'] ?? '');
    pincodeController = TextEditingController(text: homeAddr['pincode'] ?? '');
    mapUrlController = TextEditingController(text: homeAddr['google_maps_link'] ?? '');

    latitude = double.tryParse(homeAddr['latitude']?.toString() ?? '');
    longitude = double.tryParse(homeAddr['longitude']?.toString() ?? '');
  }

  void parseAndSetLocation(String url) {
    final regExp = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)|q=(-?\d+\.\d+),(-?\d+\.\d+)');
    final match = regExp.firstMatch(url);

    if (match != null) {
      double? lat;
      double? lng;
      if (match.group(1) != null && match.group(2) != null) {
        lat = double.tryParse(match.group(1)!);
        lng = double.tryParse(match.group(2)!);
      } else if (match.group(3) != null && match.group(4) != null) {
        lat = double.tryParse(match.group(3)!);
        lng = double.tryParse(match.group(4)!);
      }

      if (lat != null && lng != null) {
        setState(() {
          latitude = lat;
          longitude = lng;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location updated: $lat, $lng')),
        );
      }
    }
  }

  Future<void> updateCustomer() async {
    bool success = await AuthService.updateCustomer(
      customerId: widget.customer['id'],
      fullName: nameController.text,
      mobileNumber: mobileController.text,
      alternateNumber: alternateController.text,
      email: emailController.text,
      houseName: houseController.text,
      landmark: landmarkController.text,
      village: villageController.text,
      taluk: talukController.text,
      district: districtController.text,
      state: stateController.text,
      pincode: pincodeController.text,
      homeGoogleMapsLink: mapUrlController.text,
      homeLatitude: latitude,
      homeLongitude: longitude,
      currentHouseName: houseController.text,
      currentBuildingName: '',
      currentLandmark: landmarkController.text,
      currentVillage: villageController.text,
      currentTaluk: talukController.text,
      currentDistrict: districtController.text,
      currentState: stateController.text,
      currentPincode: pincodeController.text,
      currentGoogleMapsLink: mapUrlController.text,
      currentLatitude: latitude,
      currentLongitude: longitude,
      companyName: '',
      officeAddress: '',
      officeLandmark: '',
      officePhone: '',
      workVillage: '',
      workTaluk: '',
      workDistrict: '',
      workState: '',
      workPincode: '',
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer Updated Successfully')),
      );
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Update Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: alternateController,
                decoration: const InputDecoration(labelText: 'Alternate Number'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 25),

              const Text(
                'Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: houseController,
                decoration: const InputDecoration(labelText: 'House / Building Name'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: landmarkController,
                decoration: const InputDecoration(labelText: 'Landmark'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: villageController,
                decoration: const InputDecoration(labelText: 'Village / Area'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: talukController,
                decoration: const InputDecoration(labelText: 'Taluk'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'District'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: stateController,
                decoration: const InputDecoration(labelText: 'State'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: pincodeController,
                decoration: const InputDecoration(labelText: 'Pincode'),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: mapUrlController,
                decoration: const InputDecoration(
                  labelText: 'Google Maps Link',
                  hintText: 'Paste Google Maps link or coordinates',
                  prefixIcon: Icon(Icons.link),
                ),
                onChanged: parseAndSetLocation,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: updateCustomer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Update Customer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}