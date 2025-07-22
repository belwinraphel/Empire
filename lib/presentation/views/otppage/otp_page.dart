import 'package:empire/presentation/views/password/password.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatelessWidget {
  final String phoneNumber;
  final void Function(String) onOtpSubmit;
  final VoidCallback onResend;
  final VoidCallback onCancel;

  const OtpPage({
    super.key,
    required this.phoneNumber,
    required this.onOtpSubmit,
    required this.onResend,
    required this.onCancel,
  });

  String getMaskedNumber(String phone) {
    if (phone.length < 4) return phone;
    return phone.replaceRange(3, phone.length - 2, '*' * (phone.length - 5));
  }

  @override
  Widget build(BuildContext context) {
    final maskedNumber = getMaskedNumber(phoneNumber);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxwidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
            final issmallScreen = constraints.maxWidth < 600;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: maxHeight * 0.30),
                  const Text(
                    "OTP",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Enter 4-digits code we sent you\non your phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    maskedNumber,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 24),

                  // OTP input
                  Padding(
                    padding: const EdgeInsets.only(left: 80, right: 80),
                    child: PinCodeTextField(
                      length: 4,
                      appContext: context,
                      onChanged: (_) {},
                      onCompleted: onOtpSubmit,
                      obscureText: true,
                      animationType: AnimationType.scale,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.circle,
                        activeFillColor: Colors.grey.shade300,
                        inactiveFillColor: Colors.grey.shade200,
                        selectedFillColor: Colors.white,
                        activeColor: Colors.transparent,
                        inactiveColor: Colors.transparent,
                        selectedColor: Colors.grey,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        borderWidth: 0,
                        fieldOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 6),
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      keyboardType: TextInputType.number,
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: onResend,
                    child: const Text(
                      "Send Again",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.09),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Password();
                        },
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: onCancel,
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
