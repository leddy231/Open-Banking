import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Auth.dart';
import 'Bank.dart';
import 'Contact.dart';
import 'Database.dart';

export 'Account.dart';
export 'Auth.dart';
export 'Bank.dart';
export 'Contact.dart';
export 'Database.dart';
export 'Transaction.dart';
export 'Profile.dart';
export 'Faktura.dart';

abstract class Backend {
  static void setup() {
    //adb shell 'am start -W -a android.intent.action.VIEW -c android.intent.category.BROWSABLE -d "https://thebankonproject.se/test"'
    Auth.setupIntercept();
    Auth.setupLoginFix();
    Database.getBanks();
  }

  static Future<Map<String, dynamic>> post(
      String url, Map<String, String> query,
      [Map<String, dynamic> body]) async {
    if (body == null) {
      body = {};
    }
    final uri = Uri.https('thebankonproject.se', url, query);
    final response = await http.post(uri, body: jsonEncode(body));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed post');
    }
  }

  static void getAccounts(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    post('/accounts', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
  }

  static void getAccountDetails(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    post('/accountDetails', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
  }

  static Future<String> getConsent(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    final data = await post('/consent', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
    return data['url'];
  }

  static void createContact(Contact con) async {
    final usertoken = await Auth.user.getIdToken();
    final data = await post(
        '/contact', {'firebasetoken': usertoken.token}, con.toJSON());
    return data['url'];
  }
}
