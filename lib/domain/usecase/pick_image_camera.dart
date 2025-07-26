
import 'package:empire/domain/repositories/image_profile.dart';

class PickImageFromCamera {
  final ProfileImage profileImage;

  PickImageFromCamera(this.profileImage);
  Future call() async {
    return await profileImage.pickImageFromcamera();
  }
}
