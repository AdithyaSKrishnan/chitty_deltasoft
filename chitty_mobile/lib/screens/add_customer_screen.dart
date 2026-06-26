import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/auth_service.dart';
//import '../widgets/subscription_dialog.dart';
import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;


import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() =>
      _AddCustomerScreenState();
}

class _AddCustomerScreenState
    extends State<AddCustomerScreen> {
  @override
void initState() {
  super.initState();

  getCurrentLocation();
}

  bool showWorkAddress = false;
  final nameController = TextEditingController();

  final mobileController = TextEditingController();

  final alternateController =
    TextEditingController();

final emailController =
    TextEditingController();
  final houseController =
    TextEditingController();

final landmarkController =
    TextEditingController();

final villageController =
    TextEditingController();

final talukController =
    TextEditingController();

final districtController =
    TextEditingController();

final stateController =
    TextEditingController();

final pincodeController =
    TextEditingController();
final companyController =
    TextEditingController();

final officeAddressController =
    TextEditingController();

final officePhoneController =
    TextEditingController();

final officeLandmarkController =
    TextEditingController();
  //bool enrollInChitPlan = false;
  File? customerPhotoFile;
File? addressProofFile;
File? idProofFile;
  //int? selectedPlanId;
  //String? selectedJoinedDate;
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

     Future<void> saveCustomer() async {

    final created = await AuthService.createCustomer(

      fullName:
          nameController.text,

      mobileNumber:
          mobileController.text,

      alternateNumber:
          alternateController.text,

      email:
          emailController.text,
      houseName:
    houseController.text,

landmark:
    landmarkController.text,

village:
    villageController.text,

taluk:
    talukController.text,

district:
    districtController.text,

state:
    stateController.text,

pincode:
    pincodeController.text,
    latitude: customerLocation.latitude,
longitude: customerLocation.longitude,

    companyName: companyController.text,
  officeAddress: officeAddressController.text,
  officePhone: officePhoneController.text,
  officeLandmark: officeLandmarkController.text,

  customerPhoto: customerPhotoFile,
  addressProof: addressProofFile,
  idProof: idProofFile,

    );

    if (created != null) {
      //final customerId = created['id'];

      

      // Not enrolling: success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Customer Added'),
        ),
      );
      Navigator.pop(context, true);
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add customer'),
        ),
      );
      return;
    }
  }

  //GoogleMapController? mapController;

  latlng.LatLng customerLocation =
    const latlng.LatLng(
  8.8932,
  76.6141,
);
  Future<void> getCurrentLocation() async {

  bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    return;
  }

  LocationPermission permission =
      await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {

    permission =
        await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return;
    }
  }

  Position position =
      await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  setState(() {

    customerLocation = latlng.LatLng(
  position.latitude,
  position.longitude,
);
  });

  
}

  Widget buildField(
  String hint, {
  TextEditingController? controller,
}) {
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
        fillColor: const Color(0xFF0F172A),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

  Widget sectionTitle(String title) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),

      child: Text(
        title,

        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
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

    bool mobile = width < 700;

    return Scaffold(

      backgroundColor: const Color(0xFF020617),

      appBar: AppBar(
        backgroundColor: const Color(0xFF020617),

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Add Customer',

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// PERSONAL INFO
              sectionTitle('Personal Information'),

              mobile
                  ? Column(
                      children: [

                        buildField(
  'Customer Name',
  controller: nameController,
),
                        buildField('Customer ID'),
                        buildField(
  'Primary Mobile Number',
  controller: mobileController,
),
                        buildField(
  'Alternate Mobile Number',
  controller: alternateController,
),
                        buildField(
  'Email Address',
  controller: emailController,
),
                      ],
                    )

                  : Row(
                      children: [

                        Expanded(
                          child: Column(
                            children: [

                              buildField(
  'Customer Name',
  controller: nameController,
),
                             buildField(
  'Primary Mobile Number',
  controller: mobileController,
),

                              buildField(
  'Email Address',
  controller: emailController,
),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            children: [

                              
                              buildField('Alternate Mobile Number'),
                            ],
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 30),

              /// HOME ADDRESS
              sectionTitle('Home Address'),

              mobile
                  ? Column(
                      children: [

                        buildField(
  'House Name',
  controller: houseController,
),

buildField(
  'Landmark',
  controller: landmarkController,
),

buildField(
  'Village / Area',
  controller: villageController,
),

buildField(
  'Taluk',
  controller: talukController,
),

buildField(
  'District',
  controller: districtController,
),

buildField(
  'State',
  controller: stateController,
),

buildField(
  'PIN Code',
  controller: pincodeController,
),
                      ],
                    )

                  : Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Expanded(
                          child: Column(
                            children: [
buildField(
  'House Name',
  controller: houseController,
),

buildField(
  'Village / Area',
  controller: villageController,
),

buildField(
  'District',
  controller: districtController,
),

buildField(
  'PIN Code',
  controller: pincodeController,
),
                            ],
                          ),
                        ),

                        const SizedBox(width: 20),

                        Expanded(
                          child: Column(
                            children: [
buildField(
  'Landmark',
  controller: landmarkController,
),

buildField(
  'Taluk',
  controller: talukController,
),

buildField(
  'State',
  controller: stateController,
),
                            ],
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 20),

              /// GOOGLE MAP
              /* 
              child: GoogleMap(
  initialCameraPosition:
      CameraPosition(
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
      markerId:
          const MarkerId('customer'),

      position: customerLocation,

      draggable: true,

      onDragEnd: (newPosition) {
        setState(() {
          customerLocation =
              newPosition;
        });
      },
    ),
  },

  myLocationEnabled: true,
  myLocationButtonEnabled: true,
  zoomControlsEnabled: false,
),
              */
              Container(
                height: 320,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                ),

                child: ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: FlutterMap(
    options: MapOptions(
      initialCenter: customerLocation,
      initialZoom: 14,
      onTap: (tapPosition, point) {
        setState(() {
          customerLocation = point;
        });
      },
    ),
    children: [
      TileLayer(
        urlTemplate:
            'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
        userAgentPackageName:
            'com.example.chitty_mobile',

      ),
      MarkerLayer(
        markers: [
          Marker(
            point: customerLocation,
            width: 40,
            height: 40,
            child: const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 40,
            ),
          ),
        ],
      ),
    ],
  ),
),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      'Selected Location',

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Latitude : ${customerLocation.latitude}',

                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Longitude : ${customerLocation.longitude}',

                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// WORK ADDRESS
              Container(
                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: CheckboxListTile(

                  value: showWorkAddress,

                  onChanged: (value) {

                    setState(() {

                      showWorkAddress = value!;
                    });
                  },

                  activeColor: Colors.blue,

                  title: const Text(
                    'Add Work Address',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  subtitle: const Text(
                    'Include customer work location',

                    style: TextStyle(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (showWorkAddress) ...[

                sectionTitle('Work Address'),

                buildField(
  'Company Name',
  controller: companyController,
),

buildField(
  'Office Address',
  controller: officeAddressController,
),

buildField(
  'Office Phone',
  controller: officePhoneController,
),

buildField(
  'Office Landmark',
  controller: officeLandmarkController,
),
              ],

              const SizedBox(height: 30),

              /// PHOTO UPLOADS
              sectionTitle('Photo Uploads'),

              GridView.count(

                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),

                crossAxisCount:
                    mobile ? 1 : 2,

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
    'Address Proof',
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

              const SizedBox(height: 40),

              /// ENROLL
              
              //const SizedBox(height: 40),

              /// BUTTONS
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  OutlinedButton(

                    onPressed: () {

                      Navigator.pop(context);
                    },

                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 18,
                      ),
                    ),

                    child: const Text(
                      'Cancel',
                    ),
                  ),

                  const SizedBox(width: 20),

                  ElevatedButton(

                    onPressed: saveCustomer,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 34,
                        vertical: 18,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                    ),

                    child: const Text(
                      'Save Customer',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}