
import 'package:bankon/backend/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Backend {
    static const baseurl = "https://bankon.leddy231.se";

    static Future<List<Bank>> getBanks() async {
        final response = await http.get(baseurl + '/banks');
        if (response.statusCode == 200) {
            final data = json.decode(response.body);
            List<String> banknames = data.cast<String>();
            return banknames.map((bank) => Bank(bank)).toList();
        } else {
            throw Exception('Failed to get banks');
        }
    }
}