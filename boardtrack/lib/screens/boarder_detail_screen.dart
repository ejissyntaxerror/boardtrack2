import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/boarder_provider.dart';
import 'package:my_app/screens/add_fee_screen.dart';

class BoarderDetailScreen extends StatefulWidget {
  final int boarderIndex;
  final int selectedMonth;
  final int selectedYear;

  const BoarderDetailScreen({
    Key? key,
    required this.boarderIndex,
    required this.selectedMonth,
    required this.selectedYear,
  }) : super(key: key);

  @override
  State<BoarderDetailScreen> createState() => _BoarderDetailScreenState();
}

class _BoarderDetailScreenState extends State<BoarderDetailScreen> {
  late bool _isPaid;

  @override
  void initState() {
    super.initState();
    _loadPaymentStatus();
  }

  void _loadPaymentStatus() {
    final provider = context.read<BoarderProvider>();
    final boarder = provider.boarders[widget.boarderIndex];
    _isPaid = provider.isPaymentPaid(
      boarder.key,
      widget.selectedMonth,
      widget.selectedYear,
    );
  }

  void _togglePaymentStatus() async {
    final provider = context.read<BoarderProvider>();
    final boarder = provider.boarders[widget.boarderIndex];

    await provider.addPayment(
      boarder.key,
      widget.selectedMonth,
      widget.selectedYear,
      !_isPaid,
    );

    setState(() => _isPaid = !_isPaid);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isPaid ? 'Payment marked as paid' : 'Payment marked as unpaid'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boarder Details'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Consumer<BoarderProvider>(
        builder: (context, provider, _) {
          final boarder = provider.boarders[widget.boarderIndex];
          final balance = provider.getBoarderBalance(
            boarder.key,
            widget.selectedMonth,
            widget.selectedYear,
          );
          final boarderFees = provider.getFeesForBoarder(boarder.key)
            .where((f) => f.feeDate.month == widget.selectedMonth && 
                          f.feeDate.year == widget.selectedYear)
            .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            boarder.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.door_front_door, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text('Room: ${boarder.roomNumber}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.grey.shade600),
                              const SizedBox(width: 8),
                              Text('Monthly Rent: ₱${boarder.monthlyRent.toStringAsFixed(2)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Payment Status - ${DateFormat('MMMM yyyy').format(DateTime(widget.selectedYear, widget.selectedMonth))}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: _isPaid ? Colors.green.shade100 : Colors.red.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status: ${_isPaid ? 'PAID' : 'UNPAID'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isPaid ? Colors.green : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _togglePaymentStatus,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isPaid ? Colors.red : Colors.green,
                              ),
                              child: Text(
                                _isPaid ? 'Mark as Unpaid' : 'Mark as Paid',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Balance',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orange.shade100,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₱${balance.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Additional Fees',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddFeeScreen(
                                boarderIndex: widget.boarderIndex,
                                selectedMonth: widget.selectedMonth,
                                selectedYear: widget.selectedYear,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Fee'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (boarderFees.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          'No fees added for this month',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: boarderFees.length,
                      itemBuilder: (context, index) {
                        final fee = boarderFees[index];
                        return Card(
                          child: ListTile(
                            title: Text(fee.feeName),
                            trailing: Text(
                              '₱${fee.amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Fee?'),
                                  content: Text(
                                    'Are you sure you want to delete ${fee.feeName}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final feeIndex = provider.fees.indexOf(fee);
                                        await provider.deleteFee(feeIndex);
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Fee deleted'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
}
