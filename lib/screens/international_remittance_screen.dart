import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import '../models/beneficiary.dart';
import '../models/currency.dart';
import '../models/transfer_method.dart';
import '../services/transfer_service.dart';
import '../services/country_service.dart';
import '../utils/currency_utils.dart';
import '../utils/progress_tracker.dart';
import '../widgets/implementation_progress_badge.dart';
import '../widgets/country_tile.dart';
import '../widgets/currency_selector.dart';
import '../widgets/transfer_method_selector.dart';
import '../widgets/delivery_option_selector.dart';

class InternationalRemittanceScreen extends StatefulWidget {
  const InternationalRemittanceScreen({Key? key}) : super(key: key);

  @override
  State<InternationalRemittanceScreen> createState() => _InternationalRemittanceScreenState();
}

class _InternationalRemittanceScreenState extends State<InternationalRemittanceScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  bool _isLoading = false;
  bool _showProgress = false;
  String? _errorMessage;
  
  // Screen implementation information
  final int _screenNumber = 20;
  final String _screenName = 'International Remittance Screen';
  
  // Selected values
  Country? _selectedCountry;
  Currency _sourceCurrency = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  Currency? _targetCurrency;
  Beneficiary? _selectedBeneficiary;
  TransferMethod? _selectedTransferMethod;
  String? _selectedDeliveryOption;
  
  // Available options
  List<Currency> _availableCurrencies = [];
  List<TransferMethod> _availableTransferMethods = [];
  List<String> _availableDeliveryOptions = [];
  List<Beneficiary> _beneficiaries = [];
  
  // Exchange rate and converted amount
  double? _exchangeRate;
  String _convertedAmount = '0.00';
  
  // Services
  final TransferService _transferService = TransferService();
  final CountryService _countryService = CountryService();
  
  @override
  void initState() {
    super.initState();
    _setupListeners();
  }
  
  void _setupListeners() {
    _amountController.addListener(_updateConvertedAmount);
  }
  
  void _toggleProgressDisplay() {
    setState(() {
      _showProgress = !_showProgress;
    });
  }
  
  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      searchAutofocus: true,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(16),
        inputDecoration: InputDecoration(
          labelText: 'Search for country',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _isLoading = true;
          _errorMessage = null;
          
          // Clear current selections that depend on country
          _targetCurrency = null;
          _selectedTransferMethod = null;
          _selectedDeliveryOption = null;
        });
        
        // Load country-specific data
        _loadCountryData(country);
      },
    );
  }
  
  Future<void> _loadCountryData(Country country) async {
    try {
      // Get available currencies for the selected country
      final currencies = await _countryService.getAvailableCurrencies(country.countryCode);
      
      // Get available transfer methods for the selected country
      final methods = await _countryService.getAvailableTransferMethods(country.countryCode);
      
      // Get available delivery options for the selected country
      final deliveryOptions = await _countryService.getDeliveryOptions(country.countryCode);
      
      // Get beneficiaries in the selected country
      final countryBeneficiaries = await _transferService.getBeneficiariesByCountry(country.countryCode);
      
      setState(() {
        _availableCurrencies = currencies;
        _availableTransferMethods = methods;
        _availableDeliveryOptions = deliveryOptions;
        _beneficiaries = countryBeneficiaries;
        
        // Set default target currency if available
        if (currencies.isNotEmpty) {
          _targetCurrency = currencies.first;
          // Update exchange rate for the selected currencies
          _updateExchangeRate();
        }
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load country-specific data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  void _updateExchangeRate() async {
    if (_sourceCurrency == null || _targetCurrency == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final rate = await _transferService.getExchangeRate(
        _sourceCurrency.code,
        _targetCurrency!.code,
      );
      
      setState(() {
        _exchangeRate = rate;
        _isLoading = false;
      });
      
      _updateConvertedAmount();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch exchange rate: ${e.toString()}';
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
  
  void _handleTransferMethodSelected(TransferMethod method) {
    setState(() {
      _selectedTransferMethod = method;
      
      // Reset delivery option when transfer method changes
      _selectedDeliveryOption = null;
    });
  }
  
  void _handleDeliveryOptionSelected(String option) {
    setState(() {
      _selectedDeliveryOption = option;
    });
  }
  
  void _handleBeneficiarySelected(Beneficiary beneficiary) {
    setState(() {
      _selectedBeneficiary = beneficiary;
    });
  }
  
  void _handleAddBeneficiary() {
    // Navigate to add beneficiary screen with country pre-selected
    if (_selectedCountry != null) {
      Navigator.of(context).pushNamed(
        '/add-beneficiary',
        arguments: {'countryCode': _selectedCountry!.countryCode},
      );
    }
  }
  
  void _handleProceed() {
    // Validate form
    if (_amountController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount';
      });
      return;
    }
    
    if (_selectedCountry == null) {
      setState(() {
        _errorMessage = 'Please select a destination country';
      });
      return;
    }
    
    if (_targetCurrency == null) {
      setState(() {
        _errorMessage = 'Please select a target currency';
      });
      return;
    }
    
    if (_selectedTransferMethod == null) {
      setState(() {
        _errorMessage = 'Please select a transfer method';
      });
      return;
    }
    
    if (_selectedDeliveryOption == null && _availableDeliveryOptions.isNotEmpty) {
      setState(() {
        _errorMessage = 'Please select a delivery option';
      });
      return;
    }
    
    if (_selectedBeneficiary == null) {
      setState(() {
        _errorMessage = 'Please select a beneficiary';
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
      
      // Navigate to confirmation screen with transfer details
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
          'deliveryOption': _selectedDeliveryOption,
          'destinationCountry': _selectedCountry,
          'note': _noteController.text,
          'isInternational': true,
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Please enter a valid amount';
      });
    }
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the phase name for this screen
    final phaseName = AppProgressTracker.getPhaseForScreen(_screenNumber) ?? 'Unknown';
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('International Transfer'),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
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
                    
                    // Destination country selection
                    _buildSectionTitle('Destination Country'),
                    _buildCountrySelector(),
                    
                    const SizedBox(height: 24),
                    
                    // Show country-specific options if a country is selected
                    if (_selectedCountry != null) ...[
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
                      if (_targetCurrency != null)
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
                                      'Exchange Rate: 1 ${_sourceCurrency.code} = ${_exchangeRate?.toStringAsFixed(4) ?? '---'} ${_targetCurrency!.code}',
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
                      
                      // Rest of the implementation...
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
                          'Continue',
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
  
  Widget _buildCountrySelector() {
    return InkWell(
      onTap: _selectCountry,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            if (_selectedCountry != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  'assets/flags/${_selectedCountry!.countryCode.toLowerCase()}.png',
                  width: 32,
                  height: 24,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32,
                      height: 24,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: Text(
                        _selectedCountry!.countryCode,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedCountry!.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ] else ...[
              const Icon(
                Icons.language,
                color: Color(0xFF0066CC),
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                'Select Destination Country',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyBeneficiaries() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.person_add_outlined,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'No recipients in ${_selectedCountry!.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Add a recipient to send money to ${_selectedCountry!.name}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _handleAddBeneficiary,
            icon: const Icon(Icons.add),
            label: const Text('Add Recipient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0066CC),
              side: const BorderSide(color: Color(0xFF0066CC)),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBeneficiaryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _beneficiaries.length,
      itemBuilder: (context, index) {
        final beneficiary = _beneficiaries[index];
        final isSelected = _selectedBeneficiary?.id == beneficiary.id;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          elevation: 0,
          child: InkWell(
            onTap: () => _handleBeneficiarySelected(beneficiary),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getBeneficiaryColor(beneficiary.id),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getBeneficiaryInitials(beneficiary.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          beneficiary.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          beneficiary.bankName ?? 'Mobile Money',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatAccountNumber(beneficiary.accountNumber),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<Beneficiary>(
                    value: beneficiary,
                    groupValue: _selectedBeneficiary,
                    onChanged: (value) {
                      if (value != null) {
                        _handleBeneficiarySelected(value);
                      }
                    },
                    activeColor: const Color(0xFF0066CC),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
  
  // Helper methods
  String _formatAccountNumber(String accountNumber) {
    if (accountNumber.length <= 4) {
      return accountNumber;
    }
    return '•••• ${accountNumber.substring(accountNumber.length - 4)}';
  }
  
  String _getBeneficiaryInitials(String name) {
    final names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }
  
  Color _getBeneficiaryColor(String id) {
    final colors = [
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
      const Color(0xFFFFD166),
      const Color(0xFF06D6A0),
      const Color(0xFF118AB2),
      const Color(0xFF073B4C),
      const Color(0xFF7678ED),
      const Color(0xFFF08080),
      const Color(0xFF8675A9),
      const Color(0xFF3AAFA9),
    ];
    
    // Generate a consistent color based on id
    final hashCode = id.hashCode.abs();
    return colors[hashCode % colors.length];
  }
  
  int min(int a, int b) => a < b ? a : b;
}

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