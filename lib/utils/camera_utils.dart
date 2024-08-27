import 'dart:async';
import 'dart:developer';

import 'package:blive_delivery_exec/utils/toast_util.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

import '../gen/translation/locale_keys.g.dart';

/// A utility class for working with the camera in a Flutter application.
/// This class provides methods for initializing the camera, taking pictures
class CameraUtil {
  final CameraLensDirection cameraLensDirection;
  CameraController? cameraController;
  List<CameraDescription> _cameras = <CameraDescription>[];
  Completer<CameraController> cameraIntializeCompleter = Completer();

  CameraUtil(this.cameraLensDirection) {
    _initCamera(cameraLensDirection);
  }

  Future<void> _initCamera(CameraLensDirection cameraLensDirection) async {
    if (await _checkAndRequestCameraPermissions()) {
      await _initializeCamera(cameraLensDirection);
    } else {
      openAppSettings();
    }
  }

  Future<bool> _checkAndRequestCameraPermissions() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
  }

  Future<void> _initializeCamera(
      CameraLensDirection cameraLensDirection) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        log('No cameras available.');
        return;
      }
      final camera = _cameras.firstWhere(
        (element) => element.lensDirection == cameraLensDirection,
      );
      await _onNewCameraSelected(camera);
      cameraIntializeCompleter.complete(cameraController);
    } on CameraException catch (e) {
      log(e.code + (e.description ?? ''));
    }
  }

  Future<XFile?> takePicture() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      log('Error: select a camera first.');
      return null;
    }

    if (cameraController!.value.isTakingPicture) {
      return null;
    }

    try {
      final XFile file = await cameraController!.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      return cameraController!.setDescription(cameraDescription);
    } else {
      return _initializeCameraController(cameraDescription);
    }
  }

  Future<void> _initializeCameraController(
    CameraDescription cameraDescription,
  ) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );
    // If the controller is updated then update the UI.
    cameraController?.addListener(() {
      if (cameraController?.value.hasError ?? false) {
        log('Camera error ${cameraController?.value.errorDescription}');
      }
    });

    try {
      await cameraController?.initialize();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          ToastUtil.showToast(
            message: LocaleKeys.cameraUtil_have_denied_camera_access.tr(),
          );
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          ToastUtil.showToast(
            message:
                LocaleKeys.cameraUtil_please_go_settings_camera_access.tr(),
          );
          openAppSettings();
          break;
        case 'CameraAccessRestricted':
          // iOS only

          ToastUtil.showToast(
            message: LocaleKeys.cameraUtil_camera_Access_restricted.tr(),
          );
          break;

        default:
          _showCameraException(e);
          break;
      }

      openAppSettings();
      ToastUtil.showToast(
        message: LocaleKeys.cameraUtil_provide_camera_permission.tr(),
      );
    }
  }

  void _showCameraException(CameraException e) {
    log(e.code + (e.description ?? ""));
  }

  void disposeCameraController() {
    cameraController?.dispose();
  }
}
