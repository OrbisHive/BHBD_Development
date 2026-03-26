import 'package:flutter/material.dart';

import '../resources/resources.dart';

class NotificationPermissionPopup extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDontAllow;

  const NotificationPermissionPopup({
    super.key,
    required this.onAllow,
    required this.onDontAllow,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '"QuitVaping" Would Like to Send You Notifications',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Notifications may include alerts, sounds, and icon badges. '
                  'These can be configured in Settings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),
            const Divider(height: 1, color: Colors.black12),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onDontAllow,
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            "Don't Allow",
                            style: TextStyle(
                              fontSize: 15,
                              color: R.colors.buttonColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 1, color: Colors.black12),
                  Expanded(
                    child: InkWell(
                      onTap: onAllow,
                      child:  Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            "Allow",
                            style: TextStyle(
                              fontSize: 15,
                              color: R.colors.buttonColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
