// To parse this JSON data, do
//
//     final museums = museumsFromJson(jsonString);

import 'dart:convert';

Museums museumsFromJson(String str) => Museums.fromJson(json.decode(str));

String museumsToJson(Museums data) => json.encode(data.toJson());

class Museums {
  Museums({
    required this.version,
    required this.generator,
    required this.osm3S,
    required this.elements,
  });

  double version;
  String generator;
  Osm3S osm3S;
  List<Element> elements;

  factory Museums.fromJson(Map<String, dynamic> json) => Museums(
        version: json["version"].toDouble(),
        generator: json["generator"],
        osm3S: Osm3S.fromJson(json["osm3s"]),
        elements: List<Element>.from(
            json["elements"].map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        "generator": generator,
        "osm3s": osm3S.toJson(),
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}

class Element {
  Element({
    required this.type,
    required this.id,
    required this.lat,
    required this.lon,
    required this.tags,
    this.distance,
  });

  String type;
  int id;
  double lat;
  double lon;
  Tags tags;
  double? distance;

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        type: json["type"],
        id: json["id"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        tags: Tags.fromJson(json["tags"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "id": id,
        "lat": lat,
        "lon": lon,
        "tags": tags.toJson(),
      };
}

class Tags {
  Tags({
    this.manMade,
    this.name,
    this.surveillance,
    this.tourism,
    this.addrCity,
    this.addrCountry,
    this.addrHousenumber,
    this.addrPostcode,
    this.addrStreet,
    this.addrSuburb,
    this.source,
    this.fee,
    this.openingHours,
    this.website,
    this.contactPhone,
    this.oldName,
    this.startDate,
    this.tagsOperator,
    this.wheelchair,
  });

  String? manMade;
  String? name;
  String? surveillance;
  String? tourism;
  String? addrCity;
  String? addrCountry;
  String? addrHousenumber;
  String? addrPostcode;
  String? addrStreet;
  String? addrSuburb;
  String? source;
  String? fee;
  String? openingHours;
  String? website;
  String? contactPhone;
  String? oldName;
  String? startDate;
  String? tagsOperator;
  String? wheelchair;

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
        manMade: json["man_made"] == null ? null : json["man_made"],
        name: json["name"] == null ? null : json["name"],
        surveillance:
            json["surveillance"] == null ? null : json["surveillance"],
        tourism: json["tourism"],
        addrCity: json["addr:city"] == null ? null : json["addr:city"],
        addrCountry: json["addr:country"] == null ? null : json["addr:country"],
        addrHousenumber:
            json["addr:housenumber"] == null ? null : json["addr:housenumber"],
        addrPostcode:
            json["addr:postcode"] == null ? null : json["addr:postcode"],
        addrStreet: json["addr:street"] == null ? null : json["addr:street"],
        addrSuburb: json["addr:suburb"] == null ? null : json["addr:suburb"],
        source: json["source"] == null ? null : json["source"],
        fee: json["fee"] == null ? null : json["fee"],
        openingHours:
            json["opening_hours"] == null ? null : json["opening_hours"],
        website: json["website"] == null ? null : json["website"],
        contactPhone:
            json["contact:phone"] == null ? null : json["contact:phone"],
        oldName: json["old_name"] == null ? null : json["old_name"],
        startDate: json["start_date"] == null ? null : json["start_date"],
        tagsOperator: json["operator"] == null ? null : json["operator"],
        wheelchair: json["wheelchair"] == null ? null : json["wheelchair"],
      );

  Map<String, dynamic> toJson() => {
        "man_made": manMade == null ? null : manMade,
        "name": name == null ? null : name,
        "surveillance": surveillance == null ? null : surveillance,
        "tourism": tourism,
        "addr:city": addrCity == null ? null : addrCity,
        "addr:country": addrCountry == null ? null : addrCountry,
        "addr:housenumber": addrHousenumber == null ? null : addrHousenumber,
        "addr:postcode": addrPostcode == null ? null : addrPostcode,
        "addr:street": addrStreet == null ? null : addrStreet,
        "addr:suburb": addrSuburb == null ? null : addrSuburb,
        "source": source == null ? null : source,
        "fee": fee == null ? null : fee,
        "opening_hours": openingHours == null ? null : openingHours,
        "website": website == null ? null : website,
        "contact:phone": contactPhone == null ? null : contactPhone,
        "old_name": oldName == null ? null : oldName,
        "start_date": startDate == null ? null : startDate,
        "operator": tagsOperator == null ? null : tagsOperator,
        "wheelchair": wheelchair == null ? null : wheelchair,
      };
}

class Osm3S {
  Osm3S({
    required this.timestampOsmBase,
    required this.timestampAreasBase,
    required this.copyright,
  });

  DateTime timestampOsmBase;
  DateTime timestampAreasBase;
  String copyright;

  factory Osm3S.fromJson(Map<String, dynamic> json) => Osm3S(
        timestampOsmBase: DateTime.parse(json["timestamp_osm_base"]),
        timestampAreasBase: DateTime.parse(json["timestamp_areas_base"]),
        copyright: json["copyright"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp_osm_base": timestampOsmBase.toIso8601String(),
        "timestamp_areas_base": timestampAreasBase.toIso8601String(),
        "copyright": copyright,
      };
}
