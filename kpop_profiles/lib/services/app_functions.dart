import 'package:flutter/material.dart';
import 'package:kpop_profiles/services/assets_manager.dart';
import 'package:kpop_profiles/widgets/subtitle_text.dart';
import 'package:kpop_profiles/widgets/title_text.dart';

class AppFunctions {
  static Future<void> showErrorOrWarningDialog({
    required BuildContext context,
    required String subtitle,
    bool isError = true,
    required Function fct,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isError
                    ? "${AssetsManager.imagesPath}/warning.png"
                    : "${AssetsManager.imagesPath}/caution.png",
                height: 60,
                width: 60,
              ),
              const SizedBox(height: 16.0),
              SubtitleText(label: subtitle, fontWeight: FontWeight.w600),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isError,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const SubtitleText(
                        label: "Cancel",
                        color: Colors.green,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const SubtitleText(label: "OK", color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: TitleText(label: "Choose option")),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextButton.icon(
                  onPressed: () {
                    cameraFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("Camera"),
                ),
                TextButton.icon(
                  onPressed: () {
                    galleryFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.browse_gallery),
                  label: const Text("Gallery"),
                ),
                TextButton.icon(
                  onPressed: () {
                    removeFCT();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text("Remove"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
