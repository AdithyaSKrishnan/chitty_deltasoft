import 'package:flutter/material.dart';
import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'add_customer_step2.dart';
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

  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final alternateController = TextEditingController();
  final emailController = TextEditingController();
  final houseController = TextEditingController();
  final landmarkController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();
  String selectedCustomerType = "Customer";
  final otherCustomerTypeController = TextEditingController();
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

                "Personal Information",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 24,

                  fontWeight: FontWeight.bold,

                ),
              ),

              const SizedBox(height: 25),

              if (mobile)

                Column(

                  children: [
                    DropdownButtonFormField<String>(
  value: selectedCustomerType,
  dropdownColor: const Color(0xFF111827),

  decoration: InputDecoration(
    filled: true,
    fillColor: const Color(0xFF111827),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
  ),

  style: const TextStyle(
    color: Colors.white,
  ),

  items: const [

    DropdownMenuItem(
      value: "Customer",
      child: Text("Customer"),
    ),

    DropdownMenuItem(
      value: "Agent",
      child: Text("Agent"),
    ),

    DropdownMenuItem(
      value: "Guarantor",
      child: Text("Guarantor"),
    ),

    DropdownMenuItem(
      value: "Agent & Guarantor",
      child: Text("Agent & Guarantor"),
    ),

    DropdownMenuItem(
      value: "Other",
      child: Text("Other"),
    ),
  ],

  onChanged: (value) {

    setState(() {

      selectedCustomerType = value!;

    });

  },
),


const SizedBox(height: 18),
if (selectedCustomerType == "Other") ...[
  buildField(
    "Specify Customer Type",
    otherCustomerTypeController,
  ),

  const SizedBox(height: 18),
],

                    buildField(
                      "Customer Name",
                      nameController,
                    ),

                    buildField(
                      "Primary Mobile Number",
                      mobileController,
                    ),

                    buildField(
                      "Alternate Mobile Number",
                      alternateController,
                    ),

                    buildField(
                      "Email Address",
                      emailController,
                    ),
                  ],
                )

              else

                Row(

                  children: [

                    Expanded(

                      child: Column(

                        children: [

                          buildField(
                            "Customer Name",
                            nameController,
                          ),

                          buildField(
                            "Primary Mobile Number",
                            mobileController,
                          ),

                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    Expanded(

                      child: Column(

                        children: [

                          buildField(
                            "Alternate Mobile Number",
                            alternateController,
                          ),

                          buildField(
                            "Email Address",
                            emailController,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
const Text(
  "Home Address",
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
        "House Name",
        houseController,
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
              "House Name",
              houseController,
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
      'Customer Photo',
      customerPhotoFile,
      () => pickImage('customer'),
    ),

    uploadBox(
      'Home Address Proof',
      addressProofFile,
      () => pickImage('address'),
    ),

    uploadBox(
      'ID Proof',
      idProofFile,
      () => pickImage('id'),
    ),

  ],
),

const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed: () {

  // Personal Information
  widget.formData.fullName = nameController.text;
  widget.formData.mobileNumber = mobileController.text;
  widget.formData.alternateNumber = alternateController.text;
  widget.formData.email = emailController.text;
  widget.formData.customerType = selectedCustomerType;

widget.formData.otherCustomerType =
    otherCustomerTypeController.text;
  // Home Address
  widget.formData.homeHouseName = houseController.text;
  widget.formData.homeLandmark = landmarkController.text;
  widget.formData.homeVillage = villageController.text;
  widget.formData.homeTaluk = talukController.text;
  widget.formData.homeDistrict = districtController.text;
  widget.formData.homeState = stateController.text;
  widget.formData.homePincode = pincodeController.text;

  widget.formData.homeLatitude = customerLocation.latitude;
  widget.formData.homeLongitude = customerLocation.longitude;

  // Photos
  widget.formData.customerPhoto = customerPhotoFile;
  widget.formData.homeAddressProof = addressProofFile;
  widget.formData.idProof = idProofFile;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AddCustomerStep2(
        formData: widget.formData,
      ),
    ),
  );

},

                  style: ElevatedButton.styleFrom(

                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(16),

                    ),

                  ),

                  child: const Text(

                    "Next",

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