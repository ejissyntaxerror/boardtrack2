import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/boarder_provider.dart';

class MonthlySummaryScreen extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  const MonthlySummaryScreen({
    Key? key,
    required this.selectedMonth,
    required this.selectedYear,
  }) : super(key: key);

  @override
  State<MonthlySummaryScreen> createState() => _MonthlySummaryScreenState();
}

class _MonthlySummaryScreenState extends State<MonthlySummaryScreen> {
  late int _currentMonth;
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.selectedMonth;
    _currentYear = widget.selectedYear;
  }

  void _previousMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Summary'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Consumer<BoarderProvider>(
        builder: (context, provider, _) {
          final totalCollected = provider.getTotalRentCollected(_currentMonth, _currentYear);
          final totalUnpaid = provider.getTotalUnpaidRent(_currentMonth, _currentYear);
          final totalFees = provider.getTotalFees(_currentMonth, _currentYear);
          final unpaidCount = provider.getUnpaidBoardersCount(_currentMonth, _currentYear);
          final totalBoarders = provider.boarders.length;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: _previousMonth,
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(DateTime(_currentYear, _currentMonth)),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: _nextMonth,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSummarySection(
                    title: 'Rent Collection',
                    items: [
                      ('Total Rent Collected', '₱${totalCollected.toStringAsFixed(2)}', Colors.green),
                      ('Total Unpaid Rent', '₱${totalUnpaid.toStringAsFixed(2)}', Colors.red),
                      ('Total Expected', '₱${(totalCollected + totalUnpaid).toStringAsFixed(2)}', Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSummarySection(
                    title: 'Boarders Status',
                    items: [
                      ('Paid Boarders', '${totalBoarders - unpaidCount}/$totalBoarders', Colors.green),
                      ('Unpaid Boarders', '$unpaidCount/$totalBoarders', Colors.red),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Additional Fees',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₱${totalFees.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.purple.shade100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Revenue',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₱${(totalCollected + totalFees).toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),
                  const Text(
                    'Boarder Breakdown',
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
                          'No boarders',
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
                          _currentMonth,
                          _currentYear,
                        );
                        final balance = provider.getBoarderBalance(
                          boarder.key,
                          _currentMonth,
                          _currentYear,
                        );

                        return Card(
                          child: ListTile(
                            title: Text(boarder.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Room: ${boarder.roomNumber}'),
                                const SizedBox(height: 4),
                                Text(
                                  'Balance: ₱${balance.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: isPaid ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummarySection({
    required String title,
    required List<(String label, String value, Color color)> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) {
          final (label, value, color) = item;
          return Card(
            elevation: 1,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color.withValues(alpha: 0.1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
