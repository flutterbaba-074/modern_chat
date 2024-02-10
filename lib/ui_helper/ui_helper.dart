import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shimmer/shimmer.dart';

class UiHelper {
  static showLoader() {
    EasyLoading.show(
      status: "Loading...",
    );
  }

  static showToast(String toastTitle) {
    EasyLoading.showToast(
      toastTitle,
      toastPosition: EasyLoadingToastPosition.bottom,
    );
  }


  static void customImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      // anchorPoint: const Offset(0, 10),
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 400,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) {
                return Shimmer(
                    gradient: LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.grey.shade100,
                        Colors.grey.shade900
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ));
              },
              imageBuilder: (context, imageProvider) {
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      )),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
