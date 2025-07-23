import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
