import 'package:first_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class TransactionsList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) deleteTransaction;

  const TransactionsList(this.transactions, this.deleteTransaction,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset('assets/images/waiting.jpg',
                        fit: BoxFit.cover),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return TransactionItem(
                  transaction: transactions[index],
                  deleteTransaction: deleteTransaction);
            },
            itemCount: transactions.length,
          );
  }
}
