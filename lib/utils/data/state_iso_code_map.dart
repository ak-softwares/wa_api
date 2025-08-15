import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class StateData{
  // Method to get the state name from the ISO code
  static String getStateFromISOCode(String isoCode) {
    return indianStateISOCodeMap.entries
        .firstWhere((entry) => entry.value == isoCode, orElse: () => const MapEntry('', ''))
        .key;
  }

  // Method to get the ISO code from the state name
  static String getISOFromState(String state) {
    return indianStateISOCodeMap[state] ?? '';
  }

  static final List<String> indianStates = indianStateISOCodeMap.keys.toList();

  static final Map<String, String> indianStateISOCodeMap = {
    'Andhra Pradesh': 'AP',
    'Andaman and Nicobar Islands': 'AN',
    'Arunachal Pradesh': 'AR',
    'Assam': 'AS',
    'Bihar': 'BR',
    'Chandigarh': 'CH',
    'Chhattisgarh': 'CG',
    'Daman and Diu': 'DN',
    'Delhi': 'DL',
    'Goa': 'GA',
    'Gujarat': 'GJ',
    'Haryana': 'HR',
    'Himachal Pradesh': 'HP',
    'Jammu and Kashmir': 'JK',
    'Jharkhand': 'JH',
    'Karnataka': 'KA',
    'Kerala': 'KL',
    'Ladakh': 'LA',
    'Lakshadweep': 'LD',
    'Madhya Pradesh': 'MP',
    'Maharashtra': 'MH',
    'Manipur': 'MN',
    'Meghalaya': 'ML',
    'Mizoram': 'MZ',
    'Nagaland': 'NL',
    'Odisha': 'OR',
    'Puducherry': 'PY',
    'Punjab': 'PB',
    'Rajasthan': 'RJ',
    'Sikkim': 'SK',
    'Tamil Nadu': 'TN',
    'Telangana': 'TG',
    'Tripura': 'TR',
    'Uttar Pradesh': 'UP',
    'Uttarakhand': 'UK',
    'West Bengal': 'WB',
  };

  // Extra aliases
  static final Map<String, String> isoCodeAliases = {
    'CT': 'CG', // CT -> Chhattisgarh
    'TS': 'TG', // TS -> Telangana
    'OD': 'OR', // OD -> Odisha
  };

  static String? getStateNameFromCodeOrName(String input) {
    // Direct name match
    if (indianStateISOCodeMap.containsKey(input)) return input;

    // Normalize code using aliases
    String normalizedCode = isoCodeAliases[input] ?? input;

    // Match ISO code
    if (indianStateISOCodeMap.containsValue(normalizedCode)) {
      return indianStateISOCodeMap.entries
          .firstWhere((e) => e.value == normalizedCode)
          .key;
    }

    return null;
  }
}

class CountryData {
  final String country;
  final String iso;
  final String dialCode;
  final String? phoneNumber;

  CountryData({
    required this.country,
    required this.iso,
    required this.dialCode,
    this.phoneNumber,
  });

  static List<CountryData> _countries = [];

  static Future<void> loadFromAssets() async {
    final jsonStr = await rootBundle.loadString('assets/jsons/country_dial_codes.json');
    final List<dynamic> data = json.decode(jsonStr);

    _countries = data
        .map((e) => CountryData(
      country: e['name'],
      iso: e['code'],
      dialCode: e['dial_code'].replaceAll('+', ''), // cleanup
    )).toList();
  }

  static CountryData? fromFullNumber(String fullNumber) {
    if (_countries.isEmpty) {
      throw Exception('Country data not loaded. Call loadFromAssets() first.');
    }

    fullNumber = fullNumber.replaceAll('+', '');

    _countries.sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (var c in _countries) {
      if (fullNumber.startsWith(c.dialCode)) {
        return c.copyWith(
          phoneNumber: fullNumber.substring(c.dialCode.length),
        );
      }
    }
    return null;
  }

  CountryData copyWith({
    String? country,
    String? iso,
    String? dialCode,
    String? phoneNumber,
  }) {
    return CountryData(
      country: country ?? this.country,
      iso: iso ?? this.iso,
      dialCode: dialCode ?? this.dialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}


