import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class EditCustomerScreen extends StatefulWidget {

  final Map customer;

  const EditCustomerScreen({
    super.key,
    required this.customer,
  });

  @override
  State<EditCustomerScreen> createState() =>
      _EditCustomerScreenState();
}

class _EditCustomerScreenState
    extends State<EditCustomerScreen> {

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

  late TextEditingController companyController;

late TextEditingController officeAddressController;

late TextEditingController officePhoneController;

late TextEditingController officeLandmarkController;
late TextEditingController currentHouseController;
late TextEditingController currentBuildingController;
late TextEditingController currentLandmarkController;
late TextEditingController currentVillageController;
late TextEditingController currentTalukController;
late TextEditingController currentDistrictController;
late TextEditingController currentStateController;
late TextEditingController currentPincodeController;

late TextEditingController mapUrlController;
late TextEditingController currentMapUrlController;
late TextEditingController workMapUrlController;

double? homeLatitude;
double? homeLongitude;
double? currentLatitude;
double? currentLongitude;
double? workLatitude;
double? workLongitude;

bool sameAsCurrentAddress = false;

void copyCurrentToHome() {
  houseController.text = currentHouseController.text;
  landmarkController.text = currentLandmarkController.text;
  villageController.text = currentVillageController.text;
  talukController.text = currentTalukController.text;
  districtController.text = currentDistrictController.text;
  stateController.text = currentStateController.text;
  pincodeController.text = currentPincodeController.text;
  mapUrlController.text = currentMapUrlController.text;
  homeLatitude = currentLatitude;
  homeLongitude = currentLongitude;
}

void parseAndSetLocation(String url, String type) {
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
      if (type == 'current') {
        currentLatitude = lat;
        currentLongitude = lng;
      } else if (type == 'home') {
        homeLatitude = lat;
        homeLongitude = lng;
      } else if (type == 'work') {
        workLatitude = lat;
        workLongitude = lng;
      }
    }
  }
}
  
  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.customer['full_name'] ?? '',
    );

    mobileController = TextEditingController(
      text: widget.customer['mobile_number'] ?? '',
    );

    emailController = TextEditingController(
      text: widget.customer['email'] ?? '',
    );

    alternateController = TextEditingController(
      text: widget.customer['alternate_number'] ?? '',
    );

    houseController = TextEditingController(
      text: widget.customer['home_address']?['house_name'] ?? '',
    );

    landmarkController = TextEditingController(
      text: widget.customer['home_address']?['landmark'] ?? '',
    );

    villageController = TextEditingController(
      text: widget.customer['home_address']?['village'] ?? '',
    );

    talukController = TextEditingController(
      text: widget.customer['home_address']?['taluk'] ?? '',
    );

    districtController = TextEditingController(
      text: widget.customer['home_address']?['district'] ?? '',
    );

    stateController = TextEditingController(
      text: widget.customer['home_address']?['state'] ?? '',
    );

    pincodeController = TextEditingController(
      text: widget.customer['home_address']?['pincode'] ?? '',
    );

    mapUrlController = TextEditingController(
      text: widget.customer['home_address']?['google_maps_link'] ?? '',
    );

    companyController = TextEditingController(
      text: widget.customer['work_address']?['building_name'] ?? '',
    );

    officeAddressController = TextEditingController(
      text: widget.customer['work_address']?['house_name'] ?? '',
    );

    officePhoneController = TextEditingController(
      text: widget.customer['work_address']?['pincode'] ?? '',
    );

    officeLandmarkController = TextEditingController(
      text: widget.customer['work_address']?['landmark'] ?? '',
    );

    workMapUrlController = TextEditingController(
      text: widget.customer['work_address']?['google_maps_link'] ?? '',
    );

    currentHouseController = TextEditingController(
      text: widget.customer['current_address']?['house_name'] ?? '',
    );

    currentBuildingController = TextEditingController(
      text: widget.customer['current_address']?['building_name'] ?? '',
    );

    currentLandmarkController = TextEditingController(
      text: widget.customer['current_address']?['landmark'] ?? '',
    );

    currentVillageController = TextEditingController(
      text: widget.customer['current_address']?['village'] ?? '',
    );

    currentTalukController = TextEditingController(
      text: widget.customer['current_address']?['taluk'] ?? '',
    );

    currentDistrictController = TextEditingController(
      text: widget.customer['current_address']?['district'] ?? '',
    );

    currentStateController = TextEditingController(
      text: widget.customer['current_address']?['state'] ?? '',
    );

    currentPincodeController = TextEditingController(
      text: widget.customer['current_address']?['pincode'] ?? '',
    );

    currentMapUrlController = TextEditingController(
      text: widget.customer['current_address']?['google_maps_link'] ?? '',
    );

    homeLatitude = double.tryParse(widget.customer['home_address']?['latitude']?.toString() ?? '');
    homeLongitude = double.tryParse(widget.customer['home_address']?['longitude']?.toString() ?? '');

    currentLatitude = double.tryParse(widget.customer['current_address']?['latitude']?.toString() ?? '');
    currentLongitude = double.tryParse(widget.customer['current_address']?['longitude']?.toString() ?? '');

    workLatitude = double.tryParse(widget.customer['work_address']?['latitude']?.toString() ?? '');
    workLongitude = double.tryParse(widget.customer['work_address']?['longitude']?.toString() ?? '');
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
      homeLatitude: homeLatitude,
      homeLongitude: homeLongitude,
      currentHouseName: currentHouseController.text,
      currentBuildingName: currentBuildingController.text,
      currentLandmark: currentLandmarkController.text,
      currentVillage: currentVillageController.text,
      currentTaluk: currentTalukController.text,
      currentDistrict: currentDistrictController.text,
      currentState: currentStateController.text,
      currentPincode: currentPincodeController.text,
      currentGoogleMapsLink: currentMapUrlController.text,
      currentLatitude: currentLatitude,
      currentLongitude: currentLongitude,
      companyName: companyController.text,
      officeAddress: officeAddressController.text,
      officeLandmark: officeLandmarkController.text,
      workVillage: "",
      workTaluk: "",
      workDistrict: "",
      workState: "",
      workPincode: "",
      workGoogleMapsLink: workMapUrlController.text,
      workLatitude: workLatitude,
      workLongitude: workLongitude,
    );

  if (success) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Customer Updated',
        ),
      ),
    );

    Navigator.pop(context,true);
  }

  else {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content: Text(
          'Update Failed',
        ),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Edit Customer',
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
        child: Column(

          children: [
TextField(
  controller: nameController,
  decoration: const InputDecoration(
    labelText: 'Customer Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: mobileController,
  decoration: const InputDecoration(
    labelText: 'Mobile Number',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: alternateController,
  decoration: const InputDecoration(
    labelText: 'Alternate Number',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: emailController,
  decoration: const InputDecoration(
    labelText: 'Email',
  ),
),

const SizedBox(height: 25),

const SizedBox(height: 25),

const Text(
  'Current Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: currentHouseController,
  decoration: const InputDecoration(
    labelText: 'Current House Name',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentLandmarkController,
  decoration: const InputDecoration(
    labelText: 'Current Landmark',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentVillageController,
  decoration: const InputDecoration(
    labelText: 'Current Village',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentTalukController,
  decoration: const InputDecoration(
    labelText: 'Current Taluk',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentDistrictController,
  decoration: const InputDecoration(
    labelText: 'Current District',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentStateController,
  decoration: const InputDecoration(
    labelText: 'Current State',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentPincodeController,
  decoration: const InputDecoration(
    labelText: 'Current Pincode',
  ),
  onChanged: (_) {
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 15),

TextField(
  controller: currentMapUrlController,
  decoration: const InputDecoration(
    labelText: 'Current Google Maps Link',
    hintText: 'Paste Google Maps link or coordinates',
    prefixIcon: Icon(Icons.link),
  ),
  onChanged: (val) {
    parseAndSetLocation(val, 'current');
    if (sameAsCurrentAddress) copyCurrentToHome();
  },
),

const SizedBox(height: 25),

Row(
  children: [
    const Text(
      'Permanent (Home) Address',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ],
),

CheckboxListTile(
  contentPadding: EdgeInsets.zero,
  title: const Text('Permanent Address is Same as Current Address'),
  value: sameAsCurrentAddress,
  onChanged: (val) {
    setState(() {
      sameAsCurrentAddress = val ?? false;
      if (sameAsCurrentAddress) {
        copyCurrentToHome();
      }
    });
  },
),

const SizedBox(height: 15),

TextField(
  controller: houseController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'House Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: landmarkController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'Landmark',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: villageController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'Village',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: talukController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'Taluk',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: districtController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'District',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: stateController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'State',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: pincodeController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'Pincode',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: mapUrlController,
  enabled: !sameAsCurrentAddress,
  decoration: const InputDecoration(
    labelText: 'Permanent Google Maps Link',
    hintText: 'Paste Google Maps link or coordinates',
    prefixIcon: Icon(Icons.link),
  ),
  onChanged: (val) {
    parseAndSetLocation(val, 'home');
  },
),

const SizedBox(height: 25),

const Text(
  'Work Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: companyController,
  decoration: const InputDecoration(
    labelText: 'Company Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officeAddressController,
  decoration: const InputDecoration(
    labelText: 'Office Address',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officePhoneController,
  decoration: const InputDecoration(
    labelText: 'Office Phone / Pincode',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officeLandmarkController,
  decoration: const InputDecoration(
    labelText: 'Office Landmark',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: workMapUrlController,
  decoration: const InputDecoration(
    labelText: 'Work Google Maps Link',
    hintText: 'Paste Google Maps link or coordinates',
    prefixIcon: Icon(Icons.link),
  ),
  onChanged: (val) {
    parseAndSetLocation(val, 'work');
  },
),

const SizedBox(height: 25),


ElevatedButton(
  onPressed: updateCustomer,
  child: const Text(
    'Update Customer',
  ),
),
          ],
        ),
      ),
    ));
  }
}