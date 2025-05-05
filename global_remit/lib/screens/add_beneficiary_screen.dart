import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/implementation_progress_badge.dart';
import '../models/beneficiary.dart';
import '../services/transfer_service.dart';
import '../utils/form_validators.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({Key? key}) : super(key: key);

  @override
  _AddBeneficiaryScreenState createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransferService _transferService = TransferService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedCountry = 'United States';
  String _selectedCurrency = 'USD';
  String _selectedCategory = 'Family';
  bool _isFavorite = false;

  final List<String> _countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'India',
    'Japan',
    'China',
    'Brazil',
    'Mexico',
    'United Arab Emirates',
    'Saudi Arabia',
    'Singapore',
    'Nigeria',
    'Kenya',
  ];

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'CAD',
    'AUD',
    'JPY',
    'CNY',
    'INR',
    'BRL',
    'MXN',
    'AED',
    'SAR',
    'SGD',
    'NGN',
    'KES',
  ];

  final List<String> _categories = [
    'Family',
    'Friends',
    'Business',
    'Bills',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveBeneficiary() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newBeneficiary = Beneficiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // This would be from the API in a real app
        name: _nameController.text,
        accountNumber: _accountNumberController.text,
        bankName: _bankNameController.text,
        country: _selectedCountry,
        currency: _selectedCurrency,
        email: _emailController.text,
        phone: _phoneController.text,
        isFavorite: _isFavorite,
        lastTransferDate: null, // No transfers yet
        category: _selectedCategory,
      );
      
      // Send to API
      // await _transferService.addBeneficiary(newBeneficiary);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Beneficiary added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding beneficiary: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Beneficiary'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 4,
              totalPhases: 7,
              currentStep: 7,
              totalSteps: 7,
              isInProgress: false,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSectionTitle('Personal Information'),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    prefixIcon: Icons.person,
                    validator: (value) => FormValidators.required(value, 'Name is required'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email Address',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => FormValidators.email(value),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) => FormValidators.phone(value),
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Bank Information'),
                  _buildTextField(
                    controller: _accountNumberController,
                    label: 'Account Number',
                    prefixIcon: Icons.account_balance,
                    validator: (value) => FormValidators.required(value, 'Account number is required'),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _bankNameController,
                    label: 'Bank Name',
                    prefixIcon: Icons.business,
                    validator: (value) => FormValidators.required(value, 'Bank name is required'),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Country',
                    value: _selectedCountry,
                    items: _countries,
                    prefixIcon: Icons.public,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCountry = value;
                          // Optionally update currency based on country
                          if (value == 'United States') _selectedCurrency = 'USD';
                          else if (value == 'United Kingdom') _selectedCurrency = 'GBP';
                          else if (value == 'Euro Area Countries') _selectedCurrency = 'EUR';
                          else if (value == 'Canada') _selectedCurrency = 'CAD';
                          else if (value == 'Australia') _selectedCurrency = 'AUD';
                          else if (value == 'Japan') _selectedCurrency = 'JPY';
                          // And so on...
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Currency',
                    value: _selectedCurrency,
                    items: _currencies,
                    prefixIcon: Icons.attach_money,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCurrency = value;
                        });
                      }
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  _buildSectionTitle('Categories & Preferences'),
                  _buildDropdown(
                    label: 'Category',
                    value: _selectedCategory,
                    items: _categories,
                    prefixIcon: Icons.category,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Add to Favorites'),
                    subtitle: const Text('Show at the top of your beneficiary list'),
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value;
                      });
                    },
                    secondary: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: _isFavorite ? Colors.amber[600] : Colors.grey,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveBeneficiary,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Beneficiary',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData prefixIcon,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefixIcon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}