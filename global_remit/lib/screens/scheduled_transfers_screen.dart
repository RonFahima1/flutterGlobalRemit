import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/implementation_progress_badge.dart';
import '../models/transfer.dart';
import '../services/transfer_service.dart';
import '../utils/currency_utils.dart';

class ScheduledTransfer {
  final String id;
  final String recipientName;
  final String recipientAccount;
  final double amount;
  final String currency;
  final DateTime nextDate;
  final String frequency; // 'One-time', 'Weekly', 'Monthly', etc.
  final int occurrences; // Number of transfers, -1 for indefinite
  final int completedOccurrences;
  final bool isActive;

  ScheduledTransfer({
    required this.id,
    required this.recipientName,
    required this.recipientAccount,
    required this.amount,
    required this.currency,
    required this.nextDate,
    required this.frequency,
    required this.occurrences,
    required this.completedOccurrences,
    required this.isActive,
  });
}

class ScheduledTransfersScreen extends StatefulWidget {
  const ScheduledTransfersScreen({Key? key}) : super(key: key);

  @override
  _ScheduledTransfersScreenState createState() => _ScheduledTransfersScreenState();
}

class _ScheduledTransfersScreenState extends State<ScheduledTransfersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransferService _transferService = TransferService();
  bool _isLoading = false;
  List<ScheduledTransfer> _scheduledTransfers = [];
  List<ScheduledTransfer> _pastTransfers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadScheduledTransfers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadScheduledTransfers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would come from an API
      // For now, we'll simulate with mock data
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _scheduledTransfers = [
          ScheduledTransfer(
            id: '1',
            recipientName: 'John Smith',
            recipientAccount: '**** **** **** 1234',
            amount: 500.0,
            currency: 'USD',
            nextDate: DateTime.now().add(const Duration(days: 7)),
            frequency: 'Monthly',
            occurrences: 12,
            completedOccurrences: 3,
            isActive: true,
          ),
          ScheduledTransfer(
            id: '2',
            recipientName: 'Jane Doe',
            recipientAccount: '**** **** **** 5678',
            amount: 1500.0,
            currency: 'EUR',
            nextDate: DateTime.now().add(const Duration(days: 3)),
            frequency: 'Weekly',
            occurrences: 8,
            completedOccurrences: 2,
            isActive: true,
          ),
          ScheduledTransfer(
            id: '3',
            recipientName: 'Rent Payment',
            recipientAccount: '**** **** **** 9012',
            amount: 1200.0,
            currency: 'USD',
            nextDate: DateTime.now().add(const Duration(days: 14)),
            frequency: 'Monthly',
            occurrences: -1, // Indefinite
            completedOccurrences: 5,
            isActive: true,
          ),
        ];
        
        _pastTransfers = [
          ScheduledTransfer(
            id: '4',
            recipientName: 'Car Insurance',
            recipientAccount: '**** **** **** 3456',
            amount: 350.0,
            currency: 'USD',
            nextDate: DateTime.now().subtract(const Duration(days: 5)),
            frequency: 'Monthly',
            occurrences: 12,
            completedOccurrences: 12,
            isActive: false,
          ),
          ScheduledTransfer(
            id: '5',
            recipientName: 'Gym Membership',
            recipientAccount: '**** **** **** 7890',
            amount: 49.99,
            currency: 'USD',
            nextDate: DateTime.now().subtract(const Duration(days: 10)),
            frequency: 'Monthly',
            occurrences: 6,
            completedOccurrences: 6,
            isActive: false,
          ),
        ];
      });
    } catch (e) {
      _showErrorSnackBar('Error loading scheduled transfers: $e');
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

  void _navigateToCreateScheduledTransfer() {
    // In a real app, navigate to a creation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create scheduled transfer feature coming soon!')),
    );
  }

  Future<void> _toggleTransferActive(ScheduledTransfer transfer) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _scheduledTransfers = _scheduledTransfers.map((t) {
          if (t.id == transfer.id) {
            return ScheduledTransfer(
              id: t.id,
              recipientName: t.recipientName,
              recipientAccount: t.recipientAccount,
              amount: t.amount,
              currency: t.currency,
              nextDate: t.nextDate,
              frequency: t.frequency,
              occurrences: t.occurrences,
              completedOccurrences: t.completedOccurrences,
              isActive: !t.isActive,
            );
          }
          return t;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Transfer ${transfer.isActive ? 'paused' : 'resumed'}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error updating transfer: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showTransferDetails(ScheduledTransfer transfer) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Text(
                      'Scheduled Transfer Details',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const Divider(height: 32),
                    _buildDetailRow('Recipient', transfer.recipientName),
                    _buildDetailRow('Account', transfer.recipientAccount),
                    _buildDetailRow('Amount', '${formatCurrency(transfer.amount, transfer.currency)}'),
                    _buildDetailRow('Frequency', transfer.frequency),
                    _buildDetailRow('Next Transfer', DateFormat('MMM dd, yyyy').format(transfer.nextDate)),
                    _buildDetailRow('Status', transfer.isActive ? 'Active' : 'Paused'),
                    _buildDetailRow(
                      'Progress',
                      transfer.occurrences == -1
                          ? '${transfer.completedOccurrences} completed (ongoing)'
                          : '${transfer.completedOccurrences}/${transfer.occurrences} completed',
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _toggleTransferActive(transfer);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(transfer.isActive ? 'Pause' : 'Resume'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              // In a real app, navigate to edit screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Edit transfer feature coming soon!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            child: const Text('Edit'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showCancelConfirmation(transfer);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Cancel Transfer'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCancelConfirmation(ScheduledTransfer transfer) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Scheduled Transfer?'),
          content: Text(
            'Are you sure you want to cancel this scheduled transfer to ${transfer.recipientName}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // In a real app, this would call an API to delete the transfer
                // For now, we'll just show a confirmation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Transfer cancelled successfully')),
                );
                
                // Update UI by removing the transfer
                setState(() {
                  _scheduledTransfers = _scheduledTransfers.where((t) => t.id != transfer.id).toList();
                });
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cancel Transfer'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.right,
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
        title: const Text('Scheduled Transfers'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 4,
              totalPhases: 7,
              currentStep: 5,
              totalSteps: 7,
              isInProgress: false,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming', icon: Icon(Icons.schedule)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle_outline)),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              // Upcoming Transfers Tab
              _buildUpcomingTransfersTab(),
              
              // Completed Transfers Tab
              _buildCompletedTransfersTab(),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateScheduledTransfer,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUpcomingTransfersTab() {
    if (_scheduledTransfers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.schedule,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No scheduled transfers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button to set up a new scheduled transfer',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _scheduledTransfers.length,
      itemBuilder: (context, index) {
        final transfer = _scheduledTransfers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: transfer.isActive ? Colors.transparent : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: () => _showTransferDetails(transfer),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transfer.recipientName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transfer.recipientAccount,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(transfer.amount, transfer.currency),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: transfer.isActive ? Colors.green[50] : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              transfer.isActive ? 'Active' : 'Paused',
                              style: TextStyle(
                                color: transfer.isActive ? Colors.green[800] : Colors.grey[700],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next Transfer',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(transfer.nextDate),
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Frequency',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transfer.frequency,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: transfer.occurrences > 0 ? transfer.completedOccurrences / transfer.occurrences : 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transfer.occurrences == -1
                        ? '${transfer.completedOccurrences} transfers completed (ongoing)'
                        : '${transfer.completedOccurrences}/${transfer.occurrences} transfers completed',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletedTransfersTab() {
    if (_pastTransfers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No completed transfers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Completed scheduled transfers will appear here',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pastTransfers.length,
      itemBuilder: (context, index) {
        final transfer = _pastTransfers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          color: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showTransferDetails(transfer),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transfer.recipientName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transfer.recipientAccount,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(transfer.amount, transfer.currency),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Completed',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last Transfer',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(transfer.nextDate),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Frequency',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transfer.frequency,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${transfer.completedOccurrences}/${transfer.occurrences} transfers completed',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}