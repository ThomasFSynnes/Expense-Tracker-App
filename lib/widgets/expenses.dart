import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/options.dart';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/*
 * The main screen of the app
 * 
 * Displays the users Expenses as a graph
 * And a list of all Expenses in a List
 * 
 * If there are no items in the list, display a message stating that.
 * 
 * At the top is a Navbar with 
 * title, seting button, and add new expense button
 */
class Expenses extends StatefulWidget {
  const Expenses({super.key});
  
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}



class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    //Todo: remove test data
    Expense(title: "FLutter Course", amount: 19.99, date: DateTime.now(), category: Category.work),
    Expense(title: "Cinema", amount: 9.99, date: DateTime.now(), category: Category.leisure),
  ];
  
  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text("expenses.emptyList".tr()),
    );

    if(_registerdExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses:_registerdExpenses,
        onRemoveExpense: _removeExpense
      );
    }

    // Top Bar with title and buttons for options and add expense
    var topBar = AppBar(
      title: Text("expenses.title".tr()),
      actions: [
        IconButton(
          onPressed: _openSettingsOverlay,
          icon: const Icon(Icons.settings)
        ),
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add),
        ),
      ],
    );
    
    
    /**
     * app main screen
     */
    return Scaffold(
      // Top Bar with title and buttons for options and add expense
      appBar: topBar,
      body: Column(
        children: [
          //Graphic chart of  expenses
          Chart(expenses: _registerdExpenses),
          
          //Display list of all expenses
          Expanded(child: mainContent),
        ],
      ),
    );
  }

  //Add a new Expense to _registerdExpenses List
  void _addExpense(Expense expense){
    setState(() {
      _registerdExpenses.add(expense); 
    });
  }

  /// Remove an expense and display a timed message to the user. 
  /// Also give the option to undo the removal.
  void _removeExpense(Expense expense){
    final expenseIndex = _registerdExpenses.indexOf(expense);
    setState(() {
      _registerdExpenses.remove(expense);
    });

    //Undo remove
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text("expenses.removed".tr()),
        action: SnackBarAction(
          label: "button.undo".tr(),
          onPressed: (){
            setState(() {
              _registerdExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      )
    );
  }

  //Show options menu
  void _openSettingsOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const Options(),
    );
  }

  //Show Add expense Menu
  void _openAddExpenseOverlay(){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }
}