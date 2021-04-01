import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class VehicleData {
  final String makeid;
  final String makeslug;
  final String makename;
  final String modelid;
  final String modelslug;
  final String modelname;
  final String modelyears;
  final String seriesid;
  final String seriesvariantTypeId;
  final String seriesslug;
  final String seriesiihsUrl;
  final String seriesname;
  final String vehicleclass;
  final String vehiclemainimage;

  VehicleData({
    @required this.makeid,
    @required this.makeslug,
    @required this.makename,
    this.modelid,
    this.modelslug,
    this.modelname,
    this.modelyears,
    this.seriesid,
    this.seriesvariantTypeId,
    this.seriesslug,
    this.seriesiihsUrl,
    this.seriesname,
    this.vehicleclass,
    this.vehiclemainimage,
  });
}
