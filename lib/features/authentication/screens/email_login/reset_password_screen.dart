import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/reset_password_controller/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResetPasswordController());

    return Scaffold(
      appBar: const AppAppBar(title: "Reset Password"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.defaultSpace),
          child: Column(
            children: [
              const SizedBox(height: AppSizes.spaceBtwSection),
              Text(
                "Enter your new password for ${user.email}",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spaceBtwSection),

              // New Password
              Obx(() => TextField(
                controller: controller.passwordController,
                obscureText: controller.isObscure.value,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: Icon(Iconsax.direct_right),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isObscure.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  // Default border (used when not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                  ),

                  // Border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                  ),
                ),
              )),

              const SizedBox(height: AppSizes.inputFieldSpace),

              // Confirm Password
              Obx(() => TextField(
                controller: controller.confirmPasswordController,
                obscureText: controller.isConfirmObscure.value,
                decoration: InputDecoration(
                  labelText: "Re-enter Password",
                  prefixIcon: Icon(Iconsax.direct_right),
                  suffixIcon: IconButton(
                    icon: Icon(controller.isConfirmObscure.value
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed:
                    controller.toggleConfirmPasswordVisibility,
                  ),
                  // Default border (used when not focused)
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                  ),

                  // Border when focused
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                  ),
                ),
              )),

              const SizedBox(height: AppSizes.spaceBtwSection),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.submit(user: user),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
