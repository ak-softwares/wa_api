import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/sizes.dart';
import 'snack_bar_massages.dart';

class DialogHelper {

  static void showDialog({
    required BuildContext context,
    required String title,
    String? message,
    String? toastMessage,
    String? actionButtonText,
    bool? isShowLoading = true,
    required Future<void> Function() onSubmit,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              if (message != null)
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 20),
              Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
              InkWell(
                onTap: () async {
                  Get.back();
                  // Show loading spinner
                  if (isShowLoading ?? true) {
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 2),
                      ),
                      barrierDismissible: false,
                      barrierColor: Colors.black.withOpacity(0.2),
                    );
                  }
                  await onSubmit();
                  if (isShowLoading ?? true) {
                    Get.back(); // Close the loading spinner
                  }
                  AppMassages.showToastMessage(message: toastMessage ?? 'Success');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    actionButtonText ?? "Done",
                    style: const TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.outline, thickness: 1),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showPhoneNumberSelectorDialog({
    required BuildContext context,
    required String title,
    required List<String> phoneNumbers,
    required void Function(String selectedNumber) onNumberSelected,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ...phoneNumbers.map((number) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back(); // Close dialog
                        onNumberSelected(number); // Callback
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        child: Text(
                          number,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Divider(
                      color: Theme.of(context).colorScheme.outline,
                      thickness: 0.2,
                    ),
                  ],
                );
              }),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}