import 'package:flutter/material.dart';
import '../widgets/implementation_progress_badge.dart';
import '../models/beneficiary.dart';
import '../services/transfer_service.dart';
import 'add_beneficiary_screen.dart';
import 'transfer_money_screen.dart';

class BeneficiariesManagementScreen extends StatefulWidget {
  const BeneficiariesManagementScreen({Key? key}) : super(key: key);

  @override
  _BeneficiariesManagementScreenState createState() => _BeneficiariesManagementScreenState();
}

class _BeneficiariesManagementScreenState extends State<BeneficiariesManagementScreen> {
  final TransferService _transferService = TransferService();
  bool _isLoading = false;
  List<Beneficiary> _beneficiaries = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  List<String> _categories = ['All', 'Family', 'Friends', 'Business', 'Bills'];

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBeneficiaries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would come from an API call
      // For now, we'll simulate with mock data
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _beneficiaries = [
          Beneficiary(
            id: '1',
            name: 'John Smith',
            accountNumber: '**** **** **** 1234',
            bankName: 'Example Bank',
            country: 'United States',
            currency: 'USD',
            email: 'john.smith@example.com',
            phone: '+1 (555) 123-4567',
            isFavorite: true,
            lastTransferDate: DateTime.now().subtract(const Duration(days: 7)),
            category: 'Family',
          ),
          Beneficiary(
            id: '2',
            name: 'Jane Doe',
            accountNumber: '**** **** **** 5678',
            bankName: 'Global Bank',
            country: 'United Kingdom',
            currency: 'GBP',
            email: 'jane.doe@example.com',
            phone: '+44 20 1234 5678',
            isFavorite: true,
            lastTransferDate: DateTime.now().subtract(const Duration(days: 14)),
            category: 'Friends',
          ),
          Beneficiary(
            id: '3',
            name: 'Apartment Rent',
            accountNumber: '**** **** **** 9012',
            bankName: 'City Bank',
            country: 'United States',
            currency: 'USD',
            email: 'property@example.com',
            phone: '+1 (555) 987-6543',
            isFavorite: false,
            lastTransferDate: DateTime.now().subtract(const Duration(days: 30)),
            category: 'Bills',
          ),
          Beneficiary(
            id: '4',
            name: 'Mohammed Ali',
            accountNumber: '**** **** **** 3456',
            bankName: 'Emirates Bank',
            country: 'United Arab Emirates',
            currency: 'AED',
            email: 'mohammed.ali@example.com',
            phone: '+971 50 123 4567',
            isFavorite: false,
            lastTransferDate: DateTime.now().subtract(const Duration(days: 45)),
            category: 'Business',
          ),
          Beneficiary(
            id: '5',
            name: 'Maria Garcia',
            accountNumber: '**** **** **** 7890',
            bankName: 'Banco Nacional',
            country: 'Mexico',
            currency: 'MXN',
            email: 'maria.garcia@example.com',
            phone: '+52 55 1234 5678',
            isFavorite: false,
            lastTransferDate: DateTime.now().subtract(const Duration(days: 60)),
            category: 'Family',
          ),
        ];
      });
    } catch (e) {
      _showErrorSnackBar('Error loading beneficiaries: $e');
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

  void _navigateToAddBeneficiary() {
    // In a real app, navigate to a creation screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBeneficiaryScreen()),
    ).then((_) {
      // Refresh the list when returning from add screen
      _loadBeneficiaries();
    });
  }

  void _navigateToEditBeneficiary(Beneficiary beneficiary) {
    // In a real app, navigate to the edit screen with the beneficiary data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit beneficiary feature coming soon!')),
    );
  }

  Future<void> _toggleFavorite(Beneficiary beneficiary) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(milliseconds: 500));

      setState(() {
        _beneficiaries = _beneficiaries.map((b) {
          if (b.id == beneficiary.id) {
            return Beneficiary(
              id: b.id,
              name: b.name,
              accountNumber: b.accountNumber,
              bankName: b.bankName,
              country: b.country,
              currency: b.currency,
              email: b.email,
              phone: b.phone,
              isFavorite: !b.isFavorite,
              lastTransferDate: b.lastTransferDate,
              category: b.category,
            );
          }
          return b;
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            beneficiary.isFavorite
                ? '${beneficiary.name} removed from favorites'
                : '${beneficiary.name} added to favorites',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error updating favorite status: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDeleteBeneficiary(Beneficiary beneficiary) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Beneficiary?'),
          content: Text(
            'Are you sure you want to delete ${beneficiary.name} from your beneficiaries? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteBeneficiary(beneficiary);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBeneficiary(Beneficiary beneficiary) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, this would be an API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _beneficiaries = _beneficiaries.where((b) => b.id != beneficiary.id).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${beneficiary.name} has been deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _showErrorSnackBar('Error deleting beneficiary: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showBeneficiaryOptions(Beneficiary beneficiary) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text('Send Money'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransferMoneyScreen(beneficiary: beneficiary),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Details'),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToEditBeneficiary(beneficiary);
                  },
                ),
                ListTile(
                  leading: Icon(
                    beneficiary.isFavorite ? Icons.star : Icons.star_border,
                  ),
                  title: Text(
                    beneficiary.isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _toggleFavorite(beneficiary);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeleteBeneficiary(beneficiary);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Beneficiary> get _filteredBeneficiaries {
    return _beneficiaries.where((beneficiary) {
      final matchesSearch = beneficiary.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          beneficiary.accountNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          beneficiary.bankName.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 'All' || beneficiary.category == _selectedCategory;
      
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Sort beneficiaries with favorites first
    final sortedBeneficiaries = _filteredBeneficiaries..sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.name.compareTo(b.name);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beneficiaries'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 4,
              totalPhases: 7,
              currentStep: 6,
              totalSteps: 7,
              isInProgress: false,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search and filter bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search beneficiaries',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                }
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Beneficiary list
              Expanded(
                child: sortedBeneficiaries.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: sortedBeneficiaries.length,
                        itemBuilder: (context, index) {
                          final beneficiary = sortedBeneficiaries[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: InkWell(
                              onTap: () => _showBeneficiaryOptions(beneficiary),
                              borderRadius: BorderRadius.circular(12.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    _buildBeneficiaryAvatar(beneficiary),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  beneficiary.name,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ),
                                              if (beneficiary.isFavorite)
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber[600],
                                                  size: 20.0,
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            beneficiary.accountNumber,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Row(
                                            children: [
                                              Text(
                                                beneficiary.bankName,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6.0,
                                                  vertical: 2.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                child: Text(
                                                  beneficiary.currency,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.grey[800],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6.0,
                                                  vertical: 2.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _getCategoryColor(beneficiary.category).withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(4.0),
                                                ),
                                                child: Text(
                                                  beneficiary.category,
                                                  style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: _getCategoryColor(beneficiary.category),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _showBeneficiaryOptions(beneficiary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
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
        onPressed: _navigateToAddBeneficiary,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'No matching beneficiaries found'
                : 'No beneficiaries yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? 'Try changing your search or filter'
                : 'Tap the + button to add your first beneficiary',
            style: TextStyle(color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryAvatar(Beneficiary beneficiary) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: _getAvatarColor(beneficiary.name),
      child: Text(
        _getInitials(beneficiary.name),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
    ];
    
    int hashCode = name.hashCode;
    if (hashCode < 0) hashCode = -hashCode;
    return colors[hashCode % colors.length];
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Family':
        return Colors.green[700]!;
      case 'Friends':
        return Colors.blue[700]!;
      case 'Business':
        return Colors.purple[700]!;
      case 'Bills':
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }
}