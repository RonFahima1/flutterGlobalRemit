import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../widgets/implementation_progress_badge.dart';
import '../models/transfer.dart';
import '../services/transfer_service.dart';
import '../utils/currency_utils.dart';
import 'transfer_confirmation_screen.dart';

class QRPaymentScreen extends StatefulWidget {
  const QRPaymentScreen({Key? key}) : super(key: key);

  @override
  _QRPaymentScreenState createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransferService _transferService = TransferService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = false;
  String _qrData = '';
  String _scanResult = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _updateQRData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _updateQRData() {
    // Generate QR data with user ID, amount (if provided), and note (if provided)
    final userId = "USER123"; // Replace with actual user ID from auth service
    final amount = _amountController.text.isNotEmpty ? _amountController.text : '';
    final note = _noteController.text.isNotEmpty ? _noteController.text : '';
    
    setState(() {
      _qrData = "GLOBALREMIT:$userId:$amount:$note:${DateTime.now().millisecondsSinceEpoch}";
    });
  }

  Future<void> _processScannedQR(String qrCode) async {
    setState(() {
      _isLoading = true;
      _scanResult = qrCode;
    });

    try {
      // Parse QR data to extract recipient info
      final parts = qrCode.split(':');
      if (parts.length >= 2 && parts[0] == 'GLOBALREMIT') {
        final recipientId = parts[1];
        final amount = parts.length > 2 ? parts[2] : '';
        final note = parts.length > 3 ? parts[3] : '';
        
        // Get recipient details from service
        final recipient = await _transferService.getBeneficiaryById(recipientId);
        
        // Navigate to confirmation with extracted data
        if (!mounted) return;
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransferConfirmationScreen(
              transfer: Transfer(
                amount: amount.isNotEmpty ? double.parse(amount) : 0.0,
                recipientName: recipient?.name ?? 'Unknown Recipient',
                recipientAccount: recipient?.accountNumber ?? 'Unknown Account',
                transferMethod: 'QR Payment',
                note: note,
                date: DateTime.now(),
              ),
            ),
          ),
        );
      } else {
        // Invalid QR format
        _showErrorSnackBar('Invalid QR code format');
      }
    } catch (e) {
      _showErrorSnackBar('Error processing QR code: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Payment'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 4,
              totalPhases: 7,
              currentStep: 4,
              totalSteps: 7,
              isInProgress: true,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Scan QR', icon: Icon(Icons.qr_code_scanner)),
            Tab(text: 'My QR Code', icon: Icon(Icons.qr_code)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Scan QR Tab
          _buildScanQRTab(),
          
          // Generate QR Tab
          _buildGenerateQRTab(),
        ],
      ),
    );
  }

  Widget _buildScanQRTab() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                margin: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null && barcode.rawValue != _scanResult) {
                          _processScannedQR(barcode.rawValue!);
                          break;
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Point your camera at a Global Remit QR code",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "QR codes can be used for quick payment to any Global Remit user",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Loading overlay
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildGenerateQRTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Text(
                    "Your Personal QR Code",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QrImageView(
                      data: _qrData,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Others can scan this code to pay you directly",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Payment Request Details (Optional)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _updateQRData(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'Note',
              prefixIcon: Icon(Icons.note),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _updateQRData(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Share QR code functionality would be here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('QR code sharing coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Share QR Code'),
          ),
        ],
      ),
    );
  }
}