
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bankon/backend/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Backend {
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
}