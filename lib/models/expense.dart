import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

//Enum representing the different categories 
enum Category {food, travel, leisure, work}

final formatter = DateFormat.yMd();

const categoryIcon = {
  Category.food:    Icons.restaurant,
  Category.travel:  Icons.directions_bus,
  Category.leisure: Icons.attractions,
  Category.work:    Icons.badge,
};

/**
 * Data class representing an Expense item
 * 
 * tile: Name of the Expense
 * amount: The Expense amount in NOK
 * date: The date of the Expense
 * category: the category of the Expense  
 */
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  }): id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get fromattedDate {
    return formatter.format(date);
  }
}

/**
 * Takes a List of Expense and a category. 
 * And returns a list with Ekspense with the matching category
 */
class ExpenseBucket{
  const ExpenseBucket({
    required this.category,
    required this.expenses
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses,this.category ) 
    : expenses = allExpenses.where((expense) => expense.category == category)
      .toList();
  
  final Category category;
  final List<Expense> expenses;

  double get totalExpenses{
    double sum = 0;
    
    for (final expense in expenses){
      sum += expense.amount; 
    }
    
    return sum;
  }
}