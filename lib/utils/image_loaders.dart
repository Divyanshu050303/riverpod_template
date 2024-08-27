import 'dart:io';

import 'package:blive_delivery_exec/responsive/app_screen_util.dart';
import 'package:blive_delivery_exec/style/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

///This is just an abstraction class of the [SvgPicture] library
///So that this library can be easily changed if needed
class ImageLoader {
  ImageLoader._();

  static Widget asset(
    String assetName, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return Image.asset(
      assetName,
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.contain,
    );
  }

  static Widget file(
    String imagePath, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return Image.file(
      File(imagePath),
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.contain,
    );
  }

  static Widget assetSvg(
    String assetName, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      colorFilter:
          color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      fit: fit ?? BoxFit.contain,
    );
  }

  static Widget cachedNetworkImage(
    String assetName, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
    Widget? errorWidget,
    Widget? placeholderWidget,
    bool? isCoverImage,
    double? errorlogoHeight,
  }) {
    return CachedNetworkImage(
      imageUrl: assetName,
      height: height,
      width: width,
      color: color,
      fit: fit,
      placeholder: (context, value) => placeholderWidget ?? const SizedBox(),
      errorWidget: (BuildContext? context, _, __) {
        if (errorWidget != null) {
          return errorWidget;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: AppColors.semantic01,
              size: errorlogoHeight ?? 40.heightMultiplier,
            ),
          ],
        );
      },
    );
  }

  static Widget networkSvg(
    String assetName, {
    double? height,
    double? width,
    Color? color,
  }) {
    return SvgPicture.network(
      assetName,
      height: height,
      width: width,
      color: color,
      fit: BoxFit.cover,
    );
  }

  static Widget network(
    String url, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
    bool? isCoverImage,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    return Image.network(
      url,
      height: height,
      width: width,
      color: color,
      fit: fit ?? BoxFit.contain,
    );
  }

  static Widget lottie(
    String path, {
    double? height,
    double? width,
    Color? color,
    BoxFit? fit,
  }) {
    return Lottie.asset(
      path,
      height: height,
      width: width,
      fit: fit,
    );
  }
}
