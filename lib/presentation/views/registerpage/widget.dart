import 'dart:io';

import 'package:empire/presentation/bloc/auth/profile_image.dart';
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
                  color:
                      const Color.fromARGB(255, 229, 234, 236),
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

class ProfileImage extends StatelessWidget {
  const ProfileImage({
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
