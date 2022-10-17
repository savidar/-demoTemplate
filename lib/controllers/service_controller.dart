import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_controller.dart';

export 'package:image_picker/image_picker.dart';

class ServiceController {
  final picker = ImagePicker();

  Future<File?> pickImage(ImageSource source, BuildContext context) async {
    XFile? pickedFile;
    bool permission = false;
    if (source == ImageSource.camera) {
      permission = await Get.find<PermissionController>().getPermission(Permission.camera, context);
    } else {
      permission = await Get.find<PermissionController>().getPermission(Platform.isAndroid ? Permission.storage : Permission.photos, context);
    }
    if (permission) {
      pickedFile = await picker.pickImage(source: source, imageQuality: 25);
    } else {
      Fluttertoast.showToast(msg: "User Denied Permission");
    }

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<List<XFile>> getMultiImage() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 25);
    return pickedFile;
  }
}
