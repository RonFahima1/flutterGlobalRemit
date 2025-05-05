import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/language.dart';
import '../providers/language_provider.dart';
import '../theme/app_colors.dart';

class LanguageSelector extends StatelessWidget {
  final bool isDialogMode;
  
  const LanguageSelector({
    Key? key,
    this.isDialogMode = false,
  }) : super(key: key);
  
  void _showLanguageDialog(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLanguage = languageProvider.currentLanguage;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.language, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Select Language'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languageProvider.availableLanguages.length,
              itemBuilder: (context, index) {
                final language = languageProvider.availableLanguages[index];
                final isSelected = language == currentLanguage;
                
                return ListTile(
                  leading: Image.asset(
                    language.flagAsset,
                    width: 32,
                    height: 32,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback if flag image is not available
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            language.code.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  title: Text(language.name),
                  subtitle: Text(language.nativeName),
                  trailing: isSelected 
                    ? Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                  onTap: () {
                    languageProvider.setLanguage(language.code);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return isDialogMode
        ? _buildGlobeIcon(context)
        : _buildGlobeWithCurrentLanguage(context);
  }
  
  Widget _buildGlobeIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onPressed: () => _showLanguageDialog(context),
    );
  }
  
  Widget _buildGlobeWithCurrentLanguage(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLanguage = languageProvider.currentLanguage;
    
    return InkWell(
      onTap: () => _showLanguageDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const Icon(Icons.language, color: AppColors.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentLanguage.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              currentLanguage.flagAsset,
              width: 24,
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      currentLanguage.code.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}