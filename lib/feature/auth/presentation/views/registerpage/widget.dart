import 'dart:io';

import 'package:empire/core/utilis/commonvalidator.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/profile_image.dart';
import 'package:empire/feature/auth/presentation/bloc/auth/registerpage.dart';
import 'package:empire/feature/auth/presentation/views/loginpage/widget.dart';
import 'package:empire/feature/auth/presentation/views/otppage/otp_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<dynamic> showImagePicker(BuildContext context) async {
    XFile? selectedImage;
    dynamic selectedImages;
    final ImagePicker picker = ImagePicker();

    await showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (BuildContext bc) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                selectedImage =
                    await picker.pickImage(source: ImageSource.camera);

                if (selectedImage != null && kIsWeb) {
                  selectedImages = selectedImage!.path;
                }
                selectedImages = selectedImage!.path;

                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image_search),
              title: const Text('Photo Library'),
              onTap: () async {
                selectedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (selectedImage != null && kIsWeb) {
                  selectedImages = selectedImage!.path;
                } else {
                  selectedImages = selectedImage!.path;
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    return selectedImages;
  }
}

class ProfileIamge extends StatelessWidget {
  const ProfileIamge({
    super.key,
    required this.imageFile,
  });

  final dynamic imageFile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 229, 234, 236),
            radius: 70,
            backgroundImage: imageFile == null
                ? null
                : kIsWeb
                    ? NetworkImage(imageFile)
                    : FileImage(
                        File(imageFile),
                      ),
            child: imageFile == null
                ? const Icon(
                    Icons.person_2_rounded,
                    size: 100,
                    color: Colors.black,
                  )
                : null),
        Positioned(
            left: 90,
            bottom: -0,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 229, 234, 236),
                  shape: BoxShape.circle,
                  border: Border.all(width: 2)),
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            )),
      ],
    );
  }
}

class ProfileImages extends StatelessWidget {
  const ProfileImages({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageAuth, ImagePickerState>(
      builder: (context, state) {
        String? imageFilePath;

        if (state is ImagePickedSucess) {
          imageFilePath = state.image;
        }

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (_) => SafeArea(
                child: Wrap(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Take a picture'),
                      onTap: () {
                        context
                            .read<ImageAuth>()
                            .add(ChooseImagFromCameraeEvent());
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Pick from gallery'),
                      onTap: () {
                        context
                            .read<ImageAuth>()
                            .add(ChooseImagFromGalleryEvent());
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 229, 234, 236),
                radius: 70,
                backgroundImage: imageFilePath == null
                    ? null
                    : kIsWeb
                        ? NetworkImage(imageFilePath)
                        : FileImage(File(imageFilePath)) as ImageProvider,
                child: imageFilePath == null
                    ? const Icon(
                        Icons.person_2_rounded,
                        size: 100,
                        color: Colors.black,
                      )
                    : null,
              ),
              Positioned(
                left: 90,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 229, 234, 236),
                      shape: BoxShape.circle,
                      border: Border.all(width: 2)),
                  child: const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserTittle extends StatelessWidget {
  final String? title;
  const UserTittle({
    super.key,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(title ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class UserdetailsSection extends StatelessWidget {
  const UserdetailsSection({
    super.key,
    required this.maxHeight,
    required this.usernameController,
    required this.issmallScreen,
    required this.maxwidth,
    required this.emailController,
    required this.mobileController,
    required this.formkey,
    required this.imageFile,
  });

  final double maxHeight;
  final TextEditingController usernameController;
  final bool issmallScreen;
  final double maxwidth;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final GlobalKey<FormState> formkey;
  final dynamic imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: maxHeight * 0.05,
        ),
        const UserTittle(title: ' Name'),
        LoginField(
          controller: usernameController,
          label: 'User name',
          prefixican: Icons.person,
          issmallScreen: issmallScreen,
          maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
          validator: (value) {
            return Validators.validateUsername(value ?? "");
          },
        ),
        SizedBox(height: maxHeight * 0.020),
        const UserTittle(title: 'Email '),
        LoginField(
          controller: emailController,
          label: 'Email Address',
          prefixican: Icons.email,
          issmallScreen: issmallScreen,
          maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
          validator: (value) {
            return Validators.validateEmail(value ?? "");
          },
        ),
        SizedBox(height: maxHeight * 0.020),
        const UserTittle(title: 'Mobile'),
        LoginField(
          controller: mobileController,
          label: 'Mobile',
          prefixican: Icons.phone_android_rounded,
          issmallScreen: issmallScreen,
          maxwidth: issmallScreen ? maxwidth * 0.95 : 400,
          validator: (value) {
            return Validators.validatePhone(value ?? "");
          },
        ),
      ],
    );
  }
}

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.usernameController,
    required this.emailController,
    required this.mobileController,
    required this.issmallScreen,
    required this.formkey,
    required this.imageFile,
    required this.maxwidth,
  });

  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final bool issmallScreen;
  final GlobalKey<FormState> formkey;
  final dynamic imageFile;
  final double maxwidth;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
      if (state is UserExist) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.messange)));
      } else if (state is NonExist) {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return OtpPage(
                name: usernameController.text,
                email: emailController.text,
                phoneNumber: mobileController.text,
                onOtpSubmit: (value) {},
                onResend: () {
                  Navigator.pop(context);
                },
                onCancel: () {
                  Navigator.pop(context);
                });
          },
        ));
      }
    }, builder: (context, state) {
      final isloading = state is ChekingLoading;
      return isloading
          ? const CircularProgressIndicator()
          : Authbutton(
              name: 'Continue',
              issmallScreen: issmallScreen,
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  context.read<RegisterBloc>().add(
                        ChekingUserExistenceEvent(
                            email: emailController.text,
                            phone: int.parse(mobileController.text),
                            name: usernameController.text,
                            image: imageFile),
                      );
                }
              },
              maxwidth: maxwidth,
              formKey: formkey);
    });
  }
}
