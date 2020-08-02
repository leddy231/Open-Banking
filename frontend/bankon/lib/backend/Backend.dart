
import 'package:bankon/backend/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankon/backend/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Backend {

  static List<Bank> banks;

  static Future<List<Bank>> getBanks() async {
    if(banks != null) {
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

  static Future<Map<String, dynamic>> post(String url, Map<String, String> query) async {
    final uri = Uri.https('bankon.leddy231.se', url, query);
    final response = await http.post(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed post');
    }
  }

  static void getAccounts(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    Backend.post('/accounts', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
  }

  static void getAccountDetails(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    Backend.post('/accountDetails', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
  }

  static Future<String> getConsent(BankAccount acc) async {
    final usertoken = await Auth.user.getIdToken();
    final data = await Backend.post('/consent', {
      'bank': acc.bank.name,
      'accesstoken': acc.accesstoken,
      'firebasetoken': usertoken.token
    });
    return data['url'];
  }
}
  /*
    static const baseurl = "bankon.leddy231.se";

    static Future<List<Bank>> getBanks() async {
      var uri = Uri.https(baseurl, '/banks');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List<String> banknames = data.cast<String>();
          return banknames.map((bank) => Bank(bank)).toList();
      } else {
          throw Exception('Failed to get banks');
      }
    }

    static Future<String> getBankIcon(Bank bank) async {
        var doc = await Firestore.instance.collection('icons').document(bank.name).get();
        return doc['url'];
    }
    
    static Future<String> getRedirectUrl(Bank bank) async {
      var queryParameters = {
        'bank': bank.name,
      };
      var uri = Uri.https(baseurl, '/redirecturl', queryParameters);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
            final data = json.decode(response.body);
            String url = data['url'];
            if(url == null) {
              throw Exception('Url response malformed');
            }
            return url;
        } else {
            throw Exception('Failed to get url');
        }
    }
    */
