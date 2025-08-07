import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../models/contact_model.dart';
import 'package:permission_handler/permission_handler.dart';

class NewChatController extends GetxController {
  static NewChatController get instance => Get.find();

  RxBool isLoading = false.obs;
  RxList<ContactModel> contacts = <ContactModel>[].obs;
  RxList<ContactModel> filteredContacts = <ContactModel>[].obs;

  @override
  void onInit() {
    getContacts();
    super.onInit();
  }

  void getContacts() async {
    // Ask permission using permission_handler
    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      // Show dialog with button to open app settings
      DialogHelper.showDialog(
        context: Get.context!,
        title: 'Permission Required',
        message: 'Please enable contact permission from settings to continue.',
        actionButtonText: 'Open Settings',
        onSubmit: () async {
          openAppSettings(); // This opens the device's app settings
          Get.back();
        }
      );
      return;
    }


    try {
      isLoading(true);
      final contactList = await FlutterContacts.getContacts(withProperties: true);
      contacts.value = contactList
          .where((c) => c.phones.isNotEmpty)
          .map((c) => ContactModel.fromFlutterContact(c))
          .toList();
    } catch(e) {
      AppMassages.showToastMessage(message: e.toString());
    }finally{
      isLoading(false);
    }
  }

  Future<void> refreshContacts() async {
    try {
      isLoading(true);
      contacts.clear();
      getContacts();
      contacts.refresh();
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshSearch({required String query}) async {
    try {
      isLoading(true);
      filteredContacts.clear();
      applySearch(query: query);
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  void applySearch({required String query}) {
    if (query.isEmpty) {
      filteredContacts.assignAll(contacts);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredContacts.assignAll(
          contacts.where((c) {
            final name = (c.name ?? '').toLowerCase();

            // Join all phone numbers into one string
            final allNumbers = (c.phoneNumbers ?? [])
                .join(' ') // join with space
                .replaceAll(' ', '') // remove spaces
                .toLowerCase();

            return name.contains(lowerQuery) || allNumbers.contains(lowerQuery);
          })
      );
    }
  }

}
