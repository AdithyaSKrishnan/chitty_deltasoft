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
  // Personal Info
  late TextEditingController nameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController alternateController;

  // Home Address
  late TextEditingController homeHouseController;
  late TextEditingController homeLandmarkController;
  late TextEditingController homeVillageController;
  late TextEditingController homeTalukController;
  late TextEditingController homeDistrictController;
  late TextEditingController homeStateController;
  late TextEditingController homePincodeController;
  GoogleMapController? homeMapController;
  LatLng homeLocation = const LatLng(8.8932, 76.6141);

  // Current Address
  bool sameAsHomeAddress = true;
  late TextEditingController currentHouseController;
  late TextEditingController currentLandmarkController;
  late TextEditingController currentVillageController;
  late TextEditingController currentTalukController;
  late TextEditingController currentDistrictController;
  late TextEditingController currentStateController;
  late TextEditingController currentPincodeController;
  GoogleMapController? currentMapController;
  LatLng currentPosLocation = const LatLng(8.8932, 76.6141);

  // Work Address
  late TextEditingController companyNameController;
  late TextEditingController officeAddressController;
  late TextEditingController workLandmarkController;
  late TextEditingController workVillageController;
  late TextEditingController workTalukController;
  late TextEditingController workDistrictController;
  late TextEditingController workStateController;
  late TextEditingController workPincodeController;
  GoogleMapController? workMapController;
  LatLng workLocation = const LatLng(8.8932, 76.6141);

  @override
  void initState() {
    super.initState();

    final homeAddr = widget.customer['home_address'] ?? {};
    final currentAddr = widget.customer['current_address'] ?? {};
    final workAddr = widget.customer['work_address'] ?? {};

    // Personal
    nameController = TextEditingController(text: widget.customer['full_name'] ?? '');
    mobileController = TextEditingController(text: widget.customer['mobile_number'] ?? '');
    emailController = TextEditingController(text: widget.customer['email'] ?? '');
    alternateController = TextEditingController(text: widget.customer['alternate_number'] ?? '');

    // Home Address
    homeHouseController = TextEditingController(text: homeAddr['house_name'] ?? '');
    homeLandmarkController = TextEditingController(text: homeAddr['landmark'] ?? '');
    homeVillageController = TextEditingController(text: homeAddr['village'] ?? '');
    homeTalukController = TextEditingController(text: homeAddr['taluk'] ?? '');
    homeDistrictController = TextEditingController(text: homeAddr['district'] ?? '');
    homeStateController = TextEditingController(text: homeAddr['state'] ?? '');
    homePincodeController = TextEditingController(text: homeAddr['pincode'] ?? '');

    final homeLat = double.tryParse(homeAddr['latitude']?.toString() ?? '');
    final homeLng = double.tryParse(homeAddr['longitude']?.toString() ?? '');
    if (homeLat != null && homeLng != null && homeLat != 0 && homeLng != 0) {
      homeLocation = LatLng(homeLat, homeLng);
    }

    // Current Address
    currentHouseController = TextEditingController(text: currentAddr['house_name'] ?? '');
    currentLandmarkController = TextEditingController(text: currentAddr['landmark'] ?? '');
    currentVillageController = TextEditingController(text: currentAddr['village'] ?? '');
    currentTalukController = TextEditingController(text: currentAddr['taluk'] ?? '');
    currentDistrictController = TextEditingController(text: currentAddr['district'] ?? '');
    currentStateController = TextEditingController(text: currentAddr['state'] ?? '');
    currentPincodeController = TextEditingController(text: currentAddr['pincode'] ?? '');

    final currLat = double.tryParse(currentAddr['latitude']?.toString() ?? '');
    final currLng = double.tryParse(currentAddr['longitude']?.toString() ?? '');
    if (currLat != null && currLng != null && currLat != 0 && currLng != 0) {
      currentPosLocation = LatLng(currLat, currLng);
      sameAsHomeAddress = false;
    } else {
      currentPosLocation = homeLocation;
    }

    // Work Address
    companyNameController = TextEditingController(text: workAddr['building_name'] ?? '');
    officeAddressController = TextEditingController(text: workAddr['house_name'] ?? '');
    workLandmarkController = TextEditingController(text: workAddr['landmark'] ?? '');
    workVillageController = TextEditingController(text: workAddr['village'] ?? '');
    workTalukController = TextEditingController(text: workAddr['taluk'] ?? '');
    workDistrictController = TextEditingController(text: workAddr['district'] ?? '');
    workStateController = TextEditingController(text: workAddr['state'] ?? '');
    workPincodeController = TextEditingController(text: workAddr['pincode'] ?? '');

    final wLat = double.tryParse(workAddr['latitude']?.toString() ?? '');
    final wLng = double.tryParse(workAddr['longitude']?.toString() ?? '');
    if (wLat != null && wLng != null && wLat != 0 && wLng != 0) {
      workLocation = LatLng(wLat, wLng);
    }
  }

  Future<void> getCurrentLocationFor(String type) async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      if (!mounted) return;
      final newPos = LatLng(position.latitude, position.longitude);
      setState(() {
        if (type == 'home') {
          homeLocation = newPos;
          homeMapController?.animateCamera(CameraUpdate.newLatLng(newPos));
          if (sameAsHomeAddress) {
            currentPosLocation = newPos;
          }
        } else if (type == 'current') {
          currentPosLocation = newPos;
          currentMapController?.animateCamera(CameraUpdate.newLatLng(newPos));
        } else if (type == 'work') {
          workLocation = newPos;
          workMapController?.animateCamera(CameraUpdate.newLatLng(newPos));
        }
      });
    } catch (_) {}
  }

  Future<void> updateCustomer() async {
    final finalCurrentHouse = sameAsHomeAddress ? homeHouseController.text : currentHouseController.text;
    final finalCurrentLandmark = sameAsHomeAddress ? homeLandmarkController.text : currentLandmarkController.text;
    final finalCurrentVillage = sameAsHomeAddress ? homeVillageController.text : currentVillageController.text;
    final finalCurrentTaluk = sameAsHomeAddress ? homeTalukController.text : currentTalukController.text;
    final finalCurrentDistrict = sameAsHomeAddress ? homeDistrictController.text : currentDistrictController.text;
    final finalCurrentState = sameAsHomeAddress ? homeStateController.text : currentStateController.text;
    final finalCurrentPincode = sameAsHomeAddress ? homePincodeController.text : currentPincodeController.text;
    final finalCurrentLat = sameAsHomeAddress ? homeLocation.latitude : currentPosLocation.latitude;
    final finalCurrentLng = sameAsHomeAddress ? homeLocation.longitude : currentPosLocation.longitude;

    bool success = await AuthService.updateCustomer(
      customerId: widget.customer['id'],
      fullName: nameController.text,
      mobileNumber: mobileController.text,
      alternateNumber: alternateController.text,
      email: emailController.text,

      // Home Address
      houseName: homeHouseController.text,
      landmark: homeLandmarkController.text,
      village: homeVillageController.text,
      taluk: homeTalukController.text,
      district: homeDistrictController.text,
      state: homeStateController.text,
      pincode: homePincodeController.text,
      homeGoogleMapsLink: '',
      homeLatitude: homeLocation.latitude,
      homeLongitude: homeLocation.longitude,

      // Current Address
      currentHouseName: finalCurrentHouse,
      currentBuildingName: '',
      currentLandmark: finalCurrentLandmark,
      currentVillage: finalCurrentVillage,
      currentTaluk: finalCurrentTaluk,
      currentDistrict: finalCurrentDistrict,
      currentState: finalCurrentState,
      currentPincode: finalCurrentPincode,
      currentGoogleMapsLink: '',
      currentLatitude: finalCurrentLat,
      currentLongitude: finalCurrentLng,

      // Work Address
      companyName: companyNameController.text,
      officeAddress: officeAddressController.text,
      officeLandmark: workLandmarkController.text,
      workVillage: workVillageController.text,
      workTaluk: workTalukController.text,
      workDistrict: workDistrictController.text,
      workState: workStateController.text,
      workPincode: workPincodeController.text,
      workGoogleMapsLink: '',
      workLatitude: workLocation.latitude,
      workLongitude: workLocation.longitude,
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

  Widget buildAddressBlock({
    required String title,
    required TextEditingController houseCtrl,
    required TextEditingController landmarkCtrl,
    required TextEditingController villageCtrl,
    required TextEditingController talukCtrl,
    required TextEditingController districtCtrl,
    required TextEditingController stateCtrl,
    required TextEditingController pincodeCtrl,
    required LatLng location,
    required String type,
    required Function(GoogleMapController) onMapCreated,
    required Function(LatLng) onTapMap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: houseCtrl,
          decoration: const InputDecoration(labelText: 'House / Building Name'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: landmarkCtrl,
          decoration: const InputDecoration(labelText: 'Landmark'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: villageCtrl,
          decoration: const InputDecoration(labelText: 'Village / Area'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: talukCtrl,
          decoration: const InputDecoration(labelText: 'Taluk'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: districtCtrl,
          decoration: const InputDecoration(labelText: 'District'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: stateCtrl,
          decoration: const InputDecoration(labelText: 'State'),
        ),
        const SizedBox(height: 15),

        TextField(
          controller: pincodeCtrl,
          decoration: const InputDecoration(labelText: 'Pincode'),
        ),
        const SizedBox(height: 20),

        // Interactive Map
        SizedBox(
          height: 260,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: location,
                zoom: 14,
              ),
              onMapCreated: (c) => onMapCreated(c),
              onTap: (pos) => onTapMap(pos),
              markers: {
                Marker(
                  markerId: MarkerId(type),
                  position: location,
                ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$title Coordinates",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text("Lat: ${location.latitude.toStringAsFixed(6)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("Lng: ${location.longitude.toStringAsFixed(6)}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.my_location, color: Colors.blue),
                onPressed: () => getCurrentLocationFor(type),
              ),
            ],
          ),
        ),
      ],
    );
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
              const SizedBox(height: 30),

              // 1. Home Address
              buildAddressBlock(
                title: 'Home Address',
                houseCtrl: homeHouseController,
                landmarkCtrl: homeLandmarkController,
                villageCtrl: homeVillageController,
                talukCtrl: homeTalukController,
                districtCtrl: homeDistrictController,
                stateCtrl: homeStateController,
                pincodeCtrl: homePincodeController,
                location: homeLocation,
                type: 'home',
                onMapCreated: (c) => homeMapController = c,
                onTapMap: (pos) {
                  setState(() {
                    homeLocation = pos;
                    if (sameAsHomeAddress) currentPosLocation = pos;
                  });
                },
              ),

              const SizedBox(height: 30),

              // 2. Current Address
              Row(
                children: [
                  Checkbox(
                    value: sameAsHomeAddress,
                    onChanged: (val) {
                      setState(() {
                        sameAsHomeAddress = val ?? true;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Current Address is same as Home Address',
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ),
                ],
              ),

              if (!sameAsHomeAddress) ...[
                const SizedBox(height: 15),
                buildAddressBlock(
                  title: 'Current Address',
                  houseCtrl: currentHouseController,
                  landmarkCtrl: currentLandmarkController,
                  villageCtrl: currentVillageController,
                  talukCtrl: currentTalukController,
                  districtCtrl: currentDistrictController,
                  stateCtrl: currentStateController,
                  pincodeCtrl: currentPincodeController,
                  location: currentPosLocation,
                  type: 'current',
                  onMapCreated: (c) => currentMapController = c,
                  onTapMap: (pos) {
                    setState(() {
                      currentPosLocation = pos;
                    });
                  },
                ),
              ],

              const SizedBox(height: 30),

              // 3. Work Address
              ExpansionTile(
                title: const Text(
                  'Work Address (Optional)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: companyNameController,
                          decoration: const InputDecoration(labelText: 'Company Name'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: officeAddressController,
                          decoration: const InputDecoration(labelText: 'Office Address'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workLandmarkController,
                          decoration: const InputDecoration(labelText: 'Landmark'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workVillageController,
                          decoration: const InputDecoration(labelText: 'Village / Area'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workTalukController,
                          decoration: const InputDecoration(labelText: 'Taluk'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workDistrictController,
                          decoration: const InputDecoration(labelText: 'District'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workStateController,
                          decoration: const InputDecoration(labelText: 'State'),
                        ),
                        const SizedBox(height: 15),

                        TextField(
                          controller: workPincodeController,
                          decoration: const InputDecoration(labelText: 'Pincode'),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 260,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: workLocation,
                                zoom: 14,
                              ),
                              onMapCreated: (c) => workMapController = c,
                              onTap: (pos) {
                                setState(() {
                                  workLocation = pos;
                                });
                              },
                              markers: {
                                Marker(
                                  markerId: const MarkerId('work'),
                                  position: workLocation,
                                ),
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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