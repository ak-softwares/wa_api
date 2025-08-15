import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../utils/constants/colors.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';

class OtpCountdownWidget extends StatelessWidget {
  final int initialSeconds;
  final VoidCallback onResend;

  const OtpCountdownWidget({
    super.key,
    required this.initialSeconds,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final oTPController = Get.put(OTPController());

    return Obx(() {
      if (oTPController.countdownTimer.value == 0) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't receive OTP?"),
            TextButton(
              onPressed: () async {
                oTPController.countdownTimer.value = initialSeconds;
                onResend();
              },
              child: Text(
                "Resend OTP",
                style: TextStyle(color: AppColors.linkColorDark),
              ),
            ),
          ],
        );
      } else {
        return Countdown(
          key: ValueKey(oTPController.countdownTimer
              .value), // ensures widget restarts
          seconds: oTPController.countdownTimer.value,
          interval: const Duration(seconds: 1),
          build: (context, currentRemainingTime) {
            return Text(
              "Didn't receive OTP? Resend in ${currentRemainingTime.toStringAsFixed(0)} Sec",
              textAlign: TextAlign.center,
            );
          },
          onFinished: () {
            oTPController.countdownTimer.value = 0; // ✅ safe after build
          },
        );
      }
    });
  }
}
