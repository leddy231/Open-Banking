
import 'dart:io';
import './Backend.dart';

main() async {
  var banks = await Backend.getBanks();
  print(banks);
  var url = await Backend.getBankIcon(banks[0]);
  print(url);
  exit(0);
}