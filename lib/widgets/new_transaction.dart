import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction({super.key, required this.addTx});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  var _dateTx;

  void _submit() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.addTx(title, amount, _dateTx);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 10)),
            lastDate: DateTime.now())
        .then((value) => _dateTx = value);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              style: Theme.of(context).textTheme.titleSmall,
              controller: _titleController,
              onSubmitted: (_) => _submit(),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Amount',
              ),
              style: Theme.of(context).textTheme.titleSmall,
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              onSubmitted: (_) => _submit(),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: <Widget>[
                  Text(_dateTx == null
                      ? 'No Date Chosen!'
                      : DateFormat.yMMMMd().format(_dateTx)),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Chose Date',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Transaction'),
            )
          ],
        ),
      ),
    );
  }
}
