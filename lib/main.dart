import 'package:first_app/widgets/budget_chart.dart';
import 'package:first_app/widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transactions_list.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ).copyWith(
          primary: Colors.purple,
          secondary: Colors.amberAccent,
        ),
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          titleMedium: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          labelLarge: TextStyle(color: Colors.black),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      home: MyHomePage(title: 'Personal Expenses'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];

  var _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final List<Transaction> mockedValues = [
      Transaction(
          id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now()),
      Transaction(
          id: 't2',
          title: 'New Bag1',
          amount: 9.99,
          date: DateTime.now().subtract(const Duration(days: 1))),
      Transaction(
          id: 't23',
          title: 'New Bag2',
          amount: 5.99,
          date: DateTime.now().subtract(const Duration(days: 2))),
      Transaction(
          id: 't24',
          title: 'New Bag3',
          amount: 5.99,
          date: DateTime.now().subtract(const Duration(days: 4))),
      Transaction(
          id: 't25',
          title: 'New Bag4',
          amount: 6.99,
          date: DateTime.now().subtract(const Duration(days: 3))),
      Transaction(
          id: 't26',
          title: 'New Bag5',
          amount: 3.99,
          date: DateTime.now().subtract(const Duration(days: 5))),
      Transaction(
          id: 't27',
          title: 'New Bag6',
          amount: 6.99,
          date: DateTime.now().subtract(const Duration(days: 4))),
      Transaction(
          id: 't28',
          title: 'New Bag7',
          amount: 6.99,
          date: DateTime.now().subtract(const Duration(days: 3)))
    ];
    final newTx = Transaction(
        title: title,
        amount: amount,
        date: date,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
      _userTransactions.addAll(mockedValues);
    });
  }

  void _startNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(addTx: _addNewTransaction);
        });
  }

  void _deleteTransactions(String idToDelete) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == idToDelete);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    var appBar = AppBar(
      title: const Text('Personal Expenses'),
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: <Widget>[
        IconButton(
          onPressed: () => _startNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    var appBarSize = appBar.preferredSize;
    var systemStatusBarSize = MediaQuery.of(context).padding.top;
    var remainingSize = MediaQuery.of(context).size.height -
        (appBarSize.height + systemStatusBarSize);

    var transactionsListWidget = SizedBox(
      height: remainingSize * 0.75,
      child: TransactionsList(_userTransactions, _deleteTransactions),
    );

    return Scaffold(
      appBar: appBar,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startNewTransaction(context),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FittedBox(
                    child: Text('Show Chart'),
                  ),
                  Switch(
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (isLandScape)
              _showChart
                  ? SizedBox(
                      height: remainingSize * 0.7,
                      child: BudgetChart(transactions: _recentTransactions),
                    )
                  : transactionsListWidget,
            if (!isLandScape)
              SizedBox(
                height: remainingSize * 0.3,
                child: BudgetChart(transactions: _recentTransactions),
              ),
            if (!isLandScape) transactionsListWidget,
          ],
        ),
      ),
    );
  }
}
