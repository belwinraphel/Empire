


 

import 'package:empire/feature/auth/domain/repositories/image_profile.dart';

class PickImageFromCamera {
  final ProfileImage profileImage;

  PickImageFromCamera(this.profileImage);
  Future call() async {
    return await profileImage.pickImageFromcamera();
  }
}
