import 'package:flutter/material.dart';
import '../../models/beneficiary.dart';
import '../../providers/transfer_provider.dart';
import '../../providers/account_provider.dart';
import '../../widgets/custom_button.dart';
import '../../theme/colors.dart';
import 'package:provider/provider.dart';
import 'transfer_success_screen.dart';

class TransferConfirmationScreen extends StatefulWidget {
  final TransferDetails transferDetails;

  const TransferConfirmationScreen({
    Key? key,
    required this.transferDetails,
  }) : super(key: key);

  @override
  State<TransferConfirmationScreen> createState() => _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState extends State<TransferConfirmationScreen> {
  bool _isProcessing = false;
  String? _errorMessage;

  Future<void> _confirmTransfer() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final transferProvider = Provider.of<TransferProvider>(context, listen: false);
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      
      // Process the transfer
      final transferResult = await transferProvider.processTransfer(widget.transferDetails);
      
      // Refresh account details
      await accountProvider.fetchAccountDetails();
      
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        // Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TransferSuccessScreen(transferResult: transferResult),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Widget _buildTransferDetails() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  '\$${widget.transferDetails.amount.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Recipient
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'To',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.transferDetails.beneficiary.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      if (widget.transferDetails.beneficiary.accountType == BeneficiaryAccountType.bank)
                        Text(
                          'Account: ${widget.transferDetails.beneficiary.accountNumber}',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        )
                      else
                        Text(
                          'Email: ${widget.transferDetails.beneficiary.email}',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.right,
                        ),
                      if (widget.transferDetails.beneficiary.accountType == BeneficiaryAccountType.bank)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            'Bank: ${widget.transferDetails.beneficiary.bankName}',
                            style: theme.textTheme.bodySmall,
                            textAlign: TextAlign.right,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Transfer Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transfer Type',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                _buildTransferTypeBadge(widget.transferDetails.type),
              ],
            ),
            const Divider(height: 24),
            
            // Description
            if (widget.transferDetails.description.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.transferDetails.description,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
            ],
            
            // Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  _formatDate(widget.transferDetails.date),
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
            
            // Fees (if applicable)
            if (widget.transferDetails.type == TransferType.express) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Fee',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    '\$${_calculateFee(widget.transferDetails).toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${(widget.transferDetails.amount + _calculateFee(widget.transferDetails)).toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
            
            // Expected arrival
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GlobalRemitColors.primaryBlueLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: GlobalRemitColors.primaryBlueLight,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getEstimatedArrivalText(widget.transferDetails.type),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: GlobalRemitColors.primaryBlueLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferTypeBadge(TransferType type) {
    Color badgeColor;
    String label;
    
    switch (type) {
      case TransferType.standard:
        badgeColor = GlobalRemitColors.primaryBlueLight;
        label = 'Standard';
        break;
      case TransferType.express:
        badgeColor = GlobalRemitColors.warningOrangeLight;
        label = 'Express';
        break;
      case TransferType.scheduled:
        badgeColor = Colors.teal;
        label = 'Scheduled';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badgeColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: badgeColor,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}/${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  double _calculateFee(TransferDetails transferDetails) {
    if (transferDetails.type == TransferType.express) {
      // Express transfer fee: 1% with minimum $1.00
      final calculatedFee = transferDetails.amount * 0.01;
      return calculatedFee < 1.0 ? 1.0 : calculatedFee;
    }
    return 0.0; // No fee for standard transfers
  }

  String _getEstimatedArrivalText(TransferType type) {
    switch (type) {
      case TransferType.standard:
        return 'Estimated arrival: 1-2 business days';
      case TransferType.express:
        return 'Estimated arrival: Within 30 minutes';
      case TransferType.scheduled:
        return 'Will be processed on the scheduled date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Transfer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Icon(
                Icons.account_balance,
                size: 64,
                color: GlobalRemitColors.primaryBlueLight,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Review Your Transfer',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Please review your transfer details before confirming',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            _buildTransferDetails(),
            
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomButton(
                    text: 'Confirm Transfer',
                    isLoading: _isProcessing,
                    onPressed: _confirmTransfer,
                    color: GlobalRemitColors.primaryBlueLight,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _isProcessing
                        ? null
                        : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: GlobalRemitColors.primaryBlueLight,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}