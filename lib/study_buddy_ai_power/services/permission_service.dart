import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check camera permission status
  Future<bool> isCameraPermissionGranted() async {
    if (kIsWeb) {
      // Web-specific permission check (use browser's APIs directly)
      return true;  // Assuming permission is granted for simplicity
    } else {
      final status = await Permission.camera.status;
      return status.isGranted;
    }
  }

  // Request camera permission
  Future<bool> requestCameraPermission() async {
    if (kIsWeb) {
      // Web-specific permission request (use browser's APIs directly)
      // Here, we should invoke the JS API for camera permission
      return true;  // Assuming permission is granted for simplicity
    } else {
      final status = await Permission.camera.request();
      return status.isGranted;
    }
  }

  // Check storage permission status
  // Future<bool> isStoragePermissionGranted() async {
  //   final status = await Permission.storage.status;
  //   return status.isGranted;
  // }

  // Request storage permission
  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Request photos permission (for iOS and Android 13+)
  Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  // Open app settings
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Check and request camera permission with user-friendly messages
  Future<Map<String, dynamic>> checkAndRequestCameraPermission() async {
    if (kIsWeb) {
      // Web-specific behavior
      return {'granted': true, 'message': 'Camera permission granted (Web)'};
    }

    final status = await Permission.camera.status;
    if (status.isGranted) {
      return {'granted': true, 'message': 'Camera permission granted'};
    }

    if (status.isDenied) {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        return {'granted': true, 'message': 'Camera permission granted'};
      } else {
        return {'granted': false, 'message': 'Camera permission denied'};
      }
    }

    if (status.isPermanentlyDenied) {
      return {
        'granted': false,
        'message': 'Camera permission permanently denied. Please enable it from settings.',
        'openSettings': true,
      };
    }

    return {'granted': false, 'message': 'Camera permission not available'};
  }

  // Check and request storage/photos permission
  Future<bool> isStoragePermissionGranted() async {
    if (kIsWeb) {
      // Web-specific storage access (using localStorage, etc.)
      return true;  // Assuming permission is granted for simplicity
    } else {
      Permission permissionToCheck;

      // Determine the correct permission based on the Android version
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          permissionToCheck = Permission.photos;  // Use photos permission for Android 13+
        } else {
          permissionToCheck = Permission.storage;  // Use storage permission for older versions
        }
      } else {
        permissionToCheck = Permission.photos;  // For iOS, always use photos permission
      }

      final status = await permissionToCheck.status;
      return status.isGranted;
    }
  }

  Future<Map<String, dynamic>> checkAndRequestStoragePermission() async {
    if (kIsWeb) {
      // Web-specific behavior (local storage or IndexedDB)
      return {'granted': true, 'message': 'Storage access granted (Web)'};
    }

    PermissionStatus status;
    Permission permissionToRequest;

    // Determine the correct permission based on the Android version
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        permissionToRequest = Permission.photos;  // Use photos permission for Android 13+
      } else {
        permissionToRequest = Permission.storage;  // Use storage permission for older versions
      }
    } else {
      permissionToRequest = Permission.photos;  // For iOS, always use photos permission
    }

    status = await permissionToRequest.status;

    if (status.isGranted) {
      return {'granted': true, 'message': 'Storage permission granted'};
    }

    if (status.isDenied) {
      final result = await permissionToRequest.request();
      if (result.isGranted) {
        return {'granted': true, 'message': 'Storage permission granted'};
      } else {
        return {'granted': false, 'message': 'Storage permission denied'};
      }
    }

    if (status.isPermanentlyDenied) {
      return {
        'granted': false,
        'message': 'Storage permission permanently denied. Please enable it from settings.',
        'openSettings': true,
      };
    }

    return {'granted': false, 'message': 'Storage permission not available'};
  }

}
