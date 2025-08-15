
import 'dart:math';

class Validator {

  static bool isEmail(String value) {
    // Regular expression for validating an email address
    final RegExp regex = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        caseSensitive: false,
        multiLine: false
    );
    return regex.hasMatch(value);
  }

  static String? getFormattedTenDigitNumber(String phone) {
    // Remove spaces, '+', '(', ')', and black spaces
    String cleanedPhone = phone.replaceAll(RegExp(r'[\s+\(\)]'), '');

    // Extract last 10 digits
    String tenDigitNumber = cleanedPhone.substring(max(0, cleanedPhone.length - 10));

    return tenDigitNumber.length == 10 ? tenDigitNumber : null;
  }

  static String? validateDomain(String? value) {
    if (value == null || value.isEmpty) {
      return 'Domain is required.';
    }

    // Regular expression for domain validation (e.g., example.com)
    final domainRegExp = RegExp(
        r"^(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"
    );

    if (!domainRegExp.hasMatch(value)) {
      return 'Invalid domain name.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if(value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");

    if(!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if(value == null || value.isEmpty) {
      return 'Password is required.';
    }

    //Check for minimum password lenth
    if(value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // //Check for uppercase letters
    // if(!value.contains(RegExp(r'[0-9]'))) {
    //   return 'Password must contain at least one number.';
    // }
    //
    // //Check for special characters
    // if(!value.contains(RegExp(r'[!@#%^&*()_+-=[]{}|;:",./<>?~`]'))){
    //   return 'Password must contain at least one special character.';
    // }

    return null;
  }

  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }

    // ITU E.164: max 15 digits, min 5 digits
    final regex = RegExp(r'^\d{5,15}$');

    if (!regex.hasMatch(phone)) {
      return 'Invalid phone number';
    }

    return null; // ✅ Valid
  }


  static String? validatePinCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pincode is required';
    }

    // Regular expression to match exactly six digits
    RegExp pinCodeRegex = RegExp(r'^\d{6}$');

    if (!pinCodeRegex.hasMatch(value)) {
      return 'Pincode must be a 6-digit number';
    }

    return null;
  }

  static String? validateEmptyText({String? fieldName, String? value}) {
    if(value == null || value.isEmpty){
      return '$fieldName is required';
    }
    return null;
  }

}





