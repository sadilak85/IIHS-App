import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class VehicleData {
  final String id;
  final String slug;
  final String name;

  VehicleData({
    @required this.id,
    @required this.slug,
    @required this.name,
  });

  static List<VehicleData> templateList = [
    VehicleData(
      id: "23",
      slug: 'acura',
      name: 'Acura',
    ),
  ];
}
