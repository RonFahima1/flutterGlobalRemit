import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/statement.dart';
import '../../providers/account_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_button.dart';
import '../../utils/date_formatter.dart';
import 'package:provider/provider.dart';

class AccountStatementScreen extends StatefulWidget {
  const AccountStatementScreen({Key? key}) : super(key: key);

  @override
  State<AccountStatementScreen> createState() => _AccountStatementScreenState();
}

class _AccountStatementScreenState extends State<AccountStatementScreen> {
  bool _isLoading = true;
  List<Statement> _statements = [];
  Statement? _selectedStatement;
  bool _downloadingPdf = false;
  bool _downloadingCsv = false;

  @override
  void initState() {
    super.initState();
    _loadStatements();
  }

  Future<void> _loadStatements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final statements = await accountProvider.fetchStatements();
      
      if (mounted) {
        setState(() {
          _statements = statements;
          _isLoading = false;
          
          // Select the most recent statement by default
          if (_statements.isNotEmpty) {
            _selectedStatement = _statements.first;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load statements: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _downloadStatement(StatementFormat format) async {
    if (_selectedStatement == null) return;
    
    setState(() {
      if (format == StatementFormat.pdf) {
        _downloadingPdf = true;
      } else {
        _downloadingCsv = true;
      }
    });

    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final success = await accountProvider.downloadStatement(
        _selectedStatement!.id,
        format,
      );
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Statement ${format == StatementFormat.pdf ? 'PDF' : 'CSV'} downloaded successfully',
              ),
              backgroundColor: GlobalRemitColors.secondaryGreenLight,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to download statement'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading statement: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          if (format == StatementFormat.pdf) {
            _downloadingPdf = false;
          } else {
            _downloadingCsv = false;
          }
        });
      }
    }
  }

  String _formatDateRange(DateTime startDate, DateTime endDate) {
    final startFormatted = DateFormat('MMM d').format(startDate);
    final endFormatted = DateFormat('MMM d, yyyy').format(endDate);
    return '$startFormatted - $endFormatted';
  }

  Widget _buildStatementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Available Statements',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_statements.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No statements available yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your monthly statements will appear here',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _statements.length,
            itemBuilder: (context, index) {
              final statement = _statements[index];
              final isSelected = _selectedStatement?.id == statement.id;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isSelected 
                      ? BorderSide(color: GlobalRemitColors.primaryBlueLight, width: 2)
                      : BorderSide.none,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedStatement = statement;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: GlobalRemitColors.primaryBlueLight.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt_long,
                            color: GlobalRemitColors.primaryBlueLight,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMM yyyy').format(statement.startDate),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDateRange(statement.startDate, statement.endDate),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: GlobalRemitColors.primaryBlueLight,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStatementSummary() {
    if (_selectedStatement == null) {
      return const SizedBox.shrink();
    }

    final statement = _selectedStatement!;
    
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statement Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(statement.startDate),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: GlobalRemitColors.primaryBlueLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Opening balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Opening Balance',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '\$${statement.openingBalance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Total deposits
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Deposits',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '+\$${statement.totalDeposits.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: GlobalRemitColors.secondaryGreenLight,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Total withdrawals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Withdrawals',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '-\$${statement.totalWithdrawals.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Closing balance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Closing Balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${statement.closingBalance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GlobalRemitColors.primaryBlueLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Transaction summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Summary',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticRow('Total Transactions', statement.totalTransactions.toString()),
                  _buildStatisticRow('Incoming Transfers', statement.incomingTransfers.toString()),
                  _buildStatisticRow('Outgoing Transfers', statement.outgoingTransfers.toString()),
                  _buildStatisticRow('Card Payments', statement.cardPayments.toString()),
                  _buildStatisticRow('ATM Withdrawals', statement.atmWithdrawals.toString()),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Download buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Download PDF',
                    icon: Icons.picture_as_pdf,
                    isLoading: _downloadingPdf,
                    onPressed: () => _downloadStatement(StatementFormat.pdf),
                    color: GlobalRemitColors.primaryBlueLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Download CSV',
                    icon: Icons.file_download,
                    isLoading: _downloadingCsv,
                    onPressed: () => _downloadStatement(StatementFormat.csv),
                    color: GlobalRemitColors.warningOrangeLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Statements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatements,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatements,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatementsList(),
                    if (_selectedStatement != null)
                      _buildStatementSummary(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}