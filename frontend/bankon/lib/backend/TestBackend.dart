
import 'dart:io';
import './Backend.dart';

main() async {
  var banks = await Backend.getBanks();
  print(banks);
  exit(0);
}