import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../core/constants/app_constants.dart';
import 'animated_button.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // ✅ Allow null

  const GradientButton({
    super.key,
    required this.text,
    this.onTap, // ✅ Not required anymore
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.6 : 1.0, // Slight fade when disabled
      child: AnimatedButton(
        onTap: onTap ?? () {}, // Prevent null crash
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.accentStart,
                AppColors.accentEnd,
              ],
            ),
            borderRadius:
            BorderRadius.circular(AppConstants.buttonRadius),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 20,
                offset: Offset(0, 10),
              )
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}