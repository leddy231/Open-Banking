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
