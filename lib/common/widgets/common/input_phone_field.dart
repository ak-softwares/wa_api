import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController countryCodeController;
  final String label;
  final String initialCountryCode;
  final String languageCode;
  final double borderRadius;
  final double borderWidth;
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  const PhoneNumberField({
    super.key,
    required this.phoneController,
    required this.countryCodeController,
    this.label = 'Phone Number',
    this.initialCountryCode = 'US',
    this.languageCode = 'en',
    this.borderRadius = AppSizes.inputFieldRadius,
    this.borderWidth = AppSizes.inputFieldBorderWidth,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          borderSide: BorderSide(
            color: AppColors.error,
            width: borderWidth,
          ),
        ),
      ),
      languageCode: languageCode,
      initialCountryCode: initialCountryCode,
      disableLengthCheck: true,
      validator: validator,
      controller: phoneController,
      onChanged: (phone) {
        phoneController.text = phone.number; // without country code
        countryCodeController.text = phone.countryCode; // or phone.countryCodeString
      },
      onCountryChanged: (country) {
        countryCodeController.text = country.dialCode; // without +
      },
    );
  }
}
