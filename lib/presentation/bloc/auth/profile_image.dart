import 'package:empire/domain/usecase/pick_image_camera.dart';
import 'package:empire/domain/usecase/pick_image_gallery.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ImagePickerEvent {}

class ChooseImagFromCameraeEvent extends ImagePickerEvent {}

class ChooseImagFromGalleryEvent extends ImagePickerEvent {}

abstract class ImagePickerState {}

class ImageInitial extends ImagePickerState {}

class PickingImage extends ImagePickerState {}

class ImagePickedSucess extends ImagePickerState {
  final String image;
  ImagePickedSucess(this.image);
}

class ImagePickedError extends ImagePickerState {
  final String errot;
  ImagePickedError(this.errot);
}

class ImageAuth extends Bloc<ImagePickerEvent, ImagePickerState> {
  final PickImageFromCamera pickImageFromCamera;
  final PickImageFromGallery pickImageFromGallery;

  ImageAuth(this.pickImageFromCamera, this.pickImageFromGallery)
      : super(ImageInitial()) {
    on<ChooseImagFromCameraeEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromCamera();
      if (result != null) {
        emit(ImagePickedSucess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
    on<ChooseImagFromGalleryEvent>((event, emit) async {
      emit(PickingImage());
      final result = await pickImageFromGallery();
      if (result != null) {
        emit(ImagePickedSucess(result));
      } else {
        emit(ImagePickedError('Node Image Selcted'));
      }
    });
  }
}
