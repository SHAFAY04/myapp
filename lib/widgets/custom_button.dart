import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

enum ButtonVariant { primary, secondary, danger }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final ButtonVariant variant;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = onPressed == null || isLoading;

    Color bgColor;
    Color textColor;
    BorderSide? border;

    switch (variant) {
      case ButtonVariant.primary:
        bgColor = disabled ? AppConstants.primaryColor.withOpacity(0.5) : AppConstants.primaryColor;
        textColor = Colors.white;
        break;
      case ButtonVariant.secondary:
        bgColor = Colors.transparent;
        textColor = AppConstants.primaryColor;
        border = const BorderSide(color: AppConstants.primaryColor, width: 1.5);
        break;
      case ButtonVariant.danger:
        bgColor = disabled ? AppConstants.errorColor.withOpacity(0.5) : AppConstants.errorColor;
        textColor = Colors.white;
        break;
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          disabledBackgroundColor: bgColor,
          disabledForegroundColor: textColor.withOpacity(0.7),
          elevation: variant == ButtonVariant.primary ? 2 : 0,
          shadowColor: AppConstants.primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: border ?? BorderSide.none,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
