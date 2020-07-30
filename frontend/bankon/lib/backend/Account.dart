import 'Backend.dart';

class BankAccount {
  final String accesstoken;
  final Bank bank;
  final bool consent;
  BankAccount(this.accesstoken, this.consent, this.bank) {
    bank.account = this;
  }
}

class Bank {
    final String name;
    final String redirecturl;
    final String iconurl;
    BankAccount account;
    Bank(this.name, this.iconurl, this.redirecturl);
    String toString() => 'Bank<$name>';
}

enum AccountNrType {
    iban,
    bban,
}

class AccountNr {
    final String number;
    final AccountNrType type;
    AccountNr(this.number, this.type);
    String toString() => 'AccountNr<$type:$number>';
}

class Account {
    final Bank bank;
    final String id;
    final List<AccountNr> numbers;
    final String currency;
    //final String owner;
    final String balance;
    final String type;
    //final String status;
    //final String bic;
    Account._create({this.bank, this.id, this. numbers, this.currency, this.balance, this.type});
    String toString() => 'Account<$id>';

    static Account fromJson(Map<String, dynamic> data) {
        try {
            var bank = Backend.banks.firstWhere((bank) => bank.name == data['bank']);
            List<AccountNr> numbers = [];
            data['account_numbers'].forEach((nr) {
              var type;
              if (nr['type'] == 'IBAN') {
                type = AccountNrType.iban;
              }
              if (nr['type'] == 'BBAN') {
                type = AccountNrType.bban;
              }
              if(type == null) {
                throw "Unknown account number type '${nr['type']}'";
              }
              numbers.add(AccountNr(nr['number'], type));
            });
            return Account._create(
                bank: bank,
                id: data['account_id'],
                numbers: numbers,
                currency: data['account_currency'],
                //owner: data['account_owner'],
                balance: data['account_balance'],
                type: data['account_type'],
                //status: data['account_status'],
                //bic: data['account_bic']
            );
        } catch (e) {
            throw "Failure to parse bank data\n" + e.toString();
        }
    }
}