import 'dart:convert';

import 'package:coronavision/models/location_details.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoronaVisionAPI {
  static final client = http.Client();
  // Define the API URI, using cors anywhere
  static final String baseURL = "https://www.coronavision.us";

  // /cases routes
  static final String totalsRoute = "/cases/totals";
  static final String totalsSequenceRoute = "/cases/totals_sequence";
  static final String firstDaysRoute = "/cases/first_days";

  // /list routes
  static final String countriesRoute = "/list/countries";
  static final String provincesRoute = "/list/provinces";
  static final String countiesRoute = "/list/admin2";
  static final String datesRoute = "/list/dates";

  // Map
  static final String geoJSONRoute = "/geojson";


  static Future<List<LocationDetails>> getCases({date, country = "", province="", county=""}) async {
    if(date == null) {
      date = DateFormat("yyyy-MM-dd").format((await getDates())[0]);
    }
    String queryParams = "?country=$country&province=$province&admin2=$county&date=$date";
    var res = await client.get(baseURL + totalsRoute + queryParams);
    final List data = json.decode(res.body);
    return data.map((json) => LocationDetails.fromJSON(json)).toList();
  }

  static Future<Map<DateTime, LocationDetails>> getCasesHistory({country = "", province = "", county=""}) async {
    String queryParams = "?country=$country&province=$province&admin2=$county";
    var res = await client.get(baseURL + totalsSequenceRoute + queryParams);
    final Map<String, dynamic> data = json.decode(res.body);

    Map<DateTime, LocationDetails> finalMap = {};

    List confirmed = data["confirmed"];
    List recovered = data["recovered"];
    List deaths = data["deaths"];
    List active = data["active"];
    List dConfirmed = data["dconfirmed"];
    List dRecovered = data["drecovered"];
    List dDeaths = data["ddeaths"];
    List dActive = data["dactive"];
    List dates = data["entry_date"];

    for(int i = 0; i < dates.length; i++) {
      LocationDetails details = LocationDetails(
        date: DateTime.parse(dates[i]),
        country: country,
        province: province,
        county: county,
        confirmed: confirmed[i],
        recovered: recovered[i],
        deaths: deaths[i],
        active: active[i],
        dConfirmed: dConfirmed[i],
        dRecovered: dRecovered[i],
        dDeaths: dDeaths[i],
        dActive: dActive[i]
      );
      finalMap[DateTime.parse(dates[i])] = details;
    }

    return finalMap;
  }

  static Future<List<String>> getCountries() async {
    var res = await client.get(baseURL + countriesRoute);
    return json.decode(res.body).map((json) => json["country"]);
  }

  static Future<List<String>> getProvinces(country) async {
    String queryParams = "?country=$country";
    var res = await client.get(baseURL + provincesRoute + queryParams);
    return json.decode(res.body).map((json) => json["province"]);
  }

  static Future<List<DateTime>> getDates() async {
    var res = await client.get(baseURL + datesRoute);
    List data = json.decode(res.body);
    return data.map((json) => DateTime.parse(json["entry_date"])).toList();
  }

  static Future<List<GeoJSONDetails>> getGeoJSONRecords({date="live"}) async {
    String queryParams = "?date=$date";
    var res = await client.get(baseURL + geoJSONRoute + queryParams);
    final List<Map> data = json.decode(res.body)["features"];
    return data.map((json) => GeoJSONDetails.fromJSON(json["properties"]));
  }

}