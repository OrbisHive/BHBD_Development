import 'package:flutter/material.dart';
import '../resources/resources.dart';
import 'height_width_box.dart';
class CustomDialog extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;
  final String? acceptButtonTitle;
  final String? cancelButtonTitle;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final bool isActiveCancelButton;
  final bool isActiveAcceptButton;
  const CustomDialog({
    super.key,
    this.image,
    this.title,
    this.description,
    this.acceptButtonTitle,
    this.cancelButtonTitle,
    this.onAccept,
    this.onCancel,
    this.isActiveCancelButton = true,
    this.isActiveAcceptButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: R.colors.backGroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image (optional)
            if (image != null)
              Image.asset(
                image!,
                height: 150,
              ),
            if (image != null) heightBox(10),

            // Title (optional)
            if (title != null)
              Text(
                title!,
                style: R.textStyles.poppins(
                  color: R.colors.blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),

            if (description != null) heightBox(5),

            // Description (optional)
            if (description != null)
              Text(
                description!,
                style: R.textStyles.poppins(
                  color: R.colors.lightGreyColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),

            heightBox(20),

            // Accept Button
            if (isActiveAcceptButton && acceptButtonTitle != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: R.colors.splashBG,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: onAccept,
                  child: Text(
                    acceptButtonTitle!,
                    style: R.textStyles.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),

            if (isActiveCancelButton && cancelButtonTitle != null)
              Column(
                children: [
                  heightBox(10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: onCancel,
                      child: Text(
                        cancelButtonTitle!,
                        style: R.textStyles.poppins(
                          color: R.colors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
