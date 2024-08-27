import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {
  ///Returns [true] if app is running in debug mode
  static void showAPIErrorToast({
    String? message,
    Toast? toastLength,
  }) {
    Fluttertoast.showToast(
      msg: message ?? 'Something went wrong!',
      toastLength: toastLength,
    );
  }

  static void showToast({
    String? message,
    Toast? toastLength,
  }) {
    Fluttertoast.showToast(
      msg: message ?? 'Something went wrong!',
      toastLength: toastLength,
    );
  }
}
