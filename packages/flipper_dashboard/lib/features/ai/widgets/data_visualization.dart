import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';

class DataVisualization extends ConsumerWidget {
  final String data;
  final String? currency;

  const DataVisualization({
    super.key,
    required this.data,
    this.currency,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyService = ref.watch(currencyServiceProvider);
    final theme = Theme.of(context);

    // Check if this is a tax calculation response
    if (_isTaxResponse(data)) {
      return _buildTaxVisualization(context, currencyService);
    }

    // Extract summary section for standard business analytics
    final summaryMatch = RegExp(r'\*\*\[SUMMARY\]\*\*(.*?)\*\*\[DETAILS\]\*\*', dotAll: true)
        .firstMatch(data);
    if (summaryMatch == null) return const SizedBox.shrink();

    final summaryText = summaryMatch.group(1)?.trim() ?? '';
    if (summaryText.isEmpty) return const SizedBox.shrink();

    // Parse values from summary
    final revenue = _extractValue(summaryText, 'Total Revenue');
    final profit = _extractValue(summaryText, 'Total Profit');
    final unitsSold = _extractValue(summaryText, 'Total Units Sold');

    if (revenue == null || profit == null || unitsSold == null) {
      return const SizedBox.shrink();
    }

    final formattedRevenue = currencyService.formatCurrencyValue(revenue, currency: currency);
    final formattedProfit = currencyService.formatCurrencyValue(profit, currency: currency);
    final formattedUnitsSold = unitsSold.toStringAsFixed(0);

    final summaryDisplay = 'Summary: Total Revenue: $formattedRevenue, Total Profit: $formattedProfit, Total Units Sold: $formattedUnitsSold';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summaryDisplay,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.87),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: revenue * 1.2,
                  barGroups: [
                    _createBarGroup(0, revenue),
                    _createBarGroup(1, profit),
                    _createBarGroup(2, unitsSold),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final titles = ['Total Revenue', 'Total Profit', 'Total Units Sold'];
                          return Text(
                            titles[value.toInt()],
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isTaxResponse(String text) {
    // Check for tax-related keywords in the response
    return text.contains('Tax Summary') || 
           text.contains('Total Tax Payable') || 
           (text.contains('Tax Breakdown') && text.contains('Tax Rate'));
  }

  Widget _buildTaxVisualization(BuildContext context, dynamic currencyService) {
    final theme = Theme.of(context);
    
    // Extract tax information
    final totalTaxMatch = RegExp(r'Total Tax Payable .*?\*\*RWF ([\d,\.]+)\*\*').firstMatch(data);
    if (totalTaxMatch == null) return const SizedBox.shrink();
    
    final totalTaxStr = totalTaxMatch.group(1)?.replaceAll(',', '') ?? '0';
    final totalTax = double.tryParse(totalTaxStr) ?? 0.0;
    
    // Extract tax breakdown by item
    final taxBreakdownRegex = RegExp(r'\|\s*([^|]+)\s*\|\s*([\d,.]+)\s*\|\s*(\d+)\s*\|\s*(\d+)%\s*\|\s*([\d,.]+)\s*\|');
    final matches = taxBreakdownRegex.allMatches(data);
    
    // Group similar items and calculate their tax contributions
    final Map<String, double> itemTaxContributions = {};
    double otherTaxes = 0.0;
    
    for (final match in matches) {
      final itemName = match.group(1)?.trim() ?? 'Unknown';
      final taxAmountStr = match.group(5)?.replaceAll(',', '') ?? '0';
      final taxAmount = double.tryParse(taxAmountStr) ?? 0.0;
      
      // Skip the total row
      if (itemName.toLowerCase().contains('total')) continue;
      
      // Group by main product name (before comma if present)
      final mainProductName = itemName.split(',').first.trim();
      
      if (taxAmount > 0) {
        if (itemTaxContributions.containsKey(mainProductName)) {
          itemTaxContributions[mainProductName] = (itemTaxContributions[mainProductName] ?? 0) + taxAmount;
        } else {
          // Only keep top 4 items separately, group others as 'Other'
          if (itemTaxContributions.length < 4) {
            itemTaxContributions[mainProductName] = taxAmount;
          } else {
            otherTaxes += taxAmount;
          }
        }
      }
    }
    
    // Add 'Other' category if needed
    if (otherTaxes > 0) {
      itemTaxContributions['Other Items'] = otherTaxes;
    }
    
    // Sort by contribution (highest first)
    final sortedItems = itemTaxContributions.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    // Prepare data for pie chart
    final pieChartSections = <PieChartSectionData>[];
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    
    for (int i = 0; i < sortedItems.length; i++) {
      final item = sortedItems[i];
      final percentage = (item.value / totalTax) * 100;
      
      pieChartSections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: item.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    // Extract date information
    final dateMatch = RegExp(r'Tax Summary for (\d{2}/\d{2}/\d{4})').firstMatch(data);
    final dateStr = dateMatch?.group(1) ?? 'Today';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax Summary for $dateStr',
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  'Total: RWF ${totalTax.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: pieChartSections,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...List.generate(sortedItems.length, (index) {
                          final item = sortedItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  color: colors[index % colors.length],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.key,
                                    style: theme.textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'RWF ${item.value.toStringAsFixed(0)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double? _extractValue(String text, String label) {
    final pattern = RegExp(r'^' + RegExp.escape(label) + r': \$?(\d+(?:,\d{3})*(?:\.\d+)?)', multiLine: true);
    final match = pattern.firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1)?.replaceAll(',', '') ?? '');
  }

  BarChartGroupData _createBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          color: Colors.blue,
        ),
      ],
    );
  }
}
