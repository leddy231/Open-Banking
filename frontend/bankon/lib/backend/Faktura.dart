import 'package:decimal/decimal.dart';

class Faktura {
  final String name;
  final String senderid;
  final String receiverid;
  final List<DateTime> days;
  final Decimal cost;
  final Decimal moms;
  final String description;

  Faktura(
      {this.name,
      this.senderid,
      this.receiverid,
      this.days,
      this.cost,
      this.moms,
      this.description});

  Faktura.fromJson(dynamic data)
      : name = data['name'],
        senderid = data['senderid'],
        receiverid = data['receiverid'],
        days = List<DateTime>.from(data['days']
            .map((date) => DateTime.fromMillisecondsSinceEpoch(date))
            .toList()),
        cost = Decimal.parse(data['cost']),
        moms = Decimal.parse(data['moms']),
        description = data['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'senderid': senderid,
        'receiverid': receiverid,
        'days': days.map((e) => e.millisecondsSinceEpoch).toList(),
        'cost': cost.toStringAsExponential(),
        'moms': moms.toStringAsExponential(),
        'description': description
      };

  String toString() => toJson().toString();
}
