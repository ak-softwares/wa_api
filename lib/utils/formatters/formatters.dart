import 'package:intl/intl.dart';

class AppFormatter {

  static String formatDateSmall(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM').format(date); // e.g., 01/06
  }

  static String formatDateAsTime(DateTime? date) {
    if (date == null) {
      return '';
    }
    return DateFormat.jm().format(date.toLocal()); // Converts UTC to local
  }


  static String formatDate(DateTime? date) {
    if(date == null){
      return '';
    }
    return DateFormat('dd, MMM yyyy').format(date);
  }

  static String formatStringDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'N/A';
    }
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd, MMMM yyyy').format(dateTime);
    } catch (e) {
      return 'N/A'; // Handle invalid date format cases
    }
  }


  static String maskEmail(String email) {
    // Split email into username and domain
    List<String> parts = email.split('@');
    if (parts.length != 2) {
      // Invalid email format
      return email;
    }

    String username = parts[0];
    String domain = parts[1];

    // Extract first two characters
    String firstTwo = username.substring(0, 2);

    // Extract last two characters
    String lastTwo = username.substring(username.length - 2);

    return '$firstTwo***$lastTwo@$domain';
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    //Assuming a 10-digit US phone number format: (123) 456-7895
    if(phoneNumber.length == 10) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6) }';
    }else if(phoneNumber.length == 11) {
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7) }';
    }
    return phoneNumber;
  }

  static String formatPhoneNumberForWA(String input) {
    // Remove any non-digit characters (just in case)
    input = input.replaceAll(RegExp(r'\D'), '');

    // Assume country codes are 1 to 3 digits, e.g., 1 (US), 44 (UK), 91 (India)
    String countryCode = '';
    String numberPart = '';

    if (input.length > 10) {
      // Assuming last 10 digits are local number
      countryCode = input.substring(0, input.length - 10);
      numberPart = input.substring(input.length - 10);
    } else {
      // No country code, treat full input as number
      numberPart = input;
    }

    // Format local number as: XX XXXX XXXX
    if (numberPart.length == 10) {
      numberPart = '${numberPart.substring(0, 2)} ${numberPart.substring(2, 6)} ${numberPart.substring(6)}';
    }

    return '+$countryCode $numberPart';
  }

  static String formatPhoneNumberForWhatsAppOTP({required String countryCode,required String phoneNumber}) {
    // Remove all non-digit characters from both inputs
    final cleanedCountryCode = countryCode.replaceAll(RegExp(r'[^0-9]'), '');
    final cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    // Validate inputs
    if (cleanedCountryCode.isEmpty) {
      throw FormatException('Country code is required');
    }

    if (cleanedPhoneNumber.isEmpty) {
      throw FormatException('Phone number is required');
    }

    // Check if phone number starts with 0 (common in some countries)
    String finalPhoneNumber = cleanedPhoneNumber;
    if (finalPhoneNumber.startsWith('0')) {
      finalPhoneNumber = finalPhoneNumber.substring(1);
    }

    // Combine country code and phone number
    final formattedNumber = cleanedCountryCode + finalPhoneNumber;

    // Basic validation for minimum length
    // WhatsApp requires numbers in E.164 format (min length varies by country)
    if (formattedNumber.length < 8 || formattedNumber.length > 15) {
      throw FormatException('Invalid phone number length');
    }

    return formattedNumber;
  }

}