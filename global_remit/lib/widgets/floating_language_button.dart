import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';
import 'language_selector.dart';

class FloatingLanguageButton extends StatelessWidget {
  final double size;
  final EdgeInsets margin;

  const FloatingLanguageButton({
    Key? key,
    this.size = 56.0,
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;
    
    return Container(
      margin: margin,
      child: FloatingActionButton(
        heroTag: 'languageButton',
        onPressed: () {
          // Show language selector dialog
          const LanguageSelector(isDialogMode: true)._showLanguageDialog(context);
        },
        backgroundColor: AppColors.primary,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.language,
              color: Colors.white,
              size: 28,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Center(
                  child: Text(
                    currentLanguage.code.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}