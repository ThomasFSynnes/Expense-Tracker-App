import 'package:expense_tracker/models/expense.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();

/**
 * Display a form where the user can create a new Expense and 
 * save it to the list of their expenses.
 * 
 * Show an error if user input is invalid
 */
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food; //Set default category


   // Display a date picker
   // Limit it to today and on year back in time
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  //Save the expense or show and error if input is invalid
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    //if the user did not fill all the requerd fields
    //show an error dialog
    if (amountIsInvalid ||
        _titleController.text.trim().isEmpty ||
        _selectedDate == null) {
      
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("new_Expense.invalidTitleError".tr()),
                content: Text("new_Expense.invalidMessageError".tr()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text("button.ok".tr()),
                  )
                ],
              ));
      return;
    }

    //add the expense 
    widget.onAddExpense(Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory));
    //Return to the previus screen.
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Title input fiield.
    var titleInputWidget = TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: InputDecoration(
        label: Text("new_Expense.title".tr()),
      ),
    );

    // Title input fiield.
    var amountInputWidget = TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        suffixText: "NOK",
        label: Text("new_Expense.amount".tr()),
      ),
    );

    // Save button
    var saveButton = ElevatedButton(
      onPressed: () {
        _submitExpenseData();
      },
      child: Text("button.save".tr()),
    );

    // Cancel button
    var cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("button.cancel".tr()),
    );

    // Date Selector
    var dateSelector = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _selectedDate == null
              ? "new_Expense.noDate".tr()
              : formatter.format(_selectedDate!),
        ),
        IconButton(
          onPressed: _presentDatePicker,
          icon: const Icon(Icons.calendar_month),
        )
      ],
    );

    // Select Category Dropdown menu
    var selectCategoryMenu = DropdownButton(
      value: _selectedCategory,
      items: Category.values
          .map(
            (category) => DropdownMenuItem(
              value: category,
              child: Text(
                category.name.toUpperCase(),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value == Null) return;

        setState(() {
          _selectedCategory = value!;
        });
      },
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          //Title input field
          titleInputWidget,
          Row(
            children: [
              Expanded(child: amountInputWidget),
              const SizedBox(width: 16),
              Expanded(child: dateSelector),
            ],
          ),

          // Buttons Row
          const SizedBox(width: 16),
          Row(
            children: [
              selectCategoryMenu,
              const Spacer(),
              saveButton,
              cancelButton
            ],
          ),
        ],
      ),
    );
  }
}
