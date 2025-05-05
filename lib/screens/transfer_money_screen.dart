import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/beneficiary.dart';
import '../models/currency.dart';
import '../models/transfer_method.dart';
import '../services/transfer_service.dart';
import '../utils/currency_utils.dart';
import '../utils/progress_tracker.dart';
import '../widgets/beneficiary_selector.dart';
import '../widgets/currency_selector.dart';
import '../widgets/transfer_method_selector.dart';

class TransferMoneyScreen extends StatefulWidget {
  const TransferMoneyScreen({Key? key}) : super(key: key);

  @override
  State<TransferMoneyScreen> createState() => _TransferMoneyScreenState();
}

class _TransferMoneyScreenState extends State<TransferMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool _showProgress = false;

  // Screen implementation information
  final int _screenNumber = 18;
  final String _screenName = 'Transfer Money Screen';

  // State variables
  Currency _sourceCurrency = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  Currency _targetCurrency = Currency(code: 'EUR', symbol: '€', name: 'Euro');
  double? _exchangeRate;
  String _convertedAmount = '0.00';
  Beneficiary? _selectedBeneficiary;
  List<Beneficiary> _beneficiaries = [];
  TransferMethod? _selectedTransferMethod;
  List<TransferMethod> _transferMethods = [];

  final TransferService _transferService = TransferService();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupListeners();
    _loadTransferMethods();
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load beneficiaries
      final beneficiaries = await _transferService.getBeneficiaries();
      
      // Load initial exchange rate
      final rate = await _transferService.getExchangeRate(
        _sourceCurrency.code, 
        _targetCurrency.code
      );

      setState(() {
        _beneficiaries = beneficiaries;
        _exchangeRate = rate;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load initial data. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _setupListeners() {
    _amountController.addListener(_updateConvertedAmount);
  }

  void _loadTransferMethods() {
    setState(() {
      _transferMethods = [
        TransferMethod(
          id: 'bank',
          name: 'Bank Transfer',
          icon: Icons.account_balance_outlined,
          fee: 2.50,
          estimatedTime: '1-2 business days',
        ),
        TransferMethod(
          id: 'instant',
          name: 'Instant Transfer',
          icon: Icons.flash_on_outlined,
          fee: 5.00,
          estimatedTime: 'Immediate',
        ),
        TransferMethod(
          id: 'mobile',
          name: 'Mobile Money',
          icon: Icons.phone_android_outlined,
          fee: 1.00,
          estimatedTime: '15 minutes',
        ),
        TransferMethod(
          id: 'cash',
          name: 'Cash Pickup',
          icon: Icons.payments_outlined,
          fee: 3.00,
          estimatedTime: 'Same day',
        ),
      ];
    });
  }

  void _updateExchangeRate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rate = await _transferService.getExchangeRate(
        _sourceCurrency.code, 
        _targetCurrency.code
      );

      setState(() {
        _exchangeRate = rate;
        _isLoading = false;
      });

      _updateConvertedAmount();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch exchange rate. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _updateConvertedAmount() {
    if (_amountController.text.isEmpty || _exchangeRate == null) {
      setState(() {
        _convertedAmount = '0.00';
      });
      return;
    }

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      final converted = (amount * _exchangeRate!).toStringAsFixed(2);
      
      setState(() {
        _convertedAmount = converted;
      });
    } catch (e) {
      setState(() {
        _convertedAmount = '0.00';
      });
    }
  }

  void _handleSourceCurrencyChanged(Currency currency) {
    setState(() {
      _sourceCurrency = currency;
    });
    _updateExchangeRate();
  }

  void _handleTargetCurrencyChanged(Currency currency) {
    setState(() {
      _targetCurrency = currency;
    });
    _updateExchangeRate();
  }

  void _handleBeneficiarySelected(Beneficiary beneficiary) {
    setState(() {
      _selectedBeneficiary = beneficiary;
    });
  }

  void _handleTransferMethodSelected(TransferMethod method) {
    setState(() {
      _selectedTransferMethod = method;
    });
  }

  void _toggleProgressDisplay() {
    setState(() {
      _showProgress = !_showProgress;
    });
  }

  void _handleProceed() {
    // Clear previous errors
    setState(() {
      _errorMessage = null;
    });

    // Validate form
    if (_amountController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount';
      });
      return;
    }

    try {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      if (amount <= 0) {
        setState(() {
          _errorMessage = 'Please enter a valid amount greater than zero';
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
      });
      return;
    }

    if (_selectedBeneficiary == null) {
      setState(() {
        _errorMessage = 'Please select a beneficiary';
      });
      return;
    }

    if (_selectedTransferMethod == null) {
      setState(() {
        _errorMessage = 'Please select a transfer method';
      });
      return;
    }

    // Navigate to confirmation screen
    Navigator.of(context).pushNamed(
      '/transfer-confirmation',
      arguments: {
        'amount': _amountController.text,
        'sourceCurrency': _sourceCurrency,
        'targetCurrency': _targetCurrency,
        'convertedAmount': _convertedAmount,
        'exchangeRate': _exchangeRate,
        'beneficiary': _selectedBeneficiary,
        'transferMethod': _selectedTransferMethod,
        'note': _noteController.text,
      },
    );
  }

  void _handleAddBeneficiary() {
    Navigator.of(context).pushNamed('/add-beneficiary');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_screenName),
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
              _buildProgressTracker(AppProgressTracker.getPhaseForScreen(_screenNumber) ?? 'Unknown'),
              
            // Main scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Error message (if any)
                    if (_errorMessage != null)
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
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _errorMessage = null;
                                });
                              },
                              child: Icon(Icons.close, color: Colors.red.shade700),
                            ),
                          ],
                        ),
                      ),

                    if (_errorMessage != null) const SizedBox(height: 16),

                    // Amount input section
                    _buildSectionTitle('You Send'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          // Currency selector
                          CurrencySelector(
                            selectedCurrency: _sourceCurrency,
                            onCurrencySelected: _handleSourceCurrencyChanged,
                          ),

                          // Vertical divider
                          Container(
                            height: 48,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),

                          // Amount input
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                hintText: '0.00',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Exchange rate info
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F7FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0066CC)),
                                  ),
                                )
                              : Text(
                                  'Exchange Rate: 1 ${_sourceCurrency.code} = ${_exchangeRate?.toStringAsFixed(4) ?? '---'} ${_targetCurrency.code}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                          const Icon(
                            Icons.swap_vert,
                            color: Color(0xFF0066CC),
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    // Recipient gets
                    const SizedBox(height: 24),
                    _buildSectionTitle('Recipient Gets'),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade50,
                      ),
                      child: Row(
                        children: [
                          // Currency selector
                          CurrencySelector(
                            selectedCurrency: _targetCurrency,
                            onCurrencySelected: _handleTargetCurrencyChanged,
                          ),

                          // Vertical divider
                          Container(
                            height: 48,
                            width: 1,
                            color: Colors.grey.shade300,
                          ),

                          // Converted amount
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '${_targetCurrency.symbol} ${formatCurrency(_convertedAmount)}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Beneficiary selection
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('Select Beneficiary'),
                        TextButton.icon(
                          onPressed: _handleAddBeneficiary,
                          icon: const Icon(
                            Icons.add_circle,
                            size: 18,
                            color: Color(0xFF0066CC),
                          ),
                          label: const Text(
                            'Add New',
                            style: TextStyle(
                              color: Color(0xFF0066CC),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    BeneficiarySelector(
                      beneficiaries: _beneficiaries,
                      selectedBeneficiary: _selectedBeneficiary,
                      onBeneficiarySelected: _handleBeneficiarySelected,
                      isLoading: _isLoading,
                    ),

                    // Transfer method
                    const SizedBox(height: 24),
                    _buildSectionTitle('Transfer Method'),
                    TransferMethodSelector(
                      methods: _transferMethods,
                      selectedMethod: _selectedTransferMethod,
                      onMethodSelected: _handleTransferMethodSelected,
                    ),

                    // Note
                    const SizedBox(height: 24),
                    _buildSectionTitle('Note (Optional)'),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'Add a note to the recipient',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      maxLines: 3,
                      maxLength: 100,
                    ),

                    // Transfer fee
                    if (_selectedTransferMethod != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF9E6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transfer fee: ${_sourceCurrency.symbol}${_selectedTransferMethod!.fee.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimated delivery: ${_selectedTransferMethod!.estimatedTime}',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
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

            // Bottom action button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, -1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0066CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else ...[
                        const Text(
                          'Proceed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
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
