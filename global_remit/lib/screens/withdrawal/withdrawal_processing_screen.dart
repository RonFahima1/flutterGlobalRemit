import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/withdrawal_method.dart';
import '../../widgets/implementation_badge.dart';
import '../../theme/app_colors.dart';
import '../../services/withdrawal_service.dart';
import '../../utils/form_validators.dart';
import '../../widgets/processing_steps.dart';

class WithdrawalProcessingScreen extends StatefulWidget {
  final WithdrawalMethod method;
  static const routeName = '/withdrawal-processing';

  const WithdrawalProcessingScreen({
    Key? key,
    required this.method,
  }) : super(key: key);

  @override
  _WithdrawalProcessingScreenState createState() =>
      _WithdrawalProcessingScreenState();
}

class _WithdrawalProcessingScreenState
    extends State<WithdrawalProcessingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _withdrawalService = WithdrawalService();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _currentStep = 0;
  bool _isProcessing = false;
  String? _errorMessage;
  bool _withdrawalComplete = false;

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && !_formKey.currentState!.validate()) {
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    } else {
      _processWithdrawal();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Future<void> _processWithdrawal() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      
      // In a real app, this would call the withdrawal service
      await _withdrawalService.processWithdrawal(
        method: widget.method,
        amount: double.parse(_amountController.text),
        targetAccount: _accountController.text,
        description: _descriptionController.text,
      );

      setState(() {
        _withdrawalComplete = true;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isProcessing = false;
      });
    }
  }

  Widget _buildWithdrawalDetailsStep() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Withdrawal Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            validator: (value) => FormValidators.validateAmount(value),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _accountController,
            decoration: InputDecoration(
              labelText: widget.method.accountFieldLabel ?? 'Account Number',
              prefixIcon: const Icon(Icons.account_balance),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) => FormValidators.validateRequired(
              value,
              widget.method.accountFieldLabel ?? 'Account number',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Withdrawal',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildConfirmationRow(
                  'Withdrawal Method',
                  widget.method.name,
                  Icons.account_balance,
                ),
                const Divider(),
                _buildConfirmationRow(
                  'Amount',
                  '\$${amount.toStringAsFixed(2)}',
                  Icons.attach_money,
                ),
                const Divider(),
                _buildConfirmationRow(
                  widget.method.accountFieldLabel ?? 'Account',
                  _accountController.text,
                  Icons.account_box,
                ),
                if (_descriptionController.text.isNotEmpty) ...[
                  const Divider(),
                  _buildConfirmationRow(
                    'Description',
                    _descriptionController.text,
                    Icons.description,
                  ),
                ],
                const Divider(),
                _buildConfirmationRow(
                  'Processing Time',
                  widget.method.processingTime ?? 'Varies',
                  Icons.access_time,
                ),
                const Divider(),
                _buildConfirmationRow(
                  'Fee',
                  widget.method.feeStructure ?? 'Standard fees apply',
                  Icons.monetization_on,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Please verify all information before proceeding. This withdrawal cannot be easily reversed once processed.',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingStep() {
    if (_withdrawalComplete) {
      return _buildSuccessContent();
    }

    if (_errorMessage != null) {
      return _buildErrorContent();
    }

    if (_isProcessing) {
      return _buildProcessingContent();
    }

    return _buildConfirmationStep();
  }

  Widget _buildProcessingContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 32),
        Text(
          'Processing your withdrawal...',
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Please do not close this screen.',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 72,
          color: Colors.green[400],
        ),
        const SizedBox(height: 24),
        Text(
          'Withdrawal Initiated Successfully!',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Your withdrawal request has been submitted and is being processed.',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Processing time: ${widget.method.processingTime ?? 'Varies based on the withdrawal method'}',
          style: TextStyle(
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            backgroundColor: AppColors.primary,
          ),
          child: const Text('Return to Dashboard'),
        ),
      ],
    );
  }

  Widget _buildErrorContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 72,
          color: Colors.red[400],
        ),
        const SizedBox(height: 24),
        Text(
          'Withdrawal Failed',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'We encountered an error processing your withdrawal:',
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _errorMessage ?? 'Unknown error',
          style: TextStyle(color: Colors.red[400]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Back'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: _processWithdrawal,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw via ${widget.method.name}'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ProcessingSteps(
                currentStep: _currentStep,
                steps: const ['Details', 'Confirm', 'Process'],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: _currentStep == 0
                        ? _buildWithdrawalDetailsStep()
                        : _buildProcessingStep(),
                  ),
                ),
              ),
              if (!_withdrawalComplete)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep > 0 && !_isProcessing)
                        OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Back'),
                        )
                      else
                        const SizedBox.shrink(),
                      if (!_isProcessing && _errorMessage == null)
                        ElevatedButton(
                          onPressed: _nextStep,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(_currentStep < 2 ? 'Next' : 'Confirm'),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}