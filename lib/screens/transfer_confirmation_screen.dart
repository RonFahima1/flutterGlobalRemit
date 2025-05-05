import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/beneficiary.dart';
import '../models/currency.dart';
import '../models/transfer.dart';
import '../models/transfer_method.dart';
import '../services/transfer_service.dart';
import '../utils/currency_utils.dart';
import '../utils/progress_tracker.dart';
import '../widgets/implementation_progress_badge.dart';

class TransferConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> transferDetails;

  const TransferConfirmationScreen({
    Key? key,
    required this.transferDetails,
  }) : super(key: key);

  @override
  State<TransferConfirmationScreen> createState() => _TransferConfirmationScreenState();
}

class _TransferConfirmationScreenState extends State<TransferConfirmationScreen> {
  bool _isLoading = false;
  bool _isTransferComplete = false;
  String? _errorMessage;
  Transfer? _confirmedTransfer;
  final TransferService _transferService = TransferService();
  
  // Screen implementation information
  final int _screenNumber = 19;
  final String _screenName = 'Transfer Confirmation Screen';
  bool _showProgress = false;

  // Authentication PIN fields
  final List<TextEditingController> _pinControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _pinFocusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  @override
  void initState() {
    super.initState();
    
    // Set up focus listeners for PIN fields
    for (int i = 0; i < 4; i++) {
      _pinControllers[i].addListener(() {
        if (_pinControllers[i].text.length == 1 && i < 3) {
          // Move focus to the next field when a digit is entered
          _pinFocusNodes[i + 1].requestFocus();
        }
      });
    }
  }
  
  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (int i = 0; i < 4; i++) {
      _pinControllers[i].dispose();
      _pinFocusNodes[i].dispose();
    }
    super.dispose();
  }
  
  void _toggleProgressDisplay() {
    setState(() {
      _showProgress = !_showProgress;
    });
  }
  
  void _handleConfirmTransfer() async {
    // Get the entered PIN
    final enteredPin = _pinControllers.map((controller) => controller.text).join();
    
    // Validate PIN
    if (enteredPin.length != 4) {
      setState(() {
        _errorMessage = 'Please enter a valid 4-digit PIN';
      });
      return;
    }
    
    // In a real app, you would validate the PIN against the stored/verified PIN
    // For demo purposes, we'll accept any 4-digit PIN
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final amount = double.parse(widget.transferDetails['amount'].toString().replaceAll(',', ''));
      final convertedAmount = double.parse(widget.transferDetails['convertedAmount'].toString());
      final fee = (widget.transferDetails['transferMethod'] as TransferMethod).fee;
      
      // Call the service to initiate the transfer
      final transfer = await _transferService.initiateTransfer(
        fromCurrency: (widget.transferDetails['sourceCurrency'] as Currency).code,
        toCurrency: (widget.transferDetails['targetCurrency'] as Currency).code,
        amount: amount,
        convertedAmount: convertedAmount,
        beneficiaryId: (widget.transferDetails['beneficiary'] as Beneficiary).id,
        transferMethodId: (widget.transferDetails['transferMethod'] as TransferMethod).id,
        fee: fee,
        note: widget.transferDetails['note'] as String?,
      );
      
      setState(() {
        _confirmedTransfer = transfer;
        _isTransferComplete = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to process transfer: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  void _handleBackToHome() {
    // Navigate back to home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
  
  void _handleSeeDetails() {
    // Navigate to transfer details screen
    if (_confirmedTransfer != null) {
      Navigator.of(context).pushNamed(
        '/transfer-details',
        arguments: {'transferId': _confirmedTransfer!.id},
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    // Extract transfer details
    final Currency sourceCurrency = widget.transferDetails['sourceCurrency'] as Currency;
    final Currency targetCurrency = widget.transferDetails['targetCurrency'] as Currency;
    final String amount = widget.transferDetails['amount'] as String;
    final String convertedAmount = widget.transferDetails['convertedAmount'] as String;
    final double? exchangeRate = widget.transferDetails['exchangeRate'] as double?;
    final Beneficiary beneficiary = widget.transferDetails['beneficiary'] as Beneficiary;
    final TransferMethod transferMethod = widget.transferDetails['transferMethod'] as TransferMethod;
    final String? note = widget.transferDetails['note'] as String?;
    
    // Get the phase name for this screen
    final phaseName = AppProgressTracker.getPhaseForScreen(_screenNumber) ?? 'Unknown';
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isTransferComplete ? 'Transfer Complete' : 'Confirm Transfer'),
            Text(
              'Screen ${_screenNumber}/41',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          // Progress button
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Show Implementation Progress',
            onPressed: _toggleProgressDisplay,
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Implementation progress tracking information
            if (_showProgress)
              _buildProgressTracker(phaseName),
              
            // Main content
            Expanded(
              child: _isTransferComplete 
                ? _buildTransferCompleteView()
                : _buildConfirmationView(
                    sourceCurrency,
                    targetCurrency,
                    amount,
                    convertedAmount,
                    exchangeRate,
                    beneficiary,
                    transferMethod,
                    note,
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildConfirmationView(
    Currency sourceCurrency,
    Currency targetCurrency,
    String amount,
    String convertedAmount,
    double? exchangeRate,
    Beneficiary beneficiary,
    TransferMethod transferMethod,
    String? note,
  ) {
    final numericAmount = double.tryParse(amount.replaceAll(',', '')) ?? 0.0;
    final totalAmount = numericAmount + transferMethod.fee;
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transfer summary card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Amounts
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'You Send',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${sourceCurrency.symbol}${formatCurrency(amount)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: Color(0xFF0066CC),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'They Receive',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${targetCurrency.symbol}${formatCurrency(convertedAmount)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0066CC),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // Exchange rate
                          if (exchangeRate != null)
                            _buildInfoRow(
                              'Exchange Rate',
                              '1 ${sourceCurrency.code} = ${exchangeRate.toStringAsFixed(4)} ${targetCurrency.code}',
                            ),
                          
                          // Fee
                          _buildInfoRow(
                            'Transfer Fee',
                            '${sourceCurrency.symbol}${transferMethod.fee.toStringAsFixed(2)}',
                          ),
                          
                          // Total
                          _buildInfoRow(
                            'Total to Pay',
                            '${sourceCurrency.symbol}${totalAmount.toStringAsFixed(2)}',
                            isBold: true,
                          ),
                          
                          // Delivery time
                          _buildInfoRow(
                            'Delivery Time',
                            transferMethod.estimatedTime,
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // Beneficiary details
                          _buildInfoRow(
                            'Recipient',
                            beneficiary.name,
                          ),
                          
                          if (beneficiary.bankName != null)
                            _buildInfoRow(
                              'Bank',
                              beneficiary.bankName!,
                            ),
                          
                          _buildInfoRow(
                            'Account',
                            _formatAccountNumber(beneficiary.accountNumber),
                          ),
                          
                          // Transfer method
                          _buildInfoRow(
                            'Transfer Method',
                            transferMethod.name,
                          ),
                          
                          // Note
                          if (note != null && note.isNotEmpty)
                            _buildInfoRow(
                              'Note',
                              note,
                            ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Authorization section
                  Text(
                    'Authorize Transfer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your 4-digit PIN to confirm this transfer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // PIN input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          controller: _pinControllers[index],
                          focusNode: _pinFocusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          obscureText: true,
                          obscuringCharacter: '•',
                          decoration: InputDecoration(
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF0066CC), width: 2),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          // Confirm button
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleConfirmTransfer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0066CC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Confirm Transfer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransferCompleteView() {
    if (_confirmedTransfer == null) {
      return const Center(
        child: Text('Transfer information not available'),
      );
    }
    
    final transfer = _confirmedTransfer!;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Success message
          Text(
            'Transfer Successful',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Your money is on its way',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Reference number
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Text(
                  'Reference Number',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  transfer.referenceNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Estimated delivery: ${DateFormat('MMM dd, yyyy').format(transfer.estimatedDeliveryDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _handleBackToHome,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFF0066CC)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSeeDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('See Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatAccountNumber(String accountNumber) {
    // Mask account number for privacy, showing only last 4 digits
    if (accountNumber.length <= 4) {
      return accountNumber;
    }
    
    final visiblePart = accountNumber.substring(accountNumber.length - 4);
    return '••••••${visiblePart}';
  }
  
  Widget _buildProgressTracker(String phaseName) {
    return Container(
      color: const Color(0xFFF0F7FF),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppProgressTracker.getScreenStatusIcon(_screenNumber),
              const SizedBox(width: 8),
              Text(
                'Screen #$_screenNumber: $_screenName',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppProgressTracker.getScreenStatusColor(_screenNumber),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppProgressTracker.getScreenStatusText(_screenNumber),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Phase: $phaseName (${AppProgressTracker.getPhaseProgress(phaseName)} completed)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ProgressIndicator(
                  value: AppProgressTracker.getPhaseCompletionPercentage(phaseName),
                  color: const Color(0xFF0066CC),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(AppProgressTracker.getPhaseCompletionPercentage(phaseName) * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Overall App Progress: ${AppProgressTracker.completedScreens}/${AppProgressTracker.totalScreens} screens (${(AppProgressTracker.getOverallCompletionPercentage() * 100).toInt()}%)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          ProgressIndicator(
            value: AppProgressTracker.getOverallCompletionPercentage(),
            color: const Color(0xFFFFB800),
          ),
        ],
      ),
    );
  }
}

/// A custom progress indicator widget
class ProgressIndicator extends StatelessWidget {
  final double value;
  final Color color;
  
  const ProgressIndicator({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}