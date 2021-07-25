import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._internal();

  static Future<File?> pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      return cropAnImage(file);
    } else {
      print('No image selected.');
    }
  }

  static Future<File?> cropAnImage(File imageFile) async {
    File? croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      aspectRatio: CropAspectRatio(ratioX: 16, ratioY: 9),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        lockAspectRatio: true,
      ),
      iosUiSettings: IOSUiSettings(
        rotateButtonsHidden: true,
        rotateClockwiseButtonHidden: true,
        aspectRatioPickerButtonHidden: true,
      ),
    );
    imageFile.delete();
    return croppedFile;
  }
}
