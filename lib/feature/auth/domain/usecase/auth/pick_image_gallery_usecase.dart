


 

import 'package:empire/feature/auth/domain/repositories/image_profile.dart';

class PickImageFromGallery {
  final ProfileImage profileImage;

  PickImageFromGallery(this.profileImage);
  Future call() async {
    return await profileImage.pickImageFromGallery();
  }
}
