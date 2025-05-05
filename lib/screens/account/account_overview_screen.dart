import 'package:flutter/material.dart';
import '../../models/account.dart';
import '../../models/transaction.dart';
import '../../models/card.dart';
import '../../providers/account_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/account_balance_card.dart';
import '../../widgets/transaction_list_item.dart';
import '../../widgets/card_preview.dart';
import 'package:provider/provider.dart';
import 'transaction_history_screen.dart';
import 'card_detail_screen.dart';

class AccountOverviewScreen extends StatefulWidget {
  const AccountOverviewScreen({Key? key}) : super(key: key);

  @override
  State<AccountOverviewScreen> createState() => _AccountOverviewScreenState();
}

class _AccountOverviewScreenState extends State<AccountOverviewScreen> {
  bool _isLoading = true;
  bool _isBalanceHidden = false;

  @override
  void initState() {
    super.initState();
    _loadAccountData();
  }

  Future<void> _loadAccountData() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      await accountProvider.fetchAccountDetails();
      
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildBalanceSection(Account account, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isBalanceHidden = !_isBalanceHidden;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          _isBalanceHidden
              ? const Text(
                  '••••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  '\$${account.balance.toStringAsFixed(2)} ${account.currencyCode}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Number',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    account.accountNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to transfer screen
                  Navigator.pushNamed(context, '/transfer');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary, 
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send, size: 16),
                    SizedBox(width: 4),
                    Text('Send'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardsSection(List<BankCard> cards, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Cards',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all cards screen
                  Navigator.pushNamed(context, '/cards');
                },
                child: const Row(
                  children: [
                    Text('View All'),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: cards.isEmpty
              ? Center(
                  child: Text(
                    'No cards found. Add a new card.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: cards.length + 1, // +1 for "Add Card" button
                  itemBuilder: (context, index) {
                    if (index == cards.length) {
                      // Add Card button
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          width: 220,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              // Navigate to add card screen
                              Navigator.pushNamed(context, '/cards/add');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  child: Icon(
                                    Icons.add,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Add New Card',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    
                    final card = cards[index];
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CardDetailScreen(card: card),
                            ),
                          );
                        },
                        child: CardPreview(card: card),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection(List<Transaction> transactions, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TransactionHistoryScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text('See All'),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (transactions.isEmpty)
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'No recent transactions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: transactions.length > 5 ? 5 : transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionListItem(transaction: transaction);
            },
          ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = [
      {
        'icon': Icons.add_circle_outline,
        'color': Theme.of(context).colorScheme.primary,
        'label': 'Deposit',
        'onTap': () => Navigator.pushNamed(context, '/deposit'),
      },
      {
        'icon': Icons.arrow_circle_down_outlined,
        'color': Theme.of(context).colorScheme.secondary,
        'label': 'Withdraw',
        'onTap': () => Navigator.pushNamed(context, '/withdraw'),
      },
      {
        'icon': Icons.swap_horiz,
        'color': Theme.of(context).colorScheme.tertiary,
        'label': 'Transfer',
        'onTap': () => Navigator.pushNamed(context, '/transfer'),
      },
      {
        'icon': Icons.qr_code_scanner_outlined,
        'color': Colors.purple,
        'label': 'Scan',
        'onTap': () => Navigator.pushNamed(context, '/scan'),
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return GestureDetector(
            onTap: button['onTap'] as void Function(),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (button['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    button['icon'] as IconData,
                    color: button['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  button['label'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _loadAccountData,
              child: Consumer<AccountProvider>(
                builder: (context, accountProvider, _) {
                  final account = accountProvider.account;
                  final cards = accountProvider.cards;
                  final transactions = accountProvider.transactions;
                  
                  if (account == null) {
                    return const Center(
                      child: Text('Unable to load account information'),
                    );
                  }
                  
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildBalanceSection(account, context),
                        const SizedBox(height: 8),
                        _buildActionButtons(context),
                        _buildCardsSection(cards, context),
                        _buildRecentTransactionsSection(transactions, context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}