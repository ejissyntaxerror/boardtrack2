import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/boarder_provider.dart';
import 'package:my_app/screens/add_boarder_screen.dart';
import 'package:my_app/screens/boarder_detail_screen.dart';
import 'package:my_app/screens/monthly_summary_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedMonth;
  late int _selectedYear;
  String _filterPeriod = 'current';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  void _updateFilter(String period) {
    final now = DateTime.now();
    setState(() {
      _filterPeriod = period;
      if (period == 'current') {
        _selectedMonth = now.month;
        _selectedYear = now.year;
      } else if (period == 'previous') {
        if (now.month == 1) {
          _selectedMonth = 12;
          _selectedYear = now.year - 1;
        } else {
          _selectedMonth = now.month - 1;
          _selectedYear = now.year;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoardTrack'),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: Consumer<BoarderProvider>(
        builder: (context, provider, _) {
          final totalCollected = provider.getTotalRentCollected(_selectedMonth, _selectedYear);
          final totalUnpaid = provider.getTotalUnpaidRent(_selectedMonth, _selectedYear);
          final unpaidCount = provider.getUnpaidBoardersCount(_selectedMonth, _selectedYear);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => _updateFilter('current'),
                          style: TextButton.styleFrom(
                            backgroundColor: _filterPeriod == 'current' 
                              ? Colors.blue.shade700 
                              : Colors.grey.shade200,
                          ),
                          child: Text(
                            'Current',
                            style: TextStyle(
                              color: _filterPeriod == 'current' 
                                ? Colors.white 
                                : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _updateFilter('previous'),
                          style: TextButton.styleFrom(
                            backgroundColor: _filterPeriod == 'previous' 
                              ? Colors.blue.shade700 
                              : Colors.grey.shade200,
                          ),
                          child: Text(
                            'Previous',
                            style: TextStyle(
                              color: _filterPeriod == 'previous' 
                                ? Colors.white 
                                : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () => _updateFilter('all'),
                          style: TextButton.styleFrom(
                            backgroundColor: _filterPeriod == 'all' 
                              ? Colors.blue.shade700 
                              : Colors.grey.shade200,
                          ),
                          child: Text(
                            'All Time',
                            style: TextStyle(
                              color: _filterPeriod == 'all' 
                                ? Colors.white 
                                : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    DateFormat('MMMM yyyy').format(DateTime(_selectedYear, _selectedMonth)),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Total Rent Collected',
                    amount: totalCollected,
                    color: Colors.green,
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Total Unpaid Rent',
                    amount: totalUnpaid,
                    color: Colors.red,
                    icon: Icons.warning,
                  ),
                  const SizedBox(height: 12),
                  _buildSummaryCard(
                    title: 'Unpaid Boarders',
                    amount: unpaidCount.toDouble(),
                    color: Colors.orange,
                    icon: Icons.person_outline,
                    isCount: true,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Boarders',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (provider.boarders.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No boarders yet. Tap + to add one.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.boarders.length,
                      itemBuilder: (context, index) {
                        final boarder = provider.boarders[index];
                        final isPaid = provider.isPaymentPaid(
                          boarder.key,
                          _selectedMonth,
                          _selectedYear,
                        );
                        return Card(
                          child: ListTile(
                            title: Text(boarder.name),
                            subtitle: Text('Room: ${boarder.roomNumber}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isPaid ? 'Paid' : 'Unpaid',
                                style: TextStyle(
                                  color: isPaid ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BoarderDetailScreen(
                                    boarderIndex: index,
                                    selectedMonth: _selectedMonth,
                                    selectedYear: _selectedYear,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MonthlySummaryScreen(
                                selectedMonth: _selectedMonth,
                                selectedYear: _selectedYear,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.assessment),
                        label: const Text('Summary'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddBoarderScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
    bool isCount = false,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isCount 
                      ? '${amount.toInt()} boarders'
                      : '₱${amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
}
