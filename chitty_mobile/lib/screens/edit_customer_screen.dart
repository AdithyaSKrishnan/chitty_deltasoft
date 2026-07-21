import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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

  GoogleMapController? mapController;
  LatLng customerLocation = const LatLng(8.8932, 76.6141);

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

    final lat = double.tryParse(homeAddr['latitude']?.toString() ?? '');
    final lng = double.tryParse(homeAddr['longitude']?.toString() ?? '');
    if (lat != null && lng != null && lat != 0 && lng != 0) {
      customerLocation = LatLng(lat, lng);
    } else {
      getCurrentLocation();
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (!mounted) return;
      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customerLocation = newLocation;
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
    } catch (_) {}
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
      homeGoogleMapsLink: '',
      homeLatitude: customerLocation.latitude,
      homeLongitude: customerLocation.longitude,
      currentHouseName: houseController.text,
      currentBuildingName: '',
      currentLandmark: landmarkController.text,
      currentVillage: villageController.text,
      currentTaluk: talukController.text,
      currentDistrict: districtController.text,
      currentState: stateController.text,
      currentPincode: pincodeController.text,
      currentGoogleMapsLink: '',
      currentLatitude: customerLocation.latitude,
      currentLongitude: customerLocation.longitude,
      companyName: '',
      officeAddress: '',
      officeLandmark: '',
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
              const SizedBox(height: 20),

              // Interactive Google Map Widget
              SizedBox(
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: customerLocation,
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      mapController = controller;
                    },
                    onTap: (LatLng position) {
                      setState(() {
                        customerLocation = position;
                      });
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('customer'),
                        position: customerLocation,
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Selected Location Coordinate Display Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selected Location",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Latitude : ${customerLocation.latitude}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      "Longitude : ${customerLocation.longitude}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
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