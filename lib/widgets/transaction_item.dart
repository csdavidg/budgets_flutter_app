import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    required this.deleteTransaction,
  });

  final Transaction transaction;
  final Function(String p1) deleteTransaction;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor = Colors.purple;

  @override
  void initState() {
    const avatarColors = [Colors.blue, Colors.red, Colors.green, Colors.pink];

    _bgColor = avatarColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '\$${widget.transaction.amount}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).colorScheme.error,
          onPressed: () => widget.deleteTransaction(widget.transaction.id),
        ),
      ),
    );
  }
}
