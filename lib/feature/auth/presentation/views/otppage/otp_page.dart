import 'package:empire/feature/auth/presentation/bloc/auth/otp.dart';
import 'package:empire/feature/auth/presentation/views/password/password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpPage extends StatelessWidget {
  final String email;
  final String phoneNumber;
  final String name;

  final void Function(String) onOtpSubmit;
  final VoidCallback onResend;
  final VoidCallback onCancel;

  OtpPage(
      {super.key,
      required this.name,
      required this.phoneNumber,
      required this.onOtpSubmit,
      required this.onResend,
      required this.onCancel,
      required this.email});
  TextEditingController otpController = TextEditingController();
  String getMaskedNumber(String phone) {
    if (phone.length < 4) return phone;
    return phone.replaceRange(3, phone.length - 2, '*' * (phone.length - 5));
  }

  @override
  Widget build(BuildContext context) {
    final maskedNumber = getMaskedNumber(phoneNumber);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxwidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          final issmallScreen = constraints.maxWidth < 600;
          return SingleChildScrollView(
            child: Container(
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
                  SizedBox(height: maxHeight * 0.06),
                  const Text(
                    "Enter 4-digits code we sent you\non your phone number",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: maxHeight * 0.02),
                  Text(
                    maskedNumber.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: maxHeight * 0.03),
                  PinCodeTextField(
                    length: 6,
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
                      fieldHeight: 40,
                      fieldWidth: 40,
                      borderWidth: 0,
                      fieldOuterPadding:
                          EdgeInsets.only(left: maxwidth * 0.04, right: 0.06),
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    keyboardType: TextInputType.number,
                    controller: otpController,
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  TextButton(
                    onPressed: onResend,
                    child: const Text(
                      "Send Again",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(height: maxHeight * 0.04),
                  BlocConsumer<OtpBloc, OtpVerifyState>(
                      listener: (context, state) {
                    if (state is VerifiedOtpVerifyState) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Password(
                            name: name,
                            phoneNumber: phoneNumber,
                            email: email,
                          );
                        },
                      ));
                    } else if (state is NotVerifiedOtpVerifyState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(state.errorMessage ??
                                'OTP Verification failed')),
                      );
                    }
                  }, builder: (context, state) {
                    final isloading = state is OtpLoading;
                    return isloading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              context.read<OtpBloc>().add(Verify0tpEvent(
                                  int.parse(otpController.text)));
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
                          );
                  }),
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
            ),
          );
        },
      ),
    );
  }
}
