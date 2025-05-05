import 'package:flutter/material.dart';
import '../../models/withdrawal_method.dart';
import '../../widgets/implementation_badge.dart';
import '../../services/withdrawal_service.dart';
import '../../theme/app_colors.dart';
import 'withdrawal_processing_screen.dart';

class WithdrawalMethodsScreen extends StatefulWidget {
  static const routeName = '/withdrawal-methods';

  const WithdrawalMethodsScreen({Key? key}) : super(key: key);

  @override
  _WithdrawalMethodsScreenState createState() => _WithdrawalMethodsScreenState();
}

class _WithdrawalMethodsScreenState extends State<WithdrawalMethodsScreen> {
  final WithdrawalService _withdrawalService = WithdrawalService();
  bool _isLoading = true;
  List<WithdrawalMethod> _withdrawalMethods = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWithdrawalMethods();
  }

  Future<void> _loadWithdrawalMethods() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // In a real app, this would be an API call
      final methods = await _withdrawalService.getWithdrawalMethods();
      
      setState(() {
        _withdrawalMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load withdrawal methods: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _selectWithdrawalMethod(WithdrawalMethod method) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WithdrawalProcessingScreen(method: method),
      ),
    );
  }

  Widget _buildMethodCard(WithdrawalMethod method) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _selectWithdrawalMethod(method),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    method.icon,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      method.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    if (method.processingTime != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Processing Time: ${method.processingTime}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Methods'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadWithdrawalMethods,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : _withdrawalMethods.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_balance_wallet,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No withdrawal methods available at the moment',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Select withdrawal method',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ..._withdrawalMethods.map(_buildMethodCard).toList(),
                        ],
                      ),
      ),
    );
  }
}