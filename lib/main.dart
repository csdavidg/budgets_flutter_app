import 'dart:io';

import 'package:first_app/widgets/budget_chart.dart';
import 'package:first_app/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import './models/transaction.dart';
import './widgets/transactions_list.dart';

import 'package:flutter/material.dart';

void main() {
  //Respecting the Softkeyboard Insets
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var cuppertinoApp = const CupertinoApp(
      title: 'Personal Expenses',
      theme: CupertinoThemeData(
        primaryColor: Colors.purple,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      home: MyHomePage(title: 'Personal Expenses'),
    );

    final materialApp = MaterialApp(
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
      home: const MyHomePage(title: 'Personal Expenses'),
    );

    //return Platform.isIOS ? cuppertinoApp : materialApp;
    return materialApp;
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

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
    if (Platform.isIOS) {
      /*showCupertinoModalPopup(
          context: context,
          builder: (_) {
            return NewTransaction(addTx: _addNewTransaction);
          });*/
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return NewTransaction(addTx: _addNewTransaction);
          });
    } else {
      showModalBottomSheet(
          context: ctx,
          builder: (_) {
            return NewTransaction(addTx: _addNewTransaction);
          });
    }
  }

  void _deleteTransactions(String idToDelete) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == idToDelete);
    });
  }

  List<Widget> _buildLandScape(
      Widget transactionsListWidget, double remainingSize) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              'Show Chart',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).colorScheme.secondary,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? SizedBox(
              height: remainingSize * 0.7,
              child: BudgetChart(transactions: _recentTransactions),
            )
          : transactionsListWidget,
    ];
  }

  List<Widget> _buildPortrait(
      Widget transactionsListWidget, double remainingSize) {
    return [
      SizedBox(
        height: remainingSize * 0.3,
        child: BudgetChart(transactions: _recentTransactions),
      ),
      transactionsListWidget,
    ];
  }

  PreferredSizeWidget _buildCupertinoAppBar(Text pageTittle) {
    return CupertinoNavigationBar(
      middle: pageTittle,
      trailing: GestureDetector(
        child: const Icon(CupertinoIcons.add),
        onTap: () => _startNewTransaction(context),
      ),
    );
  }

  PreferredSizeWidget _buildMaterialAppBar(Text pageTittle) {
    return AppBar(
      title: pageTittle,
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: <Widget>[
        IconButton(
          onPressed: () => _startNewTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    const pageTittle = Text('Personal Expenses');

    var appBar = Platform.isIOS
        ? _buildCupertinoAppBar(pageTittle)
        : _buildMaterialAppBar(pageTittle);

    var appBarSize = appBar.preferredSize;
    var systemStatusBarSize = mediaQuery.padding.top;
    var remainingSize =
        mediaQuery.size.height - (appBarSize.height + systemStatusBarSize);

    var transactionsListWidget = SizedBox(
      height: remainingSize * 0.75,
      child: TransactionsList(_userTransactions, _deleteTransactions),
    );

    var mainBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildLandScape(transactionsListWidget, remainingSize),
            if (!isLandScape)
              ..._buildPortrait(transactionsListWidget, remainingSize),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: mainBody,
            navigationBar: appBar as CupertinoNavigationBar,
          )
        : Scaffold(
            appBar: appBar as AppBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startNewTransaction(context),
                  ),
            body: mainBody,
          );
  }
}
