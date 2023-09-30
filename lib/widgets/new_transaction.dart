import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction({super.key, required this.addTx}) {
    print("NewTransaction Constructor");
  }

  @override
  State<NewTransaction> createState() {
    print("create state");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  var _datePicked;

  _NewTransactionState() {
    print("Constructor NewTransactionState");
  }

  @override
  void initState() {
    print("init state");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print("did update $oldWidget");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("Dipose method was called ");
    super.dispose();
  }

  void _submit() {
    final title = _titleController.text;
    final amount = double.parse(_amountController.text);

    if (title.isEmpty || amount <= 0) {
      return;
    }

    widget.addTx(title, amount, _datePicked);
    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(const Duration(days: 10)),
            lastDate: DateTime.now())
        .then((value) => _datePicked = value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
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
                    Text(_datePicked == null
                        ? 'No Date Chosen!'
                        : DateFormat.yMMMMd().format(_datePicked)),
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
      ),
    );
  }
}
