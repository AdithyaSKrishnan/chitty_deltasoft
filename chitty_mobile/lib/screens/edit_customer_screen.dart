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
companyController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['building_name'] ?? '',
);

officeAddressController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['house_name'] ?? '',
);

officePhoneController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['pincode'] ?? '',
);

officeLandmarkController =
    TextEditingController(
  text: widget.customer[
      'work_address']?['landmark'] ?? '',
);
  }
  Future<void> updateCustomer() async {

  bool success =
      await AuthService.updateCustomer(

    customerId: widget.customer['id'],

    fullName: nameController.text,

    mobileNumber: mobileController.text,

    alternateNumber:
        alternateController.text,

    email: emailController.text,

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
    companyName:
    companyController.text,

officeAddress:
    officeAddressController.text,

officePhone:
    officePhoneController.text,

officeLandmark:
    officeLandmarkController.text,
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

const Text(
  'Home Address',
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 15),

TextField(
  controller: houseController,
  decoration: const InputDecoration(
    labelText: 'House Name',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: landmarkController,
  decoration: const InputDecoration(
    labelText: 'Landmark',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: villageController,
  decoration: const InputDecoration(
    labelText: 'Village',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: talukController,
  decoration: const InputDecoration(
    labelText: 'Taluk',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: districtController,
  decoration: const InputDecoration(
    labelText: 'District',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: stateController,
  decoration: const InputDecoration(
    labelText: 'State',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: pincodeController,
  decoration: const InputDecoration(
    labelText: 'Pincode',
  ),
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
    labelText: 'Office Phone',
  ),
),

const SizedBox(height: 15),

TextField(
  controller: officeLandmarkController,
  decoration: const InputDecoration(
    labelText: 'Office Landmark',
  ),
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