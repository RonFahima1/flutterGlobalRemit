import 'package:flutter/material.dart';
import '../../models/kyc_document.dart';
import '../../services/kyc_service.dart';
import '../../widgets/implementation_badge.dart';
import '../../theme/app_colors.dart';

class AddressVerificationScreen extends StatefulWidget {
  static const routeName = '/kyc/address-verification';

  const AddressVerificationScreen({Key? key}) : super(key: key);

  @override
  _AddressVerificationScreenState createState() => _AddressVerificationScreenState();
}

class _AddressVerificationScreenState extends State<AddressVerificationScreen> {
  final KYCService _kycService = KYCService();
  bool _isLoading = false;
  bool _isUploading = false;
  bool _verificationComplete = false;
  String? _errorMessage;
  String? _selectedDocumentType;
  String? _uploadedDocumentPath;

  final List<String> _documentTypes = [
    'Utility Bill',
    'Bank Statement',
    'Tax Statement',
    'Rental Agreement',
    'Insurance Policy',
    'Government Letter',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDocumentType = _documentTypes[0];
  }

  void _selectDocumentType(String type) {
    setState(() {
      _selectedDocumentType = type;
    });
  }

  Future<void> _uploadDocument() async {
    // In a real app, this would open a file picker to select a document
    setState(() {
      _isUploading = true;
    });

    // Simulate file upload delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _uploadedDocumentPath = 'dummy_document_path.pdf';
      _isUploading = false;
    });
  }

  Future<void> _removeDocument() async {
    setState(() {
      _uploadedDocumentPath = null;
    });
  }

  Future<void> _submitVerification() async {
    if (_uploadedDocumentPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a document first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // In a real app, this would send the document to the server for verification
      await Future.delayed(const Duration(seconds: 2));

      // Call KYC service to submit the document
      await _kycService.submitAddressVerification(
        documentType: _selectedDocumentType!,
        documentPath: _uploadedDocumentPath!,
      );

      setState(() {
        _verificationComplete = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Verification submission failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Widget _buildDocumentTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Document Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedDocumentType,
              items: _documentTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectDocumentType(value);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _getDocumentDescription(_selectedDocumentType!),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _getDocumentDescription(String documentType) {
    switch (documentType) {
      case 'Utility Bill':
        return 'A utility bill (electricity, water, gas) issued within the last 3 months showing your name and address.';
      case 'Bank Statement':
        return 'A bank statement issued within the last 3 months showing your name and address.';
      case 'Tax Statement':
        return 'A tax statement or tax bill issued within the last year showing your name and address.';
      case 'Rental Agreement':
        return 'A valid rental agreement or lease showing your name and address.';
      case 'Insurance Policy':
        return 'A home insurance policy document issued within the last year showing your name and address.';
      case 'Government Letter':
        return 'An official letter from a government agency issued within the last 3 months showing your name and address.';
      default:
        return 'Please select a document type';
    }
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upload Document',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_uploadedDocumentPath != null)
              TextButton.icon(
                onPressed: _removeDocument,
                icon: const Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.red,
                ),
                label: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _uploadedDocumentPath == null
            ? _buildUploadButton()
            : _buildUploadedDocument(),
        const SizedBox(height: 12),
        const Text(
          'Accepted formats: PDF, JPG, PNG (max 5MB)',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: _isUploading ? null : _uploadDocument,
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[400]!,
            style: BorderStyle.dashed,
          ),
        ),
        child: _isUploading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Click to Upload',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'or drag and drop files here',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUploadedDocument() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Icon(
                Icons.description,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Document_${DateTime.now().millisecondsSinceEpoch}.pdf',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Uploaded successfully',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              // In a real app, this would open the document preview
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Document preview would open here'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requirements',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRequirementItem(
          'The document must be issued within the last 3 months (except for tax statements and insurance policies which can be up to 1 year old)',
        ),
        _buildRequirementItem(
          'Your full name must be clearly visible on the document',
        ),
        _buildRequirementItem(
          'Your complete address must be clearly visible on the document',
        ),
        _buildRequirementItem(
          'The document must be in color and fully legible',
        ),
        _buildRequirementItem(
          'All four corners of the document must be visible',
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Document Submitted!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Your address verification document has been submitted successfully. We will review it and update your status within 1-2 business days.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Return to Documents'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Verification'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: _verificationComplete
            ? _buildSuccessScreen()
            : _isLoading
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
                              onPressed: _submitVerification,
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Address Verification',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Please provide a document that proves your current residential address. The document must be recent and clearly show your name and address.',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildDocumentTypeSection(),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            _buildDocumentUploadSection(),
                            const SizedBox(height: 24),
                            const Divider(),
                            const SizedBox(height: 24),
                            _buildRequirementsList(),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _uploadedDocumentPath != null && !_isLoading
                                    ? _submitVerification
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Document',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}