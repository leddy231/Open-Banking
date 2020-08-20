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
        .map((snapshot) => snapshot.documents
            .map((doc) => Contact.fromJSON(doc.data))
            .toList());
  }

  static Future<void> addProfile(Profile profile) => Firestore.instance
      .collection('profiles')
      .document(profile.id)
      .setData(profile.toJson());

  static Future<Profile> getProfileById(String id) async {
    final data =
        await Firestore.instance.collection('profiles').document(id).get();
    return Profile.fromJson(data.data);
  }

  static Stream<List<Profile>> allProfiles() =>
      Firestore.instance.collection('profiles').snapshots().map((snap) =>
          snap.documents.map((doc) => Profile.fromJson(doc.data)).toList());

  static Future<void> addFaktura(Faktura faktura) =>
      Firestore.instance.collection('fakturor').add(faktura.toJson());

  static Stream<List<Faktura>> sentFakturor(String userid) => Firestore.instance
      .collection('fakturor')
      .snapshots()
      .map((data) => data.documents
          .map((doc) => Faktura.fromJson(doc.data))
          .where((faktura) => faktura.senderid == userid)
          .toList());

  static Stream<List<Faktura>> receivedFakturor(String userid) => Firestore.instance
      .collection('fakturor')
      .snapshots()
      .map((data) => data.documents
      .map((doc) => Faktura.fromJson(doc.data))
      .where((faktura) => faktura.receiverid == userid)
      .toList());

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

  static Stream<dynamic> transactions(Account acc) {
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
        .map((doc) =>
            doc.data['transactions'] != null ? doc.data['transactions'] : [])
        .map((transactions) => transactions
            .map((item) => Transactions.fromJson(item, acc))
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
