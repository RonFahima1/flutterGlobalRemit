import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/beneficiary.dart';
import '../../providers/beneficiary_provider.dart';
import '../../theme/colors.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({Key? key}) : super(key: key);

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _routingNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  
  BeneficiaryAccountType _accountType = BeneficiaryAccountType.bank;
  bool _saveAsContact = true;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _accountNumberController.dispose();
    _routingNumberController.dispose();
    _bankNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveBeneficiary() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final beneficiary = Beneficiary(
        id: '', // Will be assigned by the backend
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        accountType: _accountType,
        accountNumber: _accountNumberController.text.trim(),
        routingNumber: _routingNumberController.text.trim(),
        bankName: _bankNameController.text.trim(),
        address: _addressController.text.trim(),
        phone: _phoneController.text.trim(),
        isFrequent: false,
      );

      final beneficiaryProvider = Provider.of<BeneficiaryProvider>(context, listen: false);
      final success = await beneficiaryProvider.addBeneficiary(beneficiary);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Beneficiary added successfully'),
            backgroundColor: GlobalRemitColors.secondaryGreenLight,
          ),
        );
        
        Navigator.pop(context, true); // Return true to indicate success
      } else if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Failed to add beneficiary. Please try again.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    }
  }

  Widget _buildBankAccountFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bank Name
        TextFormField(
          controller: _bankNameController,
          decoration: const InputDecoration(
            labelText: 'Bank Name',
            hintText: 'Enter bank name',
            prefixIcon: Icon(Icons.account_balance),
          ),
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (_accountType == BeneficiaryAccountType.bank &&
                (value == null || value.isEmpty)) {
              return 'Please enter the bank name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Account Number
        TextFormField(
          controller: _accountNumberController,
          decoration: const InputDecoration(
            labelText: 'Account Number',
            hintText: 'Enter account number',
            prefixIcon: Icon(Icons.account_box),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (_accountType == BeneficiaryAccountType.bank &&
                (value == null || value.isEmpty)) {
              return 'Please enter account number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Routing Number
        TextFormField(
          controller: _routingNumberController,
          decoration: const InputDecoration(
            labelText: 'Routing Number (ABA)',
            hintText: 'Enter routing number',
            prefixIcon: Icon(Icons.route),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (_accountType == BeneficiaryAccountType.bank &&
                (value == null || value.isEmpty)) {
              return 'Please enter routing number';
            }
            if (_accountType == BeneficiaryAccountType.bank && 
                value != null && 
                value.length < 9) {
              return 'Routing number should be 9 digits';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailTransferFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter recipient email',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (_accountType == BeneficiaryAccountType.email &&
                (value == null || value.isEmpty)) {
              return 'Please enter an email address';
            }
            if (_accountType == BeneficiaryAccountType.email &&
                value != null &&
                !Validators.isValidEmail(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recipient'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a new recipient for transfers',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Recipient Name',
                  hintText: 'Enter full name',
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter recipient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Phone field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (optional)',
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 24),
              
              // Transfer method selection
              Text(
                'Transfer Method',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Transfer method radio buttons
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    RadioListTile<BeneficiaryAccountType>(
                      title: const Text('Bank Account'),
                      subtitle: const Text('Direct transfer to bank account'),
                      value: BeneficiaryAccountType.bank,
                      groupValue: _accountType,
                      activeColor: GlobalRemitColors.primaryBlueLight,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                    Divider(
                      height: 1, 
                      indent: 20, 
                      endIndent: 20,
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                    RadioListTile<BeneficiaryAccountType>(
                      title: const Text('Email Transfer'),
                      subtitle: const Text('Send money using email address'),
                      value: BeneficiaryAccountType.email,
                      groupValue: _accountType,
                      activeColor: GlobalRemitColors.primaryBlueLight,
                      onChanged: (value) {
                        setState(() {
                          _accountType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Account details
              Text(
                'Account Details',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Show appropriate fields based on selection
              _accountType == BeneficiaryAccountType.bank
                  ? _buildBankAccountFields()
                  : _buildEmailTransferFields(),
              
              // Address (optional)
              if (_accountType == BeneficiaryAccountType.bank) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address (optional)',
                    hintText: 'Enter bank address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  maxLines: 2,
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Save as contact checkbox
              Row(
                children: [
                  Checkbox(
                    value: _saveAsContact,
                    activeColor: GlobalRemitColors.primaryBlueLight,
                    onChanged: (value) {
                      setState(() {
                        _saveAsContact = value ?? true;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Save to my contacts for future transfers',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Error message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Submit button
              CustomButton(
                text: 'Add Recipient',
                isLoading: _isSaving,
                onPressed: _saveBeneficiary,
                color: GlobalRemitColors.primaryBlueLight,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}