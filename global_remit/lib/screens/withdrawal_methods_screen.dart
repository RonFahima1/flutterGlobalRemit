import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/implementation_progress_badge.dart';
import '../utils/currency_utils.dart';
import 'withdrawal_processing_screen.dart';

class WithdrawalMethod {
  final String id;
  final String name;
  final String description;
  final String processingTime;
  final double fee;
  final String feeType; // 'fixed' or 'percentage'
  final double? minimumAmount;
  final double? maximumAmount;
  final IconData icon;
  final List<String> supportedCurrencies;
  final bool isPopular;
  final bool isInstant;

  WithdrawalMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.processingTime,
    required this.fee,
    required this.feeType,
    this.minimumAmount,
    this.maximumAmount,
    required this.icon,
    required this.supportedCurrencies,
    this.isPopular = false,
    this.isInstant = false,
  });

  String getFeeDisplay(String currency) {
    if (feeType == 'fixed') {
      return formatCurrency(fee, currency);
    } else {
      return '${fee.toStringAsFixed(1)}%';
    }
  }
}

class WithdrawalMethodsScreen extends StatefulWidget {
  const WithdrawalMethodsScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalMethodsScreenState createState() => _WithdrawalMethodsScreenState();
}

class _WithdrawalMethodsScreenState extends State<WithdrawalMethodsScreen> {
  bool _isLoading = false;
  String _selectedCurrency = 'USD';
  double _accountBalance = 4285.50; // Would come from a real balance service
  List<WithdrawalMethod> _withdrawalMethods = [];
  TextEditingController _amountController = TextEditingController();
  final double _defaultAmount = 100.0;

  @override
  void initState() {
    super.initState();
    _loadWithdrawalMethods();
    _amountController.text = _defaultAmount.toString();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadWithdrawalMethods() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be loaded from an API
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        _withdrawalMethods = [
          WithdrawalMethod(
            id: 'bank_transfer',
            name: 'Bank Transfer',
            description: 'Withdraw funds directly to your linked bank account',
            processingTime: '1-3 business days',
            fee: 0.0,
            feeType: 'fixed',
            minimumAmount: 50.0,
            maximumAmount: 50000.0,
            icon: Icons.account_balance,
            supportedCurrencies: ['USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY', 'CNY'],
            isPopular: true,
          ),
          WithdrawalMethod(
            id: 'debit_card',
            name: 'Debit Card',
            description: 'Instant withdrawal to your Visa or Mastercard',
            processingTime: 'Instant to 24 hours',
            fee: 1.5,
            feeType: 'percentage',
            minimumAmount: 10.0,
            maximumAmount: 5000.0,
            icon: Icons.credit_card,
            supportedCurrencies: ['USD', 'EUR', 'GBP', 'CAD', 'AUD'],
            isPopular: true,
            isInstant: true,
          ),
          WithdrawalMethod(
            id: 'paypal',
            name: 'PayPal',
            description: 'Withdraw to your PayPal account',
            processingTime: 'Within 24 hours',
            fee: 2.0,
            feeType: 'percentage',
            minimumAmount: 5.0,
            maximumAmount: 10000.0,
            icon: Icons.paypal,
            supportedCurrencies: ['USD', 'EUR', 'GBP', 'CAD', 'AUD'],
            isInstant: true,
          ),
          WithdrawalMethod(
            id: 'mobile_money',
            name: 'Mobile Money',
            description: 'Withdraw to mobile money services in supported countries',
            processingTime: 'Within 1 hour',
            fee: 1.0,
            feeType: 'percentage',
            minimumAmount: 5.0,
            maximumAmount: 2000.0,
            icon: Icons.phone_android,
            supportedCurrencies: ['USD', 'EUR', 'KES', 'NGN', 'GHS'],
            isInstant: true,
          ),
          WithdrawalMethod(
            id: 'cash_pickup',
            name: 'Cash Pickup',
            description: 'Collect cash at partner locations worldwide',
            processingTime: 'Available within 24 hours',
            fee: 5.0,
            feeType: 'fixed',
            minimumAmount: 50.0,
            maximumAmount: 3000.0,
            icon: Icons.money,
            supportedCurrencies: ['USD', 'EUR', 'GBP', 'CAD', 'MXN', 'INR'],
          ),
          WithdrawalMethod(
            id: 'crypto',
            name: 'Cryptocurrency',
            description: 'Withdraw to your cryptocurrency wallet',
            processingTime: 'Within 1 hour',
            fee: 1.0,
            feeType: 'percentage',
            minimumAmount: 20.0,
            maximumAmount: null,
            icon: Icons.currency_bitcoin,
            supportedCurrencies: ['USD', 'EUR'],
          ),
          WithdrawalMethod(
            id: 'check',
            name: 'Check by Mail',
            description: 'Receive a physical check to your registered address',
            processingTime: '5-7 business days',
            fee: 10.0,
            feeType: 'fixed',
            minimumAmount: 100.0,
            maximumAmount: 10000.0,
            icon: Icons.receipt_long,
            supportedCurrencies: ['USD', 'CAD', 'GBP'],
          ),
        ];
      });
    } catch (e) {
      _showErrorSnackBar('Error loading withdrawal methods: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  List<WithdrawalMethod> get _filteredMethods {
    return _withdrawalMethods.where((method) {
      return method.supportedCurrencies.contains(_selectedCurrency);
    }).toList();
  }

  void _proceedWithMethod(WithdrawalMethod method) {
    if (_amountController.text.isEmpty) {
      _showErrorSnackBar('Please enter an amount');
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }

    // Check minimum withdrawal amount
    if (method.minimumAmount != null && amount < method.minimumAmount!) {
      _showErrorSnackBar('Minimum withdrawal amount is ${formatCurrency(method.minimumAmount!, _selectedCurrency)}');
      return;
    }

    // Check maximum withdrawal amount
    if (method.maximumAmount != null && amount > method.maximumAmount!) {
      _showErrorSnackBar('Maximum withdrawal amount is ${formatCurrency(method.maximumAmount!, _selectedCurrency)}');
      return;
    }

    // Check if sufficient balance
    if (amount > _accountBalance) {
      _showErrorSnackBar('Insufficient balance. Available: ${formatCurrency(_accountBalance, _selectedCurrency)}');
      return;
    }

    // Calculate fee
    double fee = 0;
    if (method.feeType == 'fixed') {
      fee = method.fee;
    } else {
      fee = amount * (method.fee / 100);
    }

    // Navigate to processing screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawalProcessingScreen(
          method: method,
          amount: amount,
          fee: fee,
          currency: _selectedCurrency,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Money'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 5,
              totalPhases: 7,
              currentStep: 3,
              totalSteps: 5,
              isInProgress: false,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available balance card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Balance',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                formatCurrency(_accountBalance, _selectedCurrency),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedCurrency,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Amount and currency selector
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'How much would you like to withdraw?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Currency selector
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCurrency,
                                    items: ['USD', 'EUR', 'GBP', 'CAD', 'AUD']
                                        .map((currency) {
                                      return DropdownMenuItem<String>(
                                        value: currency,
                                        child: Text(currency),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedCurrency = value;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              
                              // Amount input
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.attach_money,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildQuickAmountButton(50),
                              _buildQuickAmountButton(100),
                              _buildQuickAmountButton(500),
                              _buildQuickAmountButton(1000),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _amountController.text = _accountBalance.toString();
                                  });
                                },
                                child: const Text('MAX'),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Different withdrawal methods may have different limits and fees',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Popular methods section
                  if (_filteredMethods.any((method) => method.isPopular)) ...[
                    const Text(
                      'Popular Methods',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._filteredMethods
                        .where((method) => method.isPopular)
                        .map((method) => _buildMethodCard(method)),
                    const SizedBox(height: 24),
                  ],
                  
                  // All methods section
                  const Text(
                    'All Withdrawal Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_filteredMethods.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No withdrawal methods available for $_selectedCurrency',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._filteredMethods
                        .where((method) => !method.isPopular)
                        .map((method) => _buildMethodCard(method)),
                ],
              ),
            ),
    );
  }

  Widget _buildQuickAmountButton(double amount) {
    return TextButton(
      onPressed: () {
        setState(() {
          _amountController.text = amount.toString();
        });
      },
      child: Text('\$${amount.toInt()}'),
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildMethodCard(WithdrawalMethod method) {
    // Calculate fee for display
    double amount = double.tryParse(_amountController.text) ?? _defaultAmount;
    double fee = method.feeType == 'fixed' 
        ? method.fee 
        : amount * (method.fee / 100);
    
    // Calculate amount after fee
    double amountAfterFee = amount - fee;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _proceedWithMethod(method),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Method icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      method.icon,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Method details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              method.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (method.isInstant)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Fast',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          method.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Method details (processing time, fee, limits)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailColumn(
                      'Processing Time',
                      method.processingTime,
                      Icons.schedule,
                    ),
                    _buildDetailColumn(
                      'Fee',
                      '${method.getFeeDisplay(_selectedCurrency)}',
                      Icons.account_balance_wallet,
                    ),
                    _buildDetailColumn(
                      'You Receive',
                      formatCurrency(amountAfterFee, _selectedCurrency),
                      Icons.arrow_downward,
                    ),
                  ],
                ),
              ),
              
              // Button
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _proceedWithMethod(method),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}