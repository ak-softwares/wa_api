import 'package:flutter_contacts/flutter_contacts.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../../../utils/constants/db_constants.dart';

class ContactModel {
  final String name;
  final List<String> phoneNumbers;
  final List<String>? emails;
  final Uint8List? photo;
  final bool? isStarred;

  ContactModel({
    required this.name,
    required this.phoneNumbers,
    this.emails,
    this.photo,
    this.isStarred,
  });

  factory ContactModel.fromFlutterContact(Contact contact) {
    List<String> cleanedPhones = contact.phones.map((p) {
      final raw = p.normalizedNumber ?? p.number;
      final cleaned = raw.replaceAll(RegExp(r'\D'), ''); // keep only digits
      return cleaned;
    }).toList();
    return ContactModel(
      name: contact.displayName,
      phoneNumbers: cleanedPhones,
      emails: contact.emails
          .map((e) => e.address)
          .toList(),
      photo: contact.photo,
      isStarred: contact.isStarred,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ContactFieldName.name: name,
      ContactFieldName.phoneNumbers: phoneNumbers,
      ContactFieldName.emails: emails,
      ContactFieldName.photo: photo != null ? base64Encode(photo!) : null,
      ContactFieldName.isStarred: isStarred,
    };
  }
}
