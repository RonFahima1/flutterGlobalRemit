import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../models/spending_category.dart';
import '../../models/spending_insights.dart';
import '../../providers/account_provider.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_pie_chart.dart';
import '../../widgets/shimmering_loading_effect.dart';
import 'package:provider/provider.dart';

class SpendingInsightsScreen extends StatefulWidget {
  const SpendingInsightsScreen({Key? key}) : super(key: key);

  @override
  State<SpendingInsightsScreen> createState() => _SpendingInsightsScreenState();
}

class _SpendingInsightsScreenState extends State<SpendingInsightsScreen> {
  bool _isLoading = true;
  SpendingInsights? _insights;
  String _selectedTimeRange = 'This Month';
  int _selectedCategoryIndex = -1;
  
  final List<String> _timeRanges = ['This Month', 'Last Month', '3 Months', '6 Months', '1 Year'];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final accountProvider = Provider.of<AccountProvider>(context, listen: false);
      final timeRange = _getTimeRangeInDays(_selectedTimeRange);
      final insights = await accountProvider.fetchSpendingInsights(timeRange);
      
      if (mounted) {
        setState(() {
          _insights = insights;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load spending insights: ${e.toString()}')),
        );
      }
    }
  }

  int _getTimeRangeInDays(String range) {
    switch (range) {
      case 'This Month':
        return 30;
      case 'Last Month':
        return 60;
      case '3 Months':
        return 90;
      case '6 Months':
        return 180;
      case '1 Year':
        return 365;
      default:
        return 30;
    }
  }

  Widget _buildTimeRangeSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _timeRanges.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final isSelected = _timeRanges[index] == _selectedTimeRange;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_timeRanges[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedTimeRange = _timeRanges[index];
                    _selectedCategoryIndex = -1;
                  });
                  _loadInsights();
                }
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: GlobalRemitColors.primaryBlueLight.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected 
                    ? GlobalRemitColors.primaryBlueLight 
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpendingOverview() {
    if (_insights == null) {
      return const ShimmeringLoadingEffect(height: 120);
    }
    
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
            Text(
              'Spending Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Total Spent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Spent',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '\$${_insights!.totalSpent.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Total Income
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Income',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '\$${_insights!.totalIncome.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GlobalRemitColors.secondaryGreenLight,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            
            // Net Savings
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net Savings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${(_insights!.totalIncome - _insights!.totalSpent).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GlobalRemitColors.primaryBlueLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    if (_insights == null || _insights!.categories.isEmpty) {
      return const ShimmeringLoadingEffect(height: 300);
    }
    
    final categories = _insights!.categories;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spending by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Pie Chart
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 3,
                    child: CustomPieChart(
                      categories: categories,
                      selectedIndex: _selectedCategoryIndex,
                      onSelectionChanged: (index) {
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                    ),
                  ),
                  
                  // Legend
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...categories.asMap().entries.map((entry) {
                            final index = entry.key;
                            final category = entry.value;
                            final isSelected = index == _selectedCategoryIndex;
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryIndex = isSelected ? -1 : index;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: category.color,
                                        shape: BoxShape.circle,
                                        border: isSelected 
                                            ? Border.all(color: Colors.white, width: 2) 
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Selected Category Details
            if (_selectedCategoryIndex >= 0 && _selectedCategoryIndex < categories.length)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categories[_selectedCategoryIndex].color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categories[_selectedCategoryIndex].name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: categories[_selectedCategoryIndex].color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Spent',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '\$${categories[_selectedCategoryIndex].amount.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Percentage',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${(categories[_selectedCategoryIndex].percentage * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildMonthlyTrendChart() {
    if (_insights == null || _insights!.monthlyTrend.isEmpty) {
      return const ShimmeringLoadingEffect(height: 250);
    }
    
    final trend = _insights!.monthlyTrend;
    
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
            Text(
              'Monthly Spending Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1000,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Theme.of(context).dividerColor,
                        strokeWidth: 0.5,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < trend.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('MMM').format(trend[value.toInt()].date),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        trend.length,
                        (index) => FlSpot(index.toDouble(), trend[index].amount),
                      ),
                      isCurved: true,
                      color: GlobalRemitColors.primaryBlueLight,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: GlobalRemitColors.primaryBlueLight,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: GlobalRemitColors.primaryBlueLight.withOpacity(0.2),
                      ),
                    ),
                    // Income line
                    LineChartBarData(
                      spots: List.generate(
                        trend.length,
                        (index) => FlSpot(index.toDouble(), trend[index].income),
                      ),
                      isCurved: true,
                      color: GlobalRemitColors.secondaryGreenLight,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: GlobalRemitColors.secondaryGreenLight,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      dashArray: [5, 5],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: GlobalRemitColors.primaryBlueLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Spending'),
                  ],
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: GlobalRemitColors.secondaryGreenLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text('Income'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingInsights() {
    if (_insights == null || _insights!.insights.isEmpty) {
      return const ShimmeringLoadingEffect(height: 150);
    }
    
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
            Text(
              'Spending Insights',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._insights!.insights.map((insight) {
              IconData icon;
              Color color;
              
              // Determine icon and color based on insight type
              switch (insight.type) {
                case InsightType.saving:
                  icon = Icons.savings;
                  color = GlobalRemitColors.secondaryGreenLight;
                  break;
                case InsightType.warning:
                  icon = Icons.warning_amber;
                  color = GlobalRemitColors.warningOrangeLight;
                  break;
                case InsightType.information:
                  icon = Icons.info;
                  color = GlobalRemitColors.primaryBlueLight;
                  break;
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            insight.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            insight.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spending Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () {
              // Show date range picker
              showDateRangePicker(
                context: context,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now(),
              ).then((dateRange) {
                if (dateRange != null) {
                  // Handle custom date range
                  setState(() {
                    _selectedTimeRange = 'Custom Range';
                  });
                  // Implement custom date range logic
                }
              });
            },
            tooltip: 'Custom Range',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInsights,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInsights,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTimeRangeSelector(),
                    _buildSpendingOverview(),
                    _buildCategoryPieChart(),
                    _buildMonthlyTrendChart(),
                    _buildSpendingInsights(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}