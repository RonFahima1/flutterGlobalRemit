import 'package:flutter/material.dart';
import '../../models/location.dart';
import '../../services/location_service.dart';
import '../../widgets/implementation_badge.dart';
import '../../theme/app_colors.dart';

class ATMBranchLocatorScreen extends StatefulWidget {
  static const routeName = '/atm-branch-locator';

  const ATMBranchLocatorScreen({Key? key}) : super(key: key);

  @override
  _ATMBranchLocatorScreenState createState() => _ATMBranchLocatorScreenState();
}

class _ATMBranchLocatorScreenState extends State<ATMBranchLocatorScreen> with SingleTickerProviderStateMixin {
  final LocationService _locationService = LocationService();
  late TabController _tabController;
  bool _isLoading = true;
  String? _errorMessage;
  List<ServiceLocation> _locations = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  LocationFilter _filter = LocationFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLocations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final locations = await _locationService.getNearbyLocations();

      setState(() {
        _locations = locations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load locations: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<ServiceLocation> get _filteredLocations {
    List<ServiceLocation> filtered = [];
    
    // Apply type filter
    if (_filter == LocationFilter.atm) {
      filtered = _locations.where((location) => location.type == LocationType.atm).toList();
    } else if (_filter == LocationFilter.branch) {
      filtered = _locations.where((location) => location.type == LocationType.branch).toList();
    } else {
      filtered = List.from(_locations);
    }
    
    // Apply search filter if search query exists
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((location) =>
          location.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          location.address.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(LocationFilter filter) {
    setState(() {
      _filter = filter;
    });
  }

  Widget _buildMapView() {
    // In a real app, this would be a map widget with markers for each location
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 80,
            color: AppColors.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Map View',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Showing ${_filteredLocations.length} locations nearby',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Note: In a real implementation, this would display an actual map with markers for each ATM and branch location.',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (_filteredLocations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No locations found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search criteria'
                  : 'Try changing the filter or searching in a different area',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredLocations.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        final location = _filteredLocations[index];
        return _buildLocationCard(location);
      },
    );
  }

  Widget _buildLocationCard(ServiceLocation location) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: location.type == LocationType.atm
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    location.type == LocationType.atm
                        ? Icons.atm
                        : Icons.account_balance,
                    color: location.type == LocationType.atm
                        ? AppColors.primary
                        : AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        location.type == LocationType.atm
                            ? 'ATM'
                            : 'Branch',
                        style: TextStyle(
                          color: location.type == LocationType.atm
                              ? AppColors.primary
                              : AppColors.accent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    '${location.distance.toStringAsFixed(1)} km',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location.address,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            if (location.openingHours != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    location.openingHours!,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (location.phone != null)
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.phone, size: 16),
                    label: const Text('Call'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions, size: 16),
                  label: const Text('Directions'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.primary,
                  ),
                ),
                if (location.type == LocationType.branch)
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.event, size: 16),
                    label: const Text('Book'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      visualDensity: VisualDensity.compact,
                      foregroundColor: AppColors.accent,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All',
            filter: LocationFilter.all,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'ATMs',
            filter: LocationFilter.atm,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Branches',
            filter: LocationFilter.branch,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required LocationFilter filter,
  }) {
    final isSelected = _filter == filter;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _onFilterChanged(filter);
        }
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM & Branch Locator'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.map), text: 'Map'),
            Tab(icon: Icon(Icons.list), text: 'List'),
          ],
          indicatorColor: AppColors.accent,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadLocations,
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
                          hintText: 'Search by name or address',
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
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                    _buildFilterChips(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildMapView(),
                          _buildListView(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

enum LocationFilter {
  all,
  atm,
  branch,
}