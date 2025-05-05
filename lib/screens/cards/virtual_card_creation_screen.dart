import 'package:flutter/material.dart';
import '../../models/card.dart';
import '../../providers/card_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/card_preview.dart';
import '../../widgets/custom_button.dart';
import 'package:provider/provider.dart';

class VirtualCardCreationScreen extends StatefulWidget {
  const VirtualCardCreationScreen({Key? key}) : super(key: key);

  @override
  State<VirtualCardCreationScreen> createState() => _VirtualCardCreationScreenState();
}

class _VirtualCardCreationScreenState extends State<VirtualCardCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNameController = TextEditingController();
  
  CardType _selectedCardType = CardType.visa;
  double _monthlyLimit = 2000;
  bool _enableOnlinePayments = true;
  bool _enableInternationalPayments = false;
  bool _isProcessing = false;
  String? _errorMessage;
  
  Color _cardColor = GlobalRemitColors.primaryBlueLight;
  final List<Color> _availableColors = [
    GlobalRemitColors.primaryBlueLight,
    GlobalRemitColors.warningOrangeLight,
    GlobalRemitColors.secondaryGreenLight,
    const Color(0xFF1976D2), // Blue
    const Color(0xFF0097A7), // Cyan
    const Color(0xFF689F38), // Light Green
    const Color(0xFFFFA000), // Amber
  ];

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }

  Future<void> _createVirtualCard() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final cardProvider = Provider.of<CardProvider>(context, listen: false);
      
      // Create virtual card data
      final cardData = VirtualCardCreationData(
        name: _cardNameController.text,
        cardType: _selectedCardType,
        monthlyLimit: _monthlyLimit,
        enableOnlinePayments: _enableOnlinePayments,
        enableInternationalPayments: _enableInternationalPayments,
        cardColor: _cardColor,
      );
      
      final createdCard = await cardProvider.createVirtualCard(cardData);
      
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        if (createdCard != null) {
          // Show success and navigate to card details
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Virtual card created successfully'),
              backgroundColor: GlobalRemitColors.secondaryGreenLight,
            ),
          );
          
          // Navigate to the card detail screen with the newly created card
          Navigator.pop(context, createdCard);
        } else {
          setState(() {
            _errorMessage = 'Failed to create virtual card. Please try again.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _errorMessage = 'An error occurred: ${e.toString()}';
        });
      }
    }
  }

  Widget _buildCardTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Visa
        RadioListTile<CardType>(
          title: Row(
            children: [
              Image.asset(
                'assets/images/visa_logo.png',
                height: 24,
              ),
              const SizedBox(width: 12),
              const Text('Visa'),
            ],
          ),
          value: CardType.visa,
          groupValue: _selectedCardType,
          activeColor: GlobalRemitColors.primaryBlueLight,
          onChanged: (CardType? value) {
            if (value != null) {
              setState(() {
                _selectedCardType = value;
              });
            }
          },
        ),
        
        // Mastercard
        RadioListTile<CardType>(
          title: Row(
            children: [
              Image.asset(
                'assets/images/mastercard_logo.png',
                height: 24,
              ),
              const SizedBox(width: 12),
              const Text('Mastercard'),
            ],
          ),
          value: CardType.mastercard,
          groupValue: _selectedCardType,
          activeColor: GlobalRemitColors.primaryBlueLight,
          onChanged: (CardType? value) {
            if (value != null) {
              setState(() {
                _selectedCardType = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildCardCustomizationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Appearance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Card Color Selection
        Text(
          'Card Color',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final color in _availableColors)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _cardColor = color;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: _cardColor == color
                            ? Border.all(color: Colors.white, width: 2)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _cardColor == color
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Preview
        Text(
          'Card Preview',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        
        // Card Preview
        Center(
          child: SizedBox(
            height: 200,
            child: _buildCardPreview(),
          ),
        ),
      ],
    );
  }

  Widget _buildCardPreview() {
    // Create a temporary card for preview
    final previewCard = BankCard(
      id: 'preview',
      number: '4111 1111 1111 1111',
      maskedNumber: '•••• •••• •••• 1111',
      expiryDate: '12/25',
      cvv: '123',
      cardholderName: 'JOHN DOE',
      name: _cardNameController.text.isEmpty ? 'Virtual Card' : _cardNameController.text,
      type: _selectedCardType,
      status: CardStatus.active,
      isVirtual: true,
      atmLimit: 0,
      onlineLimit: _monthlyLimit,
      dailyLimit: _monthlyLimit / 30, // Approx daily limit
      contactlessEnabled: true,
      onlinePaymentsEnabled: _enableOnlinePayments,
      internationalPaymentsEnabled: _enableInternationalPayments,
      atmWithdrawalsEnabled: false,
      transactionNotificationsEnabled: true,
    );
    
    return CardPreview(card: previewCard);
  }

  Widget _buildCardSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Monthly Spending Limit Slider
        Text(
          'Monthly Spending Limit',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${_monthlyLimit.toInt().toString()}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: GlobalRemitColors.primaryBlueLight,
              ),
            ),
            Text(
              'Max: \$10,000',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        Slider(
          value: _monthlyLimit,
          min: 100,
          max: 10000,
          divisions: 99,
          activeColor: GlobalRemitColors.primaryBlueLight,
          label: '\$${_monthlyLimit.toInt()}',
          onChanged: (double value) {
            setState(() {
              _monthlyLimit = value;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Online Payments Toggle
        SwitchListTile(
          title: const Text('Enable Online Payments'),
          subtitle: const Text('Allow online and in-app purchases'),
          value: _enableOnlinePayments,
          activeColor: GlobalRemitColors.primaryBlueLight,
          onChanged: (value) {
            setState(() {
              _enableOnlinePayments = value;
            });
          },
        ),
        
        // International Payments Toggle
        SwitchListTile(
          title: const Text('Enable International Payments'),
          subtitle: const Text('Allow purchases from foreign merchants'),
          value: _enableInternationalPayments,
          activeColor: GlobalRemitColors.primaryBlueLight,
          onChanged: (value) {
            setState(() {
              _enableInternationalPayments = value;
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Virtual Card'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new virtual card for online purchases',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              
              // Card Name
              TextFormField(
                controller: _cardNameController,
                decoration: const InputDecoration(
                  labelText: 'Card Name',
                  hintText: 'e.g., "Shopping Card" or "Travel Card"',
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for your card';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Card Type Selection
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildCardTypeSelection(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Card Customization
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildCardCustomizationSection(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Card Settings
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildCardSettingsSection(),
                ),
              ),
              const SizedBox(height: 24),
              
              // Error Message
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
              
              // Create Button
              CustomButton(
                text: 'Create Virtual Card',
                isLoading: _isProcessing,
                onPressed: _createVirtualCard,
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

class VirtualCardCreationData {
  final String name;
  final CardType cardType;
  final double monthlyLimit;
  final bool enableOnlinePayments;
  final bool enableInternationalPayments;
  final Color cardColor;

  VirtualCardCreationData({
    required this.name,
    required this.cardType,
    required this.monthlyLimit,
    required this.enableOnlinePayments,
    required this.enableInternationalPayments,
    required this.cardColor,
  });
}