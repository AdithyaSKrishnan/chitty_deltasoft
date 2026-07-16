import 'dart:io';

class CustomerFormData {
  //==========================
  // PERSONAL INFORMATION
  //==========================

  String fullName = '';
  String mobileNumber = '';
  String alternateNumber = '';
  String email = '';
  String customerType = 'Customer';
  String otherCustomerType = '';

  //==========================
  // HOME ADDRESS
  //==========================

  String homeHouseName = '';
  String homeBuildingName = '';
  String homeLandmark = '';
  String homeVillage = '';
  String homeTaluk = '';
  String homeDistrict = '';
  String homeState = '';
  String homePincode = '';

  double? homeLatitude;
  double? homeLongitude;

  //==========================
  // CURRENT ADDRESS
  //==========================

  String currentHouseName = '';
  String currentBuildingName = '';
  String currentLandmark = '';
  String currentVillage = '';
  String currentTaluk = '';
  String currentDistrict = '';
  String currentState = '';
  String currentPincode = '';

  double? currentLatitude;
  double? currentLongitude;

  //==========================
  // WORK ADDRESS
  //==========================

  String companyName = '';
  String officeAddress = '';

  String workLandmark = '';
  String workVillage = '';
  String workTaluk = '';
  String workDistrict = '';
  String workState = '';
  String workPincode = '';

  double? workLatitude;
  double? workLongitude;

  //==========================
  // PHOTOS
  //==========================

  File? customerPhoto;

  File? homeAddressProof;

  File? currentAddressProof;

  File? workAddressProof;

  File? idProof;
}