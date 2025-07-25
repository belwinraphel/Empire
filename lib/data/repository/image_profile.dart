import 'package:empire/data/datasource/image_profile.dart';
import 'package:empire/domain/repositories/image_profile.dart';

class ProfileImageImpli implements ProfileImage {
  final ImageSources imageSource;
  ProfileImageImpli(this.imageSource);
  @override
  Future<String?> pickImageFromGallery() {
    return imageSource.pickFromGallery();
  }

  @override
  Future<String?> pickImageFromcamera() {
    return imageSource.pickFromCamera();
  }
}
