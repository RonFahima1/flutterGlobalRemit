import 'package:flutter/material.dart';
import '../../models/faq.dart';
import '../../services/support_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class FAQHelpCenterScreen extends StatefulWidget {
  static const routeName = '/support/faq';

  const FAQHelpCenterScreen({Key? key}) : super(key: key);

  @override
  _FAQHelpCenterScreenState createState() => _FAQHelpCenterScreenState();
}

class _FAQHelpCenterScreenState extends State<FAQHelpCenterScreen>
    with SingleTickerProviderStateMixin {
  final SupportService _supportService = SupportService();
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  
  bool _isLoading = true;
  List<FAQ> _faqs = [];
  List<FAQ> _filteredFaqs = [];
  String? _errorMessage;
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;
  
  final List<String> _categories = [
    'All',
    'Account',
    'Transfers',
    'Cards',
    'Security',
    'Payments',
    'Fees',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadFAQs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategoryIndex = _tabController.index;
      });
      _filterFAQs();
    }
  }

  Future<void> _loadFAQs() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final faqs = await _supportService.getFAQs();
      
      setState(() {
        _faqs = faqs;
        _filterFAQs();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load FAQs: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterFAQs();
  }

  void _filterFAQs() {
    setState(() {
      if (_searchQuery.isEmpty && _selectedCategoryIndex == 0) {
        // No search, all categories
        _filteredFaqs = List.from(_faqs);
      } else if (_searchQuery.isEmpty) {
        // No search, specific category
        _filteredFaqs = _faqs
            .where((faq) => faq.category == _categories[_selectedCategoryIndex])
            .toList();
      } else if (_selectedCategoryIndex == 0) {
        // Search, all categories
        _filteredFaqs = _faqs.where((faq) {
          return faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();
      } else {
        // Search, specific category
        _filteredFaqs = _faqs.where((faq) {
          return faq.category == _categories[_selectedCategoryIndex] &&
              (faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  faq.answer.toLowerCase().contains(_searchQuery.toLowerCase()));
        }).toList();
      }
    });
  }

  Widget _buildFAQList() {
    if (_filteredFaqs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No matching FAQs found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term or category',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/support');
              },
              icon: const Icon(Icons.support_agent),
              label: const Text('Contact Support'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredFaqs.length,
      padding: const EdgeInsets.only(bottom: 24),
      itemBuilder: (context, index) {
        return _buildFAQItem(_filteredFaqs[index]);
      },
    );
  }

  Widget _buildFAQItem(FAQ faq) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            faq.question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              faq.answer,
              style: TextStyle(
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            if (faq.relatedLinks.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Related Links:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              ...faq.relatedLinks.map((link) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap: () {
                        // In a real app, this would navigate to the related link or page
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Opening: ${link.title}')),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.link, size: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            link.title,
                            style: TextStyle(
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Was this helpful?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined),
                      color: Colors.green,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thank you for your feedback')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.thumb_down_alt_outlined),
                      color: Colors.red,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('We\'ll work to improve this answer'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
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
        title: const Text('FAQ & Help Center'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.accent,
        ),
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
                          onPressed: _loadFAQs,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search FAQs...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      _onSearchChanged('');
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                          onChanged: _onSearchChanged,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: List.generate(
                            _categories.length,
                            (index) => _buildFAQList(),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/support/live-chat');
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.support_agent),
        label: const Text('Get Help'),
      ),
    );
  }
}