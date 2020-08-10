import 'package:cloud_firestore/cloud_firestore.dart';
import 'Account.dart';
import 'Auth.dart';
import 'Bank.dart';
import 'Backend.dart';
import 'Contact.dart';
import 'Transaction.dart';

abstract class Database {
  static List<Bank> banks;

  static Stream<List<Contact>> contacts() {
    if (Auth.user == null) {
      return Stream.empty();
      throw "Tried to get contacts list with no logged in Firebase user";
    }
    return Firestore.instance
        .collection('users')
        .document(Auth.user.uid)
        .collection('contacts')
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((doc) => Contact.fromJSON(doc.data)).toList());
  }

  static Stream<List<BankAccount>> bankAccounts() {
    if (Auth.user == null) {
      return Stream.empty();
      throw "Tried to get bankaccount list with no logged in Firebase user";
    }
    return Firestore.instance
        .collection('users')
        .document(Auth.user.uid)
        .collection('banks')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => BankAccount(
                doc.data['accesstoken'],
                doc.data['consent'],
                Database.banks
                    .firstWhere((bank) => bank.name == doc.documentID)))
            .toList());
  }

  static Stream<List<Account>> accounts() {
    if (Auth.user == null) {
      return Stream.empty();
      throw "Tried to get account list with no logged in Firebase user";
    }
    return Firestore.instance
        .collection('users')
        .document(Auth.user.uid)
        .collection('accounts')
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((doc) => Account.fromJson(doc.data, Auth.user.uid))
            .toList());
  }

  static Stream<List<Transactions>> transactions(Account acc) {
    if (Auth.user == null) {
      return Stream.empty();
      throw "Tried to get transaction list with no logged in Firebase user";
    }
    if (acc.bank.account == null || acc.bank.account.consent == false) {
      return Stream.empty();
    }
    return Firestore.instance
        .collection('users')
        .document(acc.userid)
        .collection('accounts')
        .document(acc.id)
        .snapshots()
        .map((doc) => doc.data['transactions']
            .map((transactiondata) =>
                Transactions.fromJson(transactiondata, acc))
            .toList());
  }

  static Future<List<Bank>> getBanks() async {
    if (banks != null) {
      return banks;
    }
    var snapshot = await Firestore.instance.collection('banks').getDocuments();
    final List<Bank> ret = [];
    for (var doc in snapshot.documents) {
      ret.add(
          Bank(doc.data['name'], doc.data['icon'], doc.data['redirecturl']));
    }
    banks = ret;
    return ret;
  }
}
