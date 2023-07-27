import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction({super.key, required this.addTx});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void _submit() {
    final title = titleController.text;
    final amount = double.parse(amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.addTx(title, amount);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) => _submit(),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              onSubmitted: (_) => _submit(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.purple,
              ),
              onPressed: _submit,
              child: const Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
