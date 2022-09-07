import 'package:expense_tracker/models/transaction_model.dart';

class Invoice {
  final UserData userData;
  final ExpenseData expenseData;
  List<TransactionModel>? items = [];

  Invoice({
    required this.userData,
    required this.expenseData,
     this.items,
  });
}

class UserData {
  final String name;
  final String monthName;
  final DateTime date;

  UserData({
    required this.monthName,
    required this.date,
    required this.name,
  });
}

class ExpenseData {
  final String totalBalance;
  final String totalIncome;
  final String totalExpense;

  ExpenseData(
      {required this.totalBalance,
      required this.totalIncome,
      required this.totalExpense});
}
