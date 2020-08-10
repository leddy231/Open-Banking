import 'Account.dart';

class Transactions {
  final String amount;
  final String currency;
  final String date;
  final bool pending;
  final Account account;

  Transactions(
      {this.amount, this.currency, this.date, this.pending, this.account});

  Transactions.fromJson(dynamic data, Account acc)
      : amount = data['amount'],
        currency = data['currency'],
        date = data['date'],
        pending = data['pending'],
        account = acc;

  toString() => "Transaction<$amount, $date>";
}
