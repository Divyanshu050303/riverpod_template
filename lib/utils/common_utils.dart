import 'package:blive_delivery_exec/constants/constants.dart';
import 'package:blive_delivery_exec/router/app_routes.dart';
import 'package:blive_delivery_exec/style/constants/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'toast_util.dart';

class CommonUtil {
  static Future<XFile?> pickFile({
    FileType? fileType,
    List<String>? allowedExtensions,
  }) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType ?? FileType.any,
      allowedExtensions:
          (fileType == FileType.custom) ? allowedExtensions : null,
    );

    final file = result?.files.firstOrNull;
    final filePath = file?.path;
    if (filePath != null) {
      final size = file?.size;
      if ((size ?? 0) < maxFileSize) {
        return XFile(filePath);
      } else {
        ToastUtil.showToast(
            // TODO: remove this and keep the original
            // message: LocaleKeys.common_file_size_too_large.tr(),
            );
        return null;
      }
    }
    return null;
  }

  static Future<String> pickDate({
    DateTime? initialDate,
    DateTime? lastDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: AppColors.primary01,
            colorScheme: ColorScheme.light(
              primary: AppColors.primary01,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: navigatorKey.currentContext!,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: lastDate ?? DateTime.now(),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      return formattedDate;
    }
    return '';
  }
}
