import 'package:flutter/material.dart';
import 'dart:io';
import 'package:chitty_mobile/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'customer_form_data.dart';

class AddCustomerStep3 extends StatefulWidget {

  final CustomerFormData formData;

  const AddCustomerStep3({
    super.key,
    required this.formData,
  });

  @override
  State<AddCustomerStep3> createState() => _AddCustomerStep3State();
}

class _AddCustomerStep3State extends State<AddCustomerStep3> {

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  //final houseController = TextEditingController();
  final landmarkController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  final companyController = TextEditingController();
  final officeAddressController = TextEditingController();
  GoogleMapController? mapController;

  LatLng customerLocation = const LatLng(
    8.8932,
    76.6141,
);

File? customerPhotoFile;
File? addressProofFile;
File? idProofFile;

@override
void initState() {
  super.initState();
  getCurrentLocation();
}

  Future<void> getCurrentLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationMessage(
          'Location is off. Tap the map to set the location manually.',
        );
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationMessage(
          'Location permission denied. Tap the map to set the location manually.',
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        customerLocation = newLocation;
      });
      mapController?.animateCamera(
        CameraUpdate.newLatLng(newLocation),
      );
    } catch (e) {
      _showLocationMessage(
        'Could not get current location. Tap the map to set it manually.',
      );
    }
  }
  void _showLocationMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  Future<void> pickImage(String type) async {
  final picker = ImagePicker();

  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.camera,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(
                context,
                ImageSource.gallery,
              );
            },
          ),
        ],
      ),
    ),
  );

  if (source == null) return;

  final pickedFile = await picker.pickImage(
    source: source,
  );

  if (pickedFile == null) return;

  setState(() {
    if (type == 'customer') {
      customerPhotoFile = File(pickedFile.path);
    } else if (type == 'address') {
      addressProofFile = File(pickedFile.path);
    } else if (type == 'id') {
      idProofFile = File(pickedFile.path);
    }
  });
}

  Widget buildField(
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(
          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white54,
          ),

          filled: true,
          fillColor: const Color(0xFF111827),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
    Widget uploadBox(
  String title,
  File? file,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 170,
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                file,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.upload_file,
                  color: Colors.white54,
                  size: 45,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap to upload',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
    ),
  );
}
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    final mobile = width < 700;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(

        backgroundColor: const Color(0xFF020617),

        title: const Text(
          "Add Customer",
          style: TextStyle(color: Colors.white),
        ),

      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              
const Text(
  "Work Address",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

if (mobile)

  Column(
    children: [

      buildField(
        "Company Name",
       companyController,
      ),
      buildField(
  "Office Address",
  officeAddressController,
),


      buildField(
        "Landmark",
        landmarkController,
      ),

      buildField(
        "Village / Area",
        villageController,
      ),

      buildField(
        "Taluk",
        talukController,
      ),

      buildField(
        "District",
        districtController,
      ),

      buildField(
        "State",
        stateController,
      ),

      buildField(
        "PIN Code",
        pincodeController,
      ),
    ],
  )

else

  Row(
    crossAxisAlignment: CrossAxisAlignment.start,

    children: [

      Expanded(
        child: Column(
          children: [

            buildField(
              "Company Name",
             companyController,
            ),

buildField(
  "Office Address",
  officeAddressController,
),

            buildField(
              "Village / Area",
              villageController,
            ),

            buildField(
              "District",
              districtController,
            ),

            buildField(
              "PIN Code",
              pincodeController,
            ),

          ],
        ),
      ),

      const SizedBox(width: 20),

      Expanded(
        child: Column(
          children: [

            buildField(
              "Landmark",
              landmarkController,
            ),

            buildField(
              "Taluk",
              talukController,
            ),

            buildField(
              "State",
              stateController,
            ),

          ],
        ),
      ),
    ],
  ),
              //const SizedBox(height: 30),
              const SizedBox(height: 20),

SizedBox(
  height: 320,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
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

const SizedBox(height: 20),

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
const Text(
  "Photo Uploads",
  style: TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 20),

GridView.count(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  crossAxisCount: mobile ? 1 : 2,
  crossAxisSpacing: 20,
  mainAxisSpacing: 20,
  childAspectRatio: 1.5,
  children: [

    

    uploadBox(
      'Work Address Proof',
      addressProofFile,
      () => pickImage('address'),
    ),

    

  ],
),

const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                onPressed: () async {

  // Save Step 3 data into CustomerFormData
widget.formData.companyName = companyController.text;
widget.formData.officeAddress = officeAddressController.text;

widget.formData.workLandmark = landmarkController.text;
widget.formData.workVillage = villageController.text;
widget.formData.workTaluk = talukController.text;
widget.formData.workDistrict = districtController.text;
widget.formData.workState = stateController.text;
widget.formData.workPincode = pincodeController.text;

widget.formData.workLatitude = customerLocation.latitude;
widget.formData.workLongitude = customerLocation.longitude;

widget.formData.workAddressProof = addressProofFile;
print("===== STEP 3 =====");
print(widget.formData.companyName);
print(widget.formData.officeAddress);
print(widget.formData.workLandmark);
print(widget.formData.workVillage);
print(widget.formData.workDistrict);
print(widget.formData.workState);
print(widget.formData.workPincode);
print(widget.formData.workLatitude);
print(widget.formData.workLongitude);
// Call backend
final result = await AuthService.createCustomer(

  fullName: widget.formData.fullName,
  mobileNumber: widget.formData.mobileNumber,
  alternateNumber: widget.formData.alternateNumber,
  email: widget.formData.email,

  // Home Address
  houseName: widget.formData.homeHouseName,
  landmark: widget.formData.homeLandmark,
  village: widget.formData.homeVillage,
  taluk: widget.formData.homeTaluk,
  district: widget.formData.homeDistrict,
  state: widget.formData.homeState,
  pincode: widget.formData.homePincode,
  homeLatitude: widget.formData.homeLatitude ?? 0,
  homeLongitude: widget.formData.homeLongitude ?? 0,

  // Current Address
  currentHouseName: widget.formData.currentHouseName,
  currentLandmark: widget.formData.currentLandmark,
  currentVillage: widget.formData.currentVillage,
  currentTaluk: widget.formData.currentTaluk,
  currentDistrict: widget.formData.currentDistrict,
  currentState: widget.formData.currentState,
  currentPincode: widget.formData.currentPincode,
  currentLatitude: widget.formData.currentLatitude ?? 0,
  currentLongitude: widget.formData.currentLongitude ?? 0,

  // Work Address
  companyName: widget.formData.companyName,
  officeAddress: widget.formData.officeAddress,
  workLandmark: widget.formData.workLandmark,
  workVillage: widget.formData.workVillage,
  workTaluk: widget.formData.workTaluk,
  workDistrict: widget.formData.workDistrict,
  workState: widget.formData.workState,
  workPincode: widget.formData.workPincode,
  workLatitude: widget.formData.workLatitude ?? 0,
  workLongitude: widget.formData.workLongitude ?? 0,

  // Photos
  customerPhoto: widget.formData.customerPhoto,
  homeAddressProof: widget.formData.homeAddressProof,
  currentAddressProof: widget.formData.currentAddressProof,
  workAddressProof: widget.formData.workAddressProof,
  idProof: widget.formData.idProof,
);

if (result != null) {
  if (!mounted) return;

  Navigator.of(context).popUntil((route) => route.isFirst);
} else {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Failed to save customer"),
    ),
  );
}
  // We'll save to backend here next.

},

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  child: const Text(

                    "Save Customer",

                    style: TextStyle(

                      fontSize: 18,

                    ),

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