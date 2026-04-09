import 'package:flutter/material.dart';
import 'package:welcome_project_fe/util/ColorConstants.dart';

// Helper to build section cards with optional edit buttons
Widget buildSectionCard({
  required String title,
  required Widget child,
  required Widget subtitle,
  bool isEditing = false,
  VoidCallback? onButtonPressed,
  String? buttonText,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Check if we're on mobile or desktop based on available width
      bool isMobile = constraints.maxWidth < 600;

      Widget actionButton = onButtonPressed != null
          ? SizedBox(
              width: isMobile
                  ? double.infinity
                  : null, // Full width on mobile, auto on desktop
              child: TextButton(
                onPressed: onButtonPressed,
                style: ButtonStyle(
                  // Background color
                  backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return ColorConstants.ubtsBlue;
                    }
                    return ColorConstants.ubtsYellow;
                  }),
                  // Text color
                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.hovered)) {
                      return ColorConstants.textWhite;
                    }
                    return ColorConstants.textBlack;
                  }),
                  padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12, horizontal: 16)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                child: Text(buttonText ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          : const SizedBox.shrink(); // Empty widget if no button

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        color: ColorConstants.whiteBackground,
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        subtitle,
                      ],
                    ),
                  ),
                  if (!isMobile) actionButton,
                ],
              ),
              const SizedBox(height: 24),
              child,

              if (isMobile && onButtonPressed != null) ...[
                const SizedBox(height: 24),
                actionButton,
              ],
            ],
          ),
        ),
      );
    },
  );
}