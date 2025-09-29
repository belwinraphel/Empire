import 'package:image_picker/image_picker.dart';

class ImageSources  {
    final ImagePicker picker = ImagePicker();
    Future<String?> pickFromCamera() async {
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.camera);
    if (pickedImage == null) return null;
    return pickedImage.path;
  }

  Future<String?> pickFromGallery() async {
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return null;
    return pickedImage.path;
  }
}