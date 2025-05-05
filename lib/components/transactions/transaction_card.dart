import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../cards/ios_card.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

enum TransactionStatus {
  completed,
  pending,
  failed,
}

class TransactionCard extends StatelessWidget {
  final String recipient;
  final String amount;
  final String currency;
  final String date;
  final String? note;
  final TransactionStatus status;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.recipient,
    required this.amount,
    required this.currency,
    required this.date,
    this.note,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Color statusColor;
    String statusText;
    
    switch (status) {
      case TransactionStatus.completed:
        statusColor = isDark 
          ? GlobalRemitColors.secondaryGreenDark 
          : GlobalRemitColors.secondaryGreenLight;
        statusText = 'Completed';
        break;
      case TransactionStatus.pending:
        statusColor = isDark 
          ? GlobalRemitColors.warningOrangeDark 
          : GlobalRemitColors.warningOrangeLight;
        statusText = 'Processing';
        break;
      case TransactionStatus.failed:
        statusColor = isDark 
          ? GlobalRemitColors.errorRedDark 
          : GlobalRemitColors.errorRedLight;
        statusText = 'Failed';
        break;
    }
    
    return IOSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GlobalRemitSpacing.insetM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        color: isDark 
                          ? GlobalRemitColors.gray2Dark 
                          : GlobalRemitColors.gray2Light,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$currency $amount',
                    style: TextStyle(
                      fontFamily: 'SF Pro Text',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GlobalRemitSpacing.insetS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusS),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: GlobalRemitSpacing.insetM),
            Container(
              padding: const EdgeInsets.all(GlobalRemitSpacing.insetS),
              decoration: BoxDecoration(
                color: isDark 
                  ? GlobalRemitColors.tertiaryBackgroundDark 
                  : GlobalRemitColors.tertiaryBackgroundLight,
                borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusS),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    size: 16,
                    color: isDark 
                      ? GlobalRemitColors.gray1Dark 
                      : GlobalRemitColors.gray1Light,
                  ),
                  const SizedBox(width: GlobalRemitSpacing.insetS),
                  Expanded(
                    child: Text(
                      note!,
                      style: TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 14,
                        color: isDark 
                          ? GlobalRemitColors.gray1Dark 
                          : GlobalRemitColors.gray1Light,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}