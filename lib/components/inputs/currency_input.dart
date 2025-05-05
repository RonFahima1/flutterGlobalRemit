import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class CurrencyInput extends StatelessWidget {
  final String? label;
  final String currency;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final VoidCallback? onCurrencyTap;
  final bool readOnly;

  const CurrencyInput({
    Key? key,
    this.label,
    required this.currency,
    required this.controller,
    this.focusNode,
    this.onChanged,
    this.errorText,
    this.onCurrencyTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color labelColor = isDark 
      ? GlobalRemitColors.gray1Dark 
      : GlobalRemitColors.gray1Light;
    final Color backgroundColor = isDark 
      ? GlobalRemitColors.tertiaryBackgroundDark 
      : GlobalRemitColors.tertiaryBackgroundLight;
    final Color textColor = isDark 
      ? Colors.white 
      : Colors.black;
    final Color errorColor = isDark 
      ? GlobalRemitColors.errorRedDark 
      : GlobalRemitColors.errorRedLight;
    final Color currencyButtonColor = isDark 
      ? GlobalRemitColors.gray5Dark 
      : GlobalRemitColors.gray5Light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: labelColor,
              fontFamily: 'SF Pro Text',
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: GlobalRemitSpacing.insetXS),
        ],
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusS),
            border: Border.all(
              color: errorText != null 
                ? errorColor 
                : backgroundColor,
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Currency selector
              GestureDetector(
                onTap: onCurrencyTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlobalRemitSpacing.insetM,
                    vertical: GlobalRemitSpacing.insetS,
                  ),
                  decoration: BoxDecoration(
                    color: currencyButtonColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(GlobalRemitSpacing.borderRadiusS),
                      bottomLeft: Radius.circular(GlobalRemitSpacing.borderRadiusS),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currency,
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'SF Pro Text',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (onCurrencyTap != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 14,
                          color: isDark 
                            ? GlobalRemitColors.gray1Dark 
                            : GlobalRemitColors.gray1Light,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              // Amount input
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  focusNode: focusNode,
                  onChanged: onChanged,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  textAlign: TextAlign.right,
                  readOnly: readOnly,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlobalRemitSpacing.insetM,
                    vertical: GlobalRemitSpacing.insetS,
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontFamily: 'SF Pro Text',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  placeholder: '0.00',
                  placeholderStyle: TextStyle(
                    color: isDark 
                      ? GlobalRemitColors.gray2Dark 
                      : GlobalRemitColors.gray2Light,
                    fontFamily: 'SF Pro Text',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: GlobalRemitSpacing.insetXS),
          Text(
            errorText!,
            style: TextStyle(
              color: errorColor,
              fontFamily: 'SF Pro Text',
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }
}