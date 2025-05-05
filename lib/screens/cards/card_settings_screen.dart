import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/card.dart';
import '../../providers/card_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CardSettingsScreen extends StatefulWidget {
  final BankCard card;

  const CardSettingsScreen({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  State<CardSettingsScreen> createState() => _CardSettingsScreenState();
}

class _CardSettingsScreenState extends State<CardSettingsScreen> {
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  
  // Card settings state
  late double _atmLimit;
  late double _onlineLimit;
  late double _dailyLimit;
  late bool _contactlessEnabled;
  late bool _onlinePaymentsEnabled;
  late bool _internationalPaymentsEnabled;
  late bool _atmWithdrawalsEnabled;
  late bool _transactionNotificationsEnabled;

  // Controllers for text fields
  final _atmLimitController = TextEditingController();
  final _onlineLimitController = TextEditingController();
  final _dailyLimitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeSettings();
  }

  @override
  void dispose() {
    _atmLimitController.dispose();
    _onlineLimitController.dispose();
    _dailyLimitController.dispose();
    super.dispose();
  }

  void _initializeSettings() {
    setState(() {
      _isLoading = true;
    });

    // Initialize with card default values
    _atmLimit = widget.card.atmLimit;
    _onlineLimit = widget.card.onlineLimit;
    _dailyLimit = widget.card.dailyLimit;
    _contactlessEnabled = widget.card.contactlessEnabled;
    _onlinePaymentsEnabled = widget.card.onlinePaymentsEnabled;
    _internationalPaymentsEnabled = widget.card.internationalPaymentsEnabled;
    _atmWithdrawalsEnabled = widget.card.atmWithdrawalsEnabled;
    _transactionNotificationsEnabled = widget.card.transactionNotificationsEnabled;

    // Set controller values
    _atmLimitController.text = _atmLimit.toString();
    _onlineLimitController.text = _onlineLimit.toString();
    _dailyLimitController.text = _dailyLimit.toString();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    // Validate values
    try {
      final atmLimit = double.parse(_atmLimitController.text);
      final onlineLimit = double.parse(_onlineLimitController.text);
      final dailyLimit = double.parse(_dailyLimitController.text);

      if (atmLimit < 0 || onlineLimit < 0 || dailyLimit < 0) {
        setState(() {
          _errorMessage = 'Limits cannot be negative';
        });
        return;
      }

      setState(() {
        _isSaving = true;
        _errorMessage = null;
      });

      // Update settings in provider
      final cardProvider = Provider.of<CardProvider>(context, listen: false);
      final updatedCard = BankCard(
        id: widget.card.id,
        number: widget.card.number,
        maskedNumber: widget.card.maskedNumber,
        expiryDate: widget.card.expiryDate,
        cvv: widget.card.cvv,
        cardholderName: widget.card.cardholderName,
        type: widget.card.type,
        status: widget.card.status,
        isVirtual: widget.card.isVirtual,
        name: widget.card.name,
        // Updated settings
        atmLimit: atmLimit,
        onlineLimit: onlineLimit,
        dailyLimit: dailyLimit,
        contactlessEnabled: _contactlessEnabled,
        onlinePaymentsEnabled: _onlinePaymentsEnabled,
        internationalPaymentsEnabled: _internationalPaymentsEnabled,
        atmWithdrawalsEnabled: _atmWithdrawalsEnabled,
        transactionNotificationsEnabled: _transactionNotificationsEnabled,
      );

      final success = await cardProvider.updateCardSettings(updatedCard);

      if (mounted) {
        setState(() {
          _isSaving = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card settings updated successfully'),
              backgroundColor: GlobalRemitColors.secondaryGreenLight,
            ),
          );
          Navigator.pop(context, true);
        } else {
          setState(() {
            _errorMessage = 'Failed to update card settings';
          });
        }
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Invalid input. Please enter valid numbers.';
      });
    }
  }

  Widget _buildLimitsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending Limits',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set daily limits for different types of transactions',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // ATM Withdrawal Limit
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ATM Withdrawal Limit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _atmLimitController,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Online Purchase Limit
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Online Purchase Limit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _onlineLimitController,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Daily Spending Limit
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Spending Limit',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dailyLimitController,
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSettingsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Control how and where your card can be used',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            
            // Contactless Payments
            SwitchListTile(
              title: const Text('Contactless Payments'),
              subtitle: const Text('Allow tap-to-pay transactions'),
              value: _contactlessEnabled,
              activeColor: GlobalRemitColors.primaryBlueLight,
              onChanged: (value) {
                setState(() {
                  _contactlessEnabled = value;
                });
              },
            ),
            const Divider(),
            
            // Online Payments
            SwitchListTile(
              title: const Text('Online Payments'),
              subtitle: const Text('Allow online and in-app purchases'),
              value: _onlinePaymentsEnabled,
              activeColor: GlobalRemitColors.primaryBlueLight,
              onChanged: (value) {
                setState(() {
                  _onlinePaymentsEnabled = value;
                });
              },
            ),
            const Divider(),
            
            // International Payments
            SwitchListTile(
              title: const Text('International Payments'),
              subtitle: const Text('Allow purchases from foreign merchants'),
              value: _internationalPaymentsEnabled,
              activeColor: GlobalRemitColors.primaryBlueLight,
              onChanged: (value) {
                setState(() {
                  _internationalPaymentsEnabled = value;
                });
              },
            ),
            const Divider(),
            
            // ATM Withdrawals
            SwitchListTile(
              title: const Text('ATM Withdrawals'),
              subtitle: const Text('Allow cash withdrawals at ATMs'),
              value: _atmWithdrawalsEnabled,
              activeColor: GlobalRemitColors.primaryBlueLight,
              onChanged: (value) {
                setState(() {
                  _atmWithdrawalsEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Control alerts and notifications for this card',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            
            // Transaction Notifications
            SwitchListTile(
              title: const Text('Transaction Alerts'),
              subtitle: const Text('Get notified about all transactions'),
              value: _transactionNotificationsEnabled,
              activeColor: GlobalRemitColors.primaryBlueLight,
              onChanged: (value) {
                setState(() {
                  _transactionNotificationsEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card Name
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.card.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: GlobalRemitColors.primaryBlueLight,
                      ),
                    ),
                  ),
                  
                  if (_errorMessage != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  
                  _buildLimitsSection(),
                  _buildPaymentSettingsSection(),
                  _buildNotificationsSection(),
                  
                  // Save Button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomButton(
                      text: 'Save Settings',
                      isLoading: _isSaving,
                      onPressed: _saveSettings,
                      color: GlobalRemitColors.primaryBlueLight,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}