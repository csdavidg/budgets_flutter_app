import 'package:first_app/widgets/chart_bars.dart';
import 'package:flutter/material.dart';

import 'package:first_app/models/transaction.dart';
import 'package:intl/intl.dart';

class BudgetChart extends StatelessWidget {
  final List<Transaction> transactions;

  const BudgetChart({super.key, required this.transactions});

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      var weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSpendPerDay = 0.0;
      for (var tx in transactions) {
        if (tx.date.day == weekDay.day &&
            tx.date.month == weekDay.month &&
            tx.date.year == weekDay.year) {
          totalSpendPerDay += tx.amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSpendPerDay
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((txPerDay) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  label: txPerDay['day'].toString(),
                  spendingAmount: txPerDay['amount'] as double,
                  spendingPctOfTotal: totalSpending == 0.0
                      ? 0.0
                      : (txPerDay['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
