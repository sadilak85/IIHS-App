import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:iihs/utils/apifunctions/crashRatings.dart';

class VehicleData extends CrashRatings {
  final String makeid;
  final String makeslug;
  final String makename;
  final String modelid;
  final String modelslug;
  final String modelname;
  final String modelyear;
  final String seriesid;
  final String seriesvariantTypeId;
  final String seriesslug;
  final String seriesiihsUrl;
  final String seriesname;
  String vehiclemainimage;

  VehicleData({
    @required this.makeid,
    @required this.makeslug,
    @required this.makename,
    this.modelid,
    this.modelslug,
    this.modelname,
    this.modelyear,
    this.seriesid,
    this.seriesvariantTypeId,
    this.seriesslug,
    this.seriesiihsUrl,
    this.seriesname,
    this.vehiclemainimage,
  });
}
