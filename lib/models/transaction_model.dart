class TransactionModel {
  int amount;
  final String note;
  final DateTime date;
  final String type;

  // addAmount(int amount) {
  //   this.amount = this.amount + amount;
  // }

  TransactionModel({required this.amount,required this.note,required this.date,required this.type});
}

//
// import 'package:hive/hive.dart';
//
// // to run this "flutter packages pub run build_runner build"
//
// @HiveType(typeId: 1)
// class TransactionModel extends HiveObject {
//   @HiveField(0)
//   int amount;
//   @HiveField(1)
//   final String note;
//   @HiveField(2)
//   final DateTime date;
//   @HiveField(3)
//   final String type;
//
//   // addAmount(int amount) {
//   //   this.amount = this.amount + amount;
//   // }
//
//   TransactionModel(
//       {required this.amount,
//         required this.note,
//         required this.date,
//         required this.type});
// }
//
