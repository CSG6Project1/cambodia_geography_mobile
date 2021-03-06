import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._internal();

  static Future<File?> pickImage({CropAspectRatio? aspectRatio}) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      return cropAnImage(file, aspectRatio);
    } else {
      print('No image selected.');
    }
  }

  static Future<File?> cropAnImage(File imageFile, CropAspectRatio? aspectRatio) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatio: aspectRatio,
      androidUiSettings: AndroidUiSettings(toolbarTitle: 'Cropper'),
      iosUiSettings: IOSUiSettings(),
    );
    imageFile.delete();
    return croppedFile;
  }
}
