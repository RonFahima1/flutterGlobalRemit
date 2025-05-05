import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../models/beneficiary.dart';
import '../models/currency.dart';
import '../services/transfer_service.dart';
import '../utils/progress_tracker.dart';
import '../widgets/implementation_progress_badge.dart';

class QRPaymentScreen extends StatefulWidget {
  const QRPaymentScreen({Key? key}) : super(key: key);

  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> with SingleTickerProviderStateMixin {
  // Screen implementation information
  final int _screenNumber = 21;
  final String _screenName = 'QR Payment Screen';
  
  // UI state variables
  bool _showProgress = false;
  bool _isLoading = false;
  String? _errorMessage;
  int _currentTab = 0;
  
  // Controllers
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrViewController;
  
  // Data variables
  List<Beneficiary> _recentBeneficiaries = [];
  Beneficiary? _selectedBeneficiary;
  Currency _selectedCurrency = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  String? _scannedData;
  bool _cameraPermissionDenied = false;
  bool _flashOn = false;
  bool _frontCamera = false;
  
  // Services
  final TransferService _transferService = TransferService();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTab = _tabController.index;
      });
    });
    _loadBeneficiaries();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _qrViewController?.dispose();
    super.dispose();
  }
  
  void _toggleProgressDisplay() {
    setState(() {
      _showProgress = !_showProgress;
    });
  }
  
  void _loadBeneficiaries() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final beneficiaries = await _transferService.getBeneficiaries();
      
      setState(() {
        _recentBeneficiaries = beneficiaries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load beneficiaries: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  void _handleBeneficiarySelected(Beneficiary beneficiary) {
    setState(() {
      _selectedBeneficiary = beneficiary;
    });
  }
  
  void _handleCurrencyChanged(Currency currency) {
    setState(() {
      _selectedCurrency = currency;
    });
  }
  
  void _handleGenerateQR() {
    // Validate input
    if (_amountController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an amount';
      });
      return;
    }
    
    if (_selectedBeneficiary == null) {
      setState(() {
        _errorMessage = 'Please select a beneficiary';
      });
      return;
    }
    
    // Clear error message if validation passes
    setState(() {
      _errorMessage = null;
    });
  }
  
  void _handleQRScanSuccess(String data) {
    HapticFeedback.mediumImpact();
    setState(() {
      _scannedData = data;
    });
    
    // Parse the QR data and navigate to the appropriate screen
    try {
      final paymentData = _parseQRData(data);
      
      // Navigate to confirmation screen
      Navigator.of(context).pushNamed(
        '/transfer-confirmation',
        arguments: {
          'amount': paymentData['amount'].toString(),
          'sourceCurrency': _selectedCurrency,
          'beneficiary': _selectedBeneficiary,
          'note': paymentData['note'],
          'qrReference': paymentData['reference'],
          'isQRPayment': true,
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid QR code format: ${e.toString()}';
      });
    }
  }
  
  Map<String, dynamic> _parseQRData(String data) {
    // In a real app, this would parse a structured JSON or other format
    // For demo purposes, just return some mock data
    return {
      'amount': 100.00,
      'currency': 'USD',
      'beneficiaryId': 'ben_001',
      'note': 'Payment via QR code',
      'reference': 'QR${DateTime.now().millisecondsSinceEpoch}',
    };
  }
  
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrViewController = controller;
    });
    
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && _scannedData == null) {
        _handleQRScanSuccess(scanData.code!);
      }
    });
  }
  
  void _toggleFlash() async {
    await _qrViewController?.toggleFlash();
    setState(() {
      _flashOn = !_flashOn;
    });
  }
  
  void _flipCamera() async {
    await _qrViewController?.flipCamera();
    setState(() {
      _frontCamera = !_frontCamera;
    });
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
            const Text('QR Payment'),
            Text(
              'Screen ${_screenNumber}/41',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF0066CC),
          labelColor: const Color(0xFF0066CC),
          unselectedLabelColor: Colors.grey.shade600,
          tabs: const [
            Tab(
              icon: Icon(Icons.qr_code_scanner),
              text: 'Scan',
            ),
            Tab(
              icon: Icon(Icons.qr_code),
              text: 'Generate',
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
            
            // Main content based on tab selection
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Scan QR Tab
                  _buildScanQRTab(),
                  
                  // Generate QR Tab
                  _buildGenerateQRTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildScanQRTab() {
    // Show scanned data result
    if (_scannedData != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'QR Code Scanned Successfully!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _scannedData = null;
                });
              },
              child: const Text('Scan Again'),
            ),
          ],
        ),
      );
    }
    
    // Camera permission denied message
    if (_cameraPermissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Camera Permission Required',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enable camera permission to scan QR codes',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _cameraPermissionDenied = false;
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
    
    // QR Scanner view
    return Stack(
      alignment: Alignment.center,
      children: [
        // QR View
        QRView(
          key: _qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
            borderColor: const Color(0xFF0066CC),
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250,
          ),
        ),
        
        // Scanner UI elements
        Column(
          children: [
            const SizedBox(height: 32),
            const Text(
              'Point camera at a QR code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            const Spacer(),
            
            // Camera controls
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: _toggleFlash,
                    icon: Icon(
                      _flashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _flipCamera,
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildGenerateQRTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error message
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
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select beneficiary
                  _buildSectionTitle('Select Recipient'),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildBeneficiarySelector(),
                  
                  const SizedBox(height: 24),
                  
                  // Amount input
                  _buildSectionTitle('Amount'),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixText: _selectedCurrency.symbol,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]')),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Note input
                  _buildSectionTitle('Note (Optional)'),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Add a note to the recipient',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 2,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Generate QR button
                  if (_amountController.text.isNotEmpty && _selectedBeneficiary != null)
                    Center(
                      child: ElevatedButton(
                        onPressed: _handleGenerateQR,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Generate QR Code'),
                      ),
                    ),
                  
                  const SizedBox(height: 32),
                  
                  // QR Code display
                  if (_amountController.text.isNotEmpty && _selectedBeneficiary != null)
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: QrImage(
                              data: _generateQRData(),
                              version: QrVersions.auto,
                              size: 250,
                              gapless: true,
                              errorStateBuilder: (context, error) {
                                return Container(
                                  width: 250,
                                  height: 250,
                                  color: Colors.white,
                                  child: Center(
                                    child: Text(
                                      'Error:\n${error.toString()}',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                              embeddedImage: const AssetImage('assets/images/app_logo.png'),
                              embeddedImageStyle: QrEmbeddedImageStyle(
                                size: const Size(40, 40),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Scan to send ${_selectedCurrency.symbol}${_amountController.text} to ${_selectedBeneficiary?.name}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                'Secure payment via Global Remit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBeneficiarySelector() {
    if (_recentBeneficiaries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.person_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No beneficiaries found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add a beneficiary to generate a payment QR code',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/beneficiaries');
              },
              child: const Text('Add Beneficiary'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Horizontal list of beneficiaries
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recentBeneficiaries.length,
            itemBuilder: (context, index) {
              final beneficiary = _recentBeneficiaries[index];
              final isSelected = _selectedBeneficiary?.id == beneficiary.id;
              
              // Generate avatar color from beneficiary ID
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
              
              final colorIndex = beneficiary.id.hashCode % colors.length;
              final avatarColor = colors[colorIndex.abs()];
              
              // Generate initials from name
              final nameParts = beneficiary.name.split(' ');
              String initials;
              if (nameParts.length > 1) {
                initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
              } else {
                initials = nameParts[0].substring(0, 1).toUpperCase();
              }
              
              return GestureDetector(
                onTap: () => _handleBeneficiarySelected(beneficiary),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF0066CC) : avatarColor,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: const Color(0xFF0066CC), width: 2)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0066CC).withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        beneficiary.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? const Color(0xFF0066CC) : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        
        // Text indication of selected beneficiary
        if (_selectedBeneficiary != null) ...[
          const SizedBox(height: 8),
          Text(
            'Payment to: ${_selectedBeneficiary!.name}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF0066CC),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
  
  String _generateQRData() {
    // In a real app, this would be a structured JSON or other format
    final data = {
      'type': 'payment',
      'amount': _amountController.text,
      'currency': _selectedCurrency.code,
      'beneficiary': {
        'id': _selectedBeneficiary?.id,
        'name': _selectedBeneficiary?.name,
      },
      'note': _noteController.text,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'reference': 'QR${DateTime.now().millisecondsSinceEpoch}',
    };
    
    return data.toString();
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